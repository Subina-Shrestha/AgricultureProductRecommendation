using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AgricultureProductRecommendation
{
    public partial class FarmerOrders : Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["FarmerID"] == null)
                Response.Redirect("~/FarmerLogin.aspx");

            if (!IsPostBack)
            {
                LoadOrders();
                LoadStats();
            }
        }

        private void LoadOrders(string statusFilter = "")
        {
            string query = @"
                SELECT 
                    o.OrderID, o.CustomerID, o.OrderDate,
                    o.TotalAmount, o.Status,
                    o.FullName, o.DeliveryAddress AS Address, o.Phone,
                    STUFF((
                        SELECT ', ' + p.ProductName + 
                               ' x' + CAST(oi2.Quantity AS NVARCHAR)
                        FROM OrderItems oi2
                        JOIN Products p ON oi2.ProductID = p.ProductID
                        WHERE oi2.OrderID = o.OrderID
                        FOR XML PATH('')
                    ), 1, 2, '') AS ProductNames
                FROM Orders o
                WHERE (@Status = '' OR o.Status = @Status)
                ORDER BY o.OrderDate DESC";

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Status", statusFilter);
                con.Open();
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                gvOrders.DataSource = dt;
                gvOrders.DataBind();

                // Set current status in dropdown for each row
                foreach (GridViewRow row in gvOrders.Rows)
                {
                    DropDownList ddl = (DropDownList)row.FindControl("ddlOrderStatus");
                    if (ddl != null)
                    {
                        string status = dt.Rows[row.RowIndex]["Status"].ToString();
                        ddl.SelectedValue = status;

                        // Color code the dropdown
                        switch (status)
                        {
                            case "Pending":
                                ddl.CssClass += " text-warning"; break;
                            case "Processing":
                                ddl.CssClass += " text-primary"; break;
                            case "Delivered":
                                ddl.CssClass += " text-success"; break;
                            case "Cancelled":
                                ddl.CssClass += " text-danger"; break;
                        }
                    }
                }
            }
        }

        private void LoadStats()
        {
            string query = @"
        SELECT
            COUNT(*)                                          AS TotalOrders,
            SUM(CASE WHEN Status='Pending'   THEN 1 ELSE 0 END) AS Pending,
            SUM(CASE WHEN Status='Delivered' THEN 1 ELSE 0 END) AS Delivered,
            ISNULL(SUM(TotalAmount), 0)                       AS TotalRevenue,
            ISNULL(SUM(CASE WHEN Status='Delivered' 
                            THEN TotalAmount ELSE 0 END), 0)  AS EarnedRevenue
        FROM Orders";

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblTotalOrders.Text = dr["TotalOrders"].ToString();
                    lblPendingOrders.Text = dr["Pending"].ToString();
                    lblDeliveredOrders.Text = dr["Delivered"].ToString();
                    lblTotalRevenue.Text = Convert.ToDecimal(dr["TotalRevenue"]).ToString("0.00");
                    lblDeliveredRevenue.Text = Convert.ToDecimal(dr["EarnedRevenue"]).ToString("0.00");
                }
            }
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateStatus")
            {
                int orderID = Convert.ToInt32(e.CommandArgument);

                // Find the row
                GridViewRow row = null;
                foreach (GridViewRow r in gvOrders.Rows)
                {
                    LinkButton lnk = (LinkButton)r.FindControl("lnkUpdateStatus");
                    if (lnk != null &&
                        lnk.CommandArgument == orderID.ToString())
                    {
                        row = r;
                        break;
                    }
                }

                if (row == null) return;

                DropDownList ddl = (DropDownList)row.FindControl("ddlOrderStatus");
                string newStatus = ddl.SelectedValue;

                using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
                using (SqlCommand cmd = new SqlCommand(
                    "UPDATE Orders SET Status = @Status WHERE OrderID = @OrderID", con))
                {
                    cmd.Parameters.AddWithValue("@Status", newStatus);
                    cmd.Parameters.AddWithValue("@OrderID", orderID);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                pnlSuccess.Visible = true;
                lblSuccess.Text = $"Order #{orderID} status updated to {newStatus}";

                LoadOrders(ddlStatus.SelectedValue);
                LoadStats();
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadOrders(ddlStatus.SelectedValue);
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlStatus.SelectedIndex = 0;
            LoadOrders();
        }
    }
}