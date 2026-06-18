using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AgricultureProductRecommendation
{
    public partial class ManageProduct : Page
    {
        string connStr = WebConfigurationManager
                         .ConnectionStrings["AgroDBCon"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if not logged in
            if (Session["FarmerID"] == null)
                Response.Redirect("~/FarmerLogin.aspx");

            // Show farmer name
            lblFarmerName.Text = Session["FarmerName"].ToString();

            if (!IsPostBack)
                LoadProducts();
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

        // ── Edit ──
        protected void gvProducts_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvProducts.EditIndex = e.NewEditIndex;
            LoadProducts();
        }

        // ── Cancel Edit ──
        protected void gvProducts_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvProducts.EditIndex = -1;
            LoadProducts();
        }

        // ── Update ──
        protected void gvProducts_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // Get ProductID from DataKey
            int productID = Convert.ToInt32(gvProducts.DataKeys[e.RowIndex].Value);

            // Get values from edit controls
            GridViewRow row = gvProducts.Rows[e.RowIndex];

            string name = ((TextBox)row.FindControl("txtEditName")).Text.Trim();
            decimal price = Convert.ToDecimal(((TextBox)row.FindControl("txtEditPrice")).Text.Trim());
            string category = ((DropDownList)row.FindControl("ddlEditCategory")).SelectedValue;
            int rating = Convert.ToInt32(((DropDownList)row.FindControl("ddlEditRating")).SelectedValue);
            bool isTop = ((CheckBox)row.FindControl("chkEditIsTop")).Checked;

            string query = @"UPDATE Products SET
                                ProductName  = @ProductName,
                                Price        = @Price,
                                Category     = @Category,
                                Rating       = @Rating,
                                IsTopProduct = @IsTopProduct
                             WHERE ProductID = @ProductID";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@ProductName", name);
                cmd.Parameters.AddWithValue("@Price", price);
                cmd.Parameters.AddWithValue("@Category", category);
                cmd.Parameters.AddWithValue("@Rating", rating);
                cmd.Parameters.AddWithValue("@IsTopProduct", isTop);
                cmd.Parameters.AddWithValue("@ProductID", productID);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            gvProducts.EditIndex = -1;
            LoadProducts();

            pnlSuccess.Visible = true;
            lblSuccess.Text = "Product updated successfully!";
        }

        // ── Delete ──
        protected void gvProducts_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int productID = Convert.ToInt32(gvProducts.DataKeys[e.RowIndex].Value);

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "DELETE FROM Products WHERE ProductID = @ProductID", con))
            {
                cmd.Parameters.AddWithValue("@ProductID", productID);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadProducts();

            pnlSuccess.Visible = true;
            lblSuccess.Text = "Product deleted successfully!";
        }

        // ── Logout ──
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/FarmerLogin.aspx");
        }
    }
}