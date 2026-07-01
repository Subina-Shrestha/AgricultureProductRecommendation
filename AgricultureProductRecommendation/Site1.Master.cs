using System;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class Site1 : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UpdateNavbar();
            }
            else
            {
                UpdateNavbar();
            }
        }

        private void UpdateNavbar()
        {
            if (Session["AdminID"] != null)
            {
                // Admin logged in
                pnlAdminMenu.Visible = true;
                pnlFarmerMenu.Visible = false;
                pnlCustomerMenu.Visible = false;
                pnlGuestMenu.Visible = false;
                
                lblAdminNavName.Text = "Hi, " + Session["AdminName"].ToString();
            }
            else if (Session["FarmerID"] != null)
            {
                // Farmer logged in
                pnlAdminMenu.Visible = false;
                pnlFarmerMenu.Visible = true;
                pnlCustomerMenu.Visible = false;
                pnlGuestMenu.Visible = false;
                
                lblFarmerName.Text = "Hi, " + Session["FarmerName"].ToString();
            }
            else if (Session["CustomerID"] != null)
            {
                // Customer logged in
                pnlAdminMenu.Visible = false;
                pnlFarmerMenu.Visible = false;
                pnlCustomerMenu.Visible = true;
                pnlGuestMenu.Visible = false;
               
                lblCustomerName.Text = "Hi, " + Session["CustomerName"].ToString();
            }
            else
            {
                // Nobody logged in
                pnlAdminMenu.Visible = false;
                pnlFarmerMenu.Visible = false;
                pnlCustomerMenu.Visible = false;
                pnlGuestMenu.Visible = true;
             
            }
        }

        // Customer Login
        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/CustomerLogin.aspx");
        }

        // Sign Up
        protected void LinkButton2_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/CustomerRegister.aspx");
        }

        // Farmer Login
        protected void LinkButton6_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/FarmerLogin.aspx");
        }

        // Add Product
        protected void LinkButton11_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/AddProduct.aspx");
        }

        // Manage Products
        protected void LinkButton12_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ManageProduct.aspx");
        }

        // Admin Login
        protected void lnkAdminLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/AdminLogin.aspx");
        }

        // Customer Logout
        protected void lnkCustomerLogout_Click(object sender, EventArgs e)
        {
            Session.Remove("CustomerID");
            Session.Remove("CustomerName");
            Session.Remove("PreferredCategory");
            Response.Redirect("~/Homepage.aspx");
        }

        // Farmer Logout
        protected void lnkFarmerLogout_Click(object sender, EventArgs e)
        {
            Session.Remove("FarmerID");
            Session.Remove("FarmerName");
            Response.Redirect("~/Homepage.aspx");
        }

        // Admin Logout
        protected void lnkAdminLogout_Click(object sender, EventArgs e)
        {
            Session.Remove("AdminID");
            Session.Remove("AdminName");
            Response.Redirect("~/Homepage.aspx");
        }
    }

}