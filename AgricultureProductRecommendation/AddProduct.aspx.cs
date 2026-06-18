using System;
using System.Data.SqlClient;
using System.IO;
using System.Web.Configuration;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class AddProduct : Page
    {
        string connStr = WebConfigurationManager
                         .ConnectionStrings["AgroDBCon"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if not logged in
            if (Session["FarmerID"] == null)
                Response.Redirect("~/FarmerLogin.aspx");
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            try
            {
                string productName = txtProductName.Text.Trim();
                decimal price = Convert.ToDecimal(txtPrice.Text.Trim());
                string priceUnit = ddlPriceUnit.SelectedValue;
                string category = ddlCategory.SelectedValue;
                string description = txtDescription.Text.Trim();
                int rating = Convert.ToInt32(ddlRating.SelectedValue);
                bool isTopProduct = chkIsTop.Checked;

                // Handle image upload
                string imageUrl = "Images/default.png"; // default image
                if (fuImage.HasFile)
                {
                    string ext = Path.GetExtension(fuImage.FileName).ToLower();

                    // Validate file type
                    if (ext == ".jpg" || ext == ".jpeg" ||
                        ext == ".png" || ext == ".gif")
                    {
                        string fileName = Path.GetFileName(fuImage.FileName);
                        string savePath = Server.MapPath("~/Images/") + fileName;
                        fuImage.SaveAs(savePath);
                        imageUrl = "Images/" + fileName;
                    }
                    else
                    {
                        pnlError.Visible = true;
                        lblError.Text = "Invalid image format. Use jpg, jpeg, png or gif.";
                        return;
                    }
                }

                // Insert into database
                string query = @"INSERT INTO Products 
                                (ProductName, Price, PriceUnit, Rating, 
                                 ImageUrl, Category, Description, 
                                 IsTopProduct, DateAdded)
                                VALUES 
                                (@ProductName, @Price, @PriceUnit, @Rating,
                                 @ImageUrl, @Category, @Description,
                                 @IsTopProduct, GETDATE())";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ProductName", productName);
                    cmd.Parameters.AddWithValue("@Price", price);
                    cmd.Parameters.AddWithValue("@PriceUnit", priceUnit);
                    cmd.Parameters.AddWithValue("@Rating", rating);
                    cmd.Parameters.AddWithValue("@ImageUrl", imageUrl);
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@IsTopProduct", isTopProduct);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                // Show success
                pnlSuccess.Visible = true;
                lblSuccess.Text = "Product added successfully!";
                pnlError.Visible = false;

                // Clear the form
                ClearForm();
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                lblError.Text = "Error: " + ex.Message;
                pnlSuccess.Visible = false;
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
        }

        private void ClearForm()
        {
            txtProductName.Text = "";
            txtPrice.Text = "";
            txtDescription.Text = "";
            ddlPriceUnit.SelectedIndex = 0;
            ddlCategory.SelectedIndex = 0;
            ddlRating.SelectedIndex = 2; // default Good
            chkIsTop.Checked = false;
        }
    }
}