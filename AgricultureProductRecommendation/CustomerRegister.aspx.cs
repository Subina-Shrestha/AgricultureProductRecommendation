using System;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class CustomerRegister : Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerID"] != null)
                Response.Redirect("~/Homepage.aspx");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                string fullName = txtFullName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string phone = txtPhone.Text.Trim();
                string category = ddlCategory.SelectedValue;
                string password = txtPassword.Text.Trim();

                // Check if email already exists
                string checkQuery = "SELECT COUNT(*) FROM Customers WHERE Email = @Email";
                using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
                using (SqlCommand cmd = new SqlCommand(checkQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    if (count > 0)
                    {
                        pnlError.Visible = true;
                        lblError.Text = "This email is already registered. Please login.";
                        pnlSuccess.Visible = false;
                        return;
                    }
                }

                // Insert new customer
                string query = @"INSERT INTO Customers 
                                (FullName, Email, Password, Phone, PreferredCategory, DateJoined)
                                VALUES 
                                (@FullName, @Email, @Password, @Phone, @PreferredCategory, GETDATE())";

                using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@PreferredCategory", category);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                pnlSuccess.Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "success", "Swal.fire({ icon: 'success', title: 'Success!', text: 'Account created successfully! You can now login.!', confirmButtonColor: '#3085d6' })", true);
                pnlError.Visible = false;

                // Clear form
                txtFullName.Text = "";
                txtEmail.Text = "";
                txtPhone.Text = "";
                txtPassword.Text = "";
                txtConfirmPassword.Text = "";
                ddlCategory.SelectedIndex = 0;
            }
            catch (Exception ex)
            {

                ScriptManager.RegisterStartupScript(this, this.GetType(), "duplicate", "Swal.fire({ icon: 'warning', title: 'OOPS', text: 'Something Went Wrong, Please Try Again', confirmButtonColor: '#d33' });", true);
            }
        }
    }
}