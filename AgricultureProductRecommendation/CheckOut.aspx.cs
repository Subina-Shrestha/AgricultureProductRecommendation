using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class Checkout : Page
    {
        string connStr = WebConfigurationManager
                         .ConnectionStrings["AgroDBCon"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerID"] == null)
                Response.Redirect("~/CustomerLogin.aspx");

            if (!IsPostBack)
            {
                LoadOrderSummary();
                PreFillCustomerDetails();
            }
        }

        // Pre-fill name and phone from Customers table
        private void PreFillCustomerDetails()
        {
            int customerID = Convert.ToInt32(Session["CustomerID"]);

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT FullName, Phone FROM Customers WHERE CustomerID = @CID", con))
            {
                cmd.Parameters.AddWithValue("@CID", customerID);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtFullName.Text = dr["FullName"].ToString();
                    txtPhone.Text = dr["Phone"].ToString();
                }
            }
        }

        private void LoadOrderSummary()
        {
            if (Session["BuyNowProductID"] == null)
            {
                Response.Redirect("~/viewproducts.aspx");
                return;
            }

            int customerID = Convert.ToInt32(Session["CustomerID"]);
            int productID = Convert.ToInt32(Session["BuyNowProductID"]);
            int qty = Session["BuyNowQuantity"] != null
                             ? Convert.ToInt32(Session["BuyNowQuantity"])
                             : 1;

            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                string query = @"SELECT ProductName, Price, PriceUnit,
                                        @Qty AS Quantity
                                 FROM Products
                                 WHERE ProductID = @PID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@PID", productID);
                    cmd.Parameters.AddWithValue("@Qty", qty);
                    dt.Load(cmd.ExecuteReader());
                }
            }

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("~/viewproducts.aspx");
                return;
            }

            rptOrderSummary.DataSource = dt;
            rptOrderSummary.DataBind();

            // Calculate total = unit price × quantity
            decimal total = 0;
            foreach (DataRow row in dt.Rows)
                total += Convert.ToDecimal(row["Price"]) *
                         Convert.ToInt32(row["Quantity"]);

            lblTotal.Text = total.ToString("0.00");
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (Session["BuyNowProductID"] == null)
            {
                Response.Redirect("~/viewproducts.aspx");
                return;
            }

            int customerID = Convert.ToInt32(Session["CustomerID"]);
            int productID = Convert.ToInt32(Session["BuyNowProductID"]);
            int qty = Session["BuyNowQuantity"] != null
                                ? Convert.ToInt32(Session["BuyNowQuantity"])
                                : 1;
            string fullName = txtFullName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim();
            string payment = ddlPayment.SelectedValue;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Get unit price from Products table
                DataTable dt = new DataTable();
                string getPrice = @"SELECT ProductID, Price, @Qty AS Quantity
                                    FROM Products
                                    WHERE ProductID = @PID";

                using (SqlCommand cmd = new SqlCommand(getPrice, con))
                {
                    cmd.Parameters.AddWithValue("@PID", productID);
                    cmd.Parameters.AddWithValue("@Qty", qty);
                    dt.Load(cmd.ExecuteReader());
                }

                if (dt.Rows.Count == 0)
                {
                    Response.Redirect("~/viewproducts.aspx");
                    return;
                }

                // Calculate total = unit price × quantity
                decimal unitPrice = Convert.ToDecimal(dt.Rows[0]["Price"]);
                decimal total = unitPrice * qty;

                // Insert into Orders
                int orderID;
                string orderQuery = @"
                    INSERT INTO Orders
                        (CustomerID, TotalAmount, FullName, Address, Phone, Status)
                    VALUES
                        (@CID, @Total, @Name, @Address, @Phone, 'Pending');
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(orderQuery, con))
                {
                    cmd.Parameters.AddWithValue("@CID", customerID);
                    cmd.Parameters.AddWithValue("@Total", total);
                    cmd.Parameters.AddWithValue("@Name", fullName);
                    cmd.Parameters.AddWithValue("@Address", address);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    orderID = Convert.ToInt32(cmd.ExecuteScalar());
                }

                // Insert into OrderItems — always store unit price
                string itemQuery = @"
                    INSERT INTO OrderItems
                        (OrderID, ProductID, Quantity, Price)
                    VALUES
                        (@OID, @PID, @Qty, @Price)";

                using (SqlCommand cmd = new SqlCommand(itemQuery, con))
                {
                    cmd.Parameters.AddWithValue("@OID", orderID);
                    cmd.Parameters.AddWithValue("@PID", productID);
                    cmd.Parameters.AddWithValue("@Qty", qty);
                    cmd.Parameters.AddWithValue("@Price", unitPrice);
                    cmd.ExecuteNonQuery();
                }

                // Clear sessions
                Session["BuyNowProductID"] = null;
                Session["BuyNowQuantity"] = null;
                Session["LastOrderID"] = orderID;
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "success",
                            "Swal.fire({ icon: 'success', title: 'Order Placed Successfully!', " +
                            "text: 'Thankyou for choosing us!', confirmButtonColor: '#2e7d32' })" +
                            ".then(() => { window.location.href = 'OrderSuccess.aspx'; });", true);
         
        }
    }
}