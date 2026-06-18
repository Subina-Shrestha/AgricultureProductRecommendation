using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AgricultureProductRecommendation
{
    public partial class AdminDashboard : Page
    {
        string connStr = WebConfigurationManager
                         .ConnectionStrings["AgroDBCon"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if not admin
            if (Session["AdminID"] == null)
                Response.Redirect("~/AdminLogin.aspx");

            lblAdminName.Text = Session["AdminName"].ToString();

            if (!IsPostBack)
            {
                LoadFarmers();
                LoadCustomers();
                LoadProducts();
                LoadCounts();
            }
        }

        private void LoadFarmers()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT * FROM Farmers ORDER BY DateJoined DESC", con))
            {
                con.Open();
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                gvFarmers.DataSource = dt;
                gvFarmers.DataBind();
            }
        }

        private void LoadCustomers()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT * FROM Customers ORDER BY DateJoined DESC", con))
            {
                con.Open();
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                gvCustomers.DataSource = dt;
                gvCustomers.DataBind();
            }
        }

        private void LoadProducts()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT * FROM Products ORDER BY DateAdded DESC", con))
            {
                con.Open();
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                gvProducts.DataSource = dt;
                gvProducts.DataBind();
            }
        }

        private void LoadCounts()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Farmer count
                SqlCommand cmd1 = new SqlCommand(
                    "SELECT COUNT(*) FROM Farmers", con);
                lblFarmerCount.Text = cmd1.ExecuteScalar().ToString();

                // Customer count
                SqlCommand cmd2 = new SqlCommand(
                    "SELECT COUNT(*) FROM Customers", con);
                lblCustomerCount.Text = cmd2.ExecuteScalar().ToString();

                // Product count
                SqlCommand cmd3 = new SqlCommand(
                    "SELECT COUNT(*) FROM Products", con);
                lblProductCount.Text = cmd3.ExecuteScalar().ToString();
            }
        }

        // Delete Farmer
        protected void gvFarmers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int farmerID = Convert.ToInt32(gvFarmers.DataKeys[e.RowIndex].Value);

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "DELETE FROM Farmers WHERE FarmerID = @FarmerID", con))
            {
                cmd.Parameters.AddWithValue("@FarmerID", farmerID);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadFarmers();
            LoadCounts();
        }

        // Delete Customer
        protected void gvCustomers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int customerID = Convert.ToInt32(gvCustomers.DataKeys[e.RowIndex].Value);

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "DELETE FROM Customers WHERE CustomerID = @CustomerID", con))
            {
                cmd.Parameters.AddWithValue("@CustomerID", customerID);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadCustomers();
            LoadCounts();
        }

        // Logout
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Remove("AdminID");
            Session.Remove("AdminName");
            Response.Redirect("~/AdminLogin.aspx");
        }
    }
}