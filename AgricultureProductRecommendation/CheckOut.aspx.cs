using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class Checkout : System.Web.UI.Page
    {
        string connStr = DbConfig.ConnectionString;  // ← was ConfigurationManager

        // Product info loaded from DB — used across methods
        string productName = "";
        decimal productPrice = 0;
        int quantity = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerID"] == null)
            {
                Response.Redirect("~/CustomerLogin.aspx");
                return;
            }

            if (Session["BuyNowProductID"] == null || Session["BuyNowQuantity"] == null)
            {
                Response.Redirect("~/CustomerDashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrderSummary();
            }
        }

        private void LoadOrderSummary()
        {
            int productID = Convert.ToInt32(Session["BuyNowProductID"]);
            quantity = Convert.ToInt32(Session["BuyNowQuantity"]);

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT ProductName, Price FROM Products WHERE ProductID = @ID", con))
            {
                cmd.Parameters.AddWithValue("@ID", productID);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    productName = dr["ProductName"].ToString();
                    productPrice = Convert.ToDecimal(dr["Price"]);
                }
            }

            rptOrderSummary.DataSource = new[] {
                new { ProductName = productName,
                      Price       = productPrice,
                      Quantity    = quantity }
            };
            rptOrderSummary.DataBind();

            decimal total = productPrice * quantity;
            lblTotal.Text = total.ToString("0.00");
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            // Server-side map pin guard
            if (string.IsNullOrWhiteSpace(hdnLatitude.Value) ||
                string.IsNullOrWhiteSpace(hdnLongitude.Value))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "duplicate", "Swal.fire({ icon: 'warning', title: 'Map Error', text: 'Please pin your delivery location on the map.!', confirmButtonColor: '#d33' });", true);
                return;
            }

            if (Session["BuyNowProductID"] == null || Session["BuyNowQuantity"] == null)
            {
                Response.Redirect("~/CustomerDashboard.aspx");
                return;
            }

            int productID = Convert.ToInt32(Session["BuyNowProductID"]);
            int qty = Convert.ToInt32(Session["BuyNowQuantity"]);
            int customerID = Convert.ToInt32(Session["CustomerID"]);
            string customerEmail = Session["CustomerEmail"]?.ToString() ?? "";

            // DEBUG — remove after confirming email works
            System.Diagnostics.Debug.WriteLine("DEBUG EMAIL: [" + customerEmail + "]");
            if (string.IsNullOrWhiteSpace(customerEmail))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "emailDebug",
                    "alert('No email in session — email not sent.');", true);
            }

            // Fetch product details fresh from DB
            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT ProductName, Price FROM Products WHERE ProductID = @ID", con))
            {
                cmd.Parameters.AddWithValue("@ID", productID);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    productName = dr["ProductName"].ToString();
                    productPrice = Convert.ToDecimal(dr["Price"]);
                }
            }

            decimal total = productPrice * qty;
            int orderId = 0;

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            {
                con.Open();
                SqlTransaction txn = con.BeginTransaction();
                try
                {
                    string insertOrder = @"
                        INSERT INTO Orders
                            (CustomerID, FullName, Phone, DeliveryAddress,
                             Latitude, Longitude, PaymentMethod, TotalAmount, OrderDate, Status)
                        OUTPUT INSERTED.OrderID
                        VALUES
                            (@CID, @Name, @Phone, @Address,
                             @Lat, @Lng, @Payment, @Total, GETDATE(), 'Pending')";

                    using (SqlCommand cmd = new SqlCommand(insertOrder, con, txn))
                    {
                        cmd.Parameters.AddWithValue("@CID", customerID);
                        cmd.Parameters.AddWithValue("@Name", txtFullName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                        cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                        cmd.Parameters.AddWithValue("@Lat", hdnLatitude.Value);
                        cmd.Parameters.AddWithValue("@Lng", hdnLongitude.Value);
                        cmd.Parameters.AddWithValue("@Payment", ddlPayment.SelectedValue);
                        cmd.Parameters.AddWithValue("@Total", total);
                        orderId = (int)cmd.ExecuteScalar();
                    }

                    string insertItem = @"
                        INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price)
                        VALUES (@OID, @PID, @Qty, @Price)";

                    using (SqlCommand cmd = new SqlCommand(insertItem, con, txn))
                    {
                        cmd.Parameters.AddWithValue("@OID", orderId);
                        cmd.Parameters.AddWithValue("@PID", productID);
                        cmd.Parameters.AddWithValue("@Qty", qty);
                        cmd.Parameters.AddWithValue("@Price", productPrice);
                        cmd.ExecuteNonQuery();
                    }

                    txn.Commit();
                }
                catch (Exception ex)
                {
                    txn.Rollback();
                    throw new Exception("Something went Wrong!!: " + ex.Message + " | Inner: " + ex.InnerException?.Message);
                }
            }

            Session.Remove("BuyNowProductID");
            Session.Remove("BuyNowQuantity");

            if (!string.IsNullOrWhiteSpace(customerEmail))
                SendOrderEmail(customerEmail, txtFullName.Text.Trim(),
                               orderId, productName, productPrice, qty, total);

            string script = $@"
    Swal.fire({{
        icon: 'success',
        title: 'Order Placed!',
        html: '<p>Your order <strong>#{orderId}</strong> has been placed successfully.</p>' +
              '<p>A confirmation email has been sent to <strong>{customerEmail}</strong>.</p>',
        confirmButtonText: 'Please Check your Email',
        confirmButtonColor: '#198754',
        timer: 5000,
        timerProgressBar: true,
        allowOutsideClick: false,
        allowEscapeKey: false,
    }}).then(function() {{
        window.location.href = '{ResolveUrl("~/OrderSuccess.aspx")}?OrderID={orderId}';
    }});";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "orderSuccess", script, true);
        }

        private void SendOrderEmail(string toEmail, string customerName,
                                    int orderId, string pName,
                                    decimal pPrice, int qty, decimal total)
        {
            try
            {
                string itemRow = $@"
                    <tr>
                      <td style='padding:8px;border:1px solid #ddd'>{pName}</td>
                      <td style='padding:8px;border:1px solid #ddd;text-align:center'>{qty}</td>
                      <td style='padding:8px;border:1px solid #ddd;text-align:right'>Rs. {pPrice:0.00}</td>
                      <td style='padding:8px;border:1px solid #ddd;text-align:right'>Rs. {total:0.00}</td>
                    </tr>";

                string body = $@"
                <html><body style='font-family:Arial,sans-serif;color:#333'>
                  <div style='max-width:600px;margin:auto;border:1px solid #e0e0e0;border-radius:8px;overflow:hidden'>

                    <div style='background:#198754;padding:20px;text-align:center'>
                      <h2 style='color:white;margin:0'>🌿 AgroRecSys</h2>
                      <p style='color:#d4edda;margin:4px 0'>Order Confirmation</p>
                    </div>

                    <div style='padding:24px'>
                      <p>Hi <strong>{customerName}</strong>,</p>
                      <p>Your order has been placed successfully and is being processed.</p>

                      <table style='width:100%;border-collapse:collapse;margin:16px 0'>
                        <tr style='background:#f8f9fa'>
                          <th style='padding:8px;border:1px solid #ddd;text-align:left'>Product</th>
                          <th style='padding:8px;border:1px solid #ddd'>Qty</th>
                          <th style='padding:8px;border:1px solid #ddd;text-align:right'>Unit Price</th>
                          <th style='padding:8px;border:1px solid #ddd;text-align:right'>Total</th>
                        </tr>
                        {itemRow}
                        <tr style='background:#e9f5ee;font-weight:bold'>
                          <td colspan='3' style='padding:8px;border:1px solid #ddd'>Amount Payable</td>
                          <td style='padding:8px;border:1px solid #ddd;text-align:right'>Rs. {total:0.00}</td>
                        </tr>
                      </table>

                      <p><strong>Order ID:</strong> #{orderId}</p>
                      <p><strong>Payment:</strong> Cash on Delivery</p>
                      <p><strong>Delivery Address:</strong> {txtAddress.Text.Trim()}</p>

                      <p style='margin-top:24px;color:#555'>
                        Our team will contact you on
                        <strong>{txtPhone.Text.Trim()}</strong> to confirm delivery.
                      </p>
                    </div>

                    <div style='background:#f8f9fa;padding:16px;text-align:center;font-size:12px;color:#888'>
                      AgroRecSys — Connecting Farmers &amp; Customers
                    </div>
                  </div>
                </body></html>";

                using (var mail = new MailMessage())
                {
                    mail.From = new MailAddress(SmtpConfig.From, "AgroRecSys");  // ← was AppSettings
                    mail.To.Add(toEmail);
                    mail.Subject = $"Order Confirmed #{orderId} — AgroRecSys";
                    mail.Body = body;
                    mail.IsBodyHtml = true;

                    using (var smtp = new SmtpClient(SmtpConfig.Host, int.Parse(SmtpConfig.Port)))  // ← was AppSettings
                    {
                        smtp.Credentials = new NetworkCredential(SmtpConfig.User, SmtpConfig.Pass);  // ← was AppSettings
                        smtp.EnableSsl = true;
                        smtp.Send(mail);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Email failed: " + ex.Message + " | Inner: " + ex.InnerException?.Message);
            }
        }
    }
}