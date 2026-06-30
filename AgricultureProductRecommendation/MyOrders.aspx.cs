using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class MyOrders : Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerID"] == null)
                Response.Redirect("~/CustomerLogin.aspx");

            if (!IsPostBack)
                LoadOrders();
        }

        private void LoadOrders()
        {
            int customerID = Convert.ToInt32(Session["CustomerID"]);

            string query = @"
    SELECT OrderID, CustomerID, OrderDate,
           TotalAmount, Status,
           FullName, DeliveryAddress, Phone
    FROM Orders
    WHERE CustomerID = @CustomerID
    ORDER BY OrderDate DESC";

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@CustomerID", customerID);
                con.Open();
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                if (dt.Rows.Count == 0)
                {
                    pnlNoOrders.Visible = true;
                    pnlOrders.Visible = false;
                }
                else
                {
                    pnlNoOrders.Visible = false;
                    pnlOrders.Visible = true;
                    rptOrders.DataSource = dt;
                    rptOrders.DataBind();
                }
            }
        }

        // Get items for each order
        public DataTable GetOrderItems(int orderID)
        {
            string query = @"
                SELECT p.ProductName, p.ImageUrl,
                       oi.Quantity, oi.Price
                FROM OrderItems oi
                JOIN Products p ON oi.ProductID = p.ProductID
                WHERE oi.OrderID = @OrderID";

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@OrderID", orderID);
                con.Open();
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
        }

        // Return Bootstrap badge class based on status
        public string GetStatusBadge(string status)
        {
            switch (status)
            {
                case "Pending": return "badge bg-warning text-dark fs-6";
                case "Processing": return "badge bg-primary fs-6";
                case "Delivered": return "badge bg-success fs-6";
                case "Cancelled": return "badge bg-danger fs-6";
                default: return "badge bg-secondary fs-6";
            }
        }
    }
}