using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AgricultureProductRecommendation
{
    public partial class AdminDashboard : Page
    {
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
            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
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
            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
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
            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
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
            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
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
        protected void btnAddFarmer_Click(object sender, EventArgs e)
        {
            string name = txtFarmerName.Text.Trim();
            string email = txtFarmerEmail.Text.Trim();
            string phone = txtFarmerPhone.Text.Trim();
            string password = txtFarmerPassword.Text.Trim();

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblAddFarmerMsg.Text = "Name, Email, and Password are required.";
                lblAddFarmerMsg.CssClass = "d-block mt-2 text-danger";
                return;
            }

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            {
                con.Open();

                // Check for duplicate email
                using (SqlCommand checkCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Farmers WHERE Email = @Email", con))
                {
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    int exists = (int)checkCmd.ExecuteScalar();
                    if (exists > 0)
                    {
                        lblAddFarmerMsg.Text = "A farmer with this email already exists.";
                        lblAddFarmerMsg.CssClass = "d-block mt-2 text-danger";
                        return;
                    }
                }

                using (SqlCommand cmd = new SqlCommand(
                    @"INSERT INTO Farmers (FullName, Email, Phone, Password, DateJoined) 
              VALUES (@FullName, @Email, @Phone, @Password, @DateJoined)", con))
                {
                    cmd.Parameters.AddWithValue("@FullName", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@Password", password); // see note below
                    cmd.Parameters.AddWithValue("@DateJoined", DateTime.Now);
                    cmd.ExecuteNonQuery();
                }
            }

            lblAddFarmerMsg.Text = "Farmer added successfully.";
            lblAddFarmerMsg.CssClass = "d-block mt-2 text-success";

            txtFarmerName.Text = "";
            txtFarmerEmail.Text = "";
            txtFarmerPhone.Text = "";
            txtFarmerPassword.Text = "";

            LoadFarmers();
            LoadCounts();
        }
        // Delete Farmer
        protected void gvFarmers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int farmerID = Convert.ToInt32(gvFarmers.DataKeys[e.RowIndex].Value);

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
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

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
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