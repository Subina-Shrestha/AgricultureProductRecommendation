using System;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class FarmerLogin : Page
    {
        // ← must match Web.config exactly
        string connStr = WebConfigurationManager
                         .ConnectionStrings["AgroDBCon"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // If already logged in redirect to manage page
            if (Session["FarmerID"] != null)
                Response.Redirect("~/ManageProduct.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text.Trim();

                string query = "SELECT FarmerID, FullName FROM Farmers " +
                               "WHERE Email = @Email AND Password = @Password";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        // Save farmer info in session
                        Session["FarmerID"] = dr["FarmerID"].ToString();
                        Session["FarmerName"] = dr["FullName"].ToString();

                        // Remember me
                        if (chkRemember.Checked)
                        {
                            Response.Cookies["FarmerEmail"].Value = email;
                            Response.Cookies["FarmerEmail"].Expires = DateTime.Now.AddDays(7);
                        }

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "success",
                            "Swal.fire({ icon: 'success', title: 'Login Successful!', " +
                            "text: 'Welcome back!', confirmButtonColor: '#2e7d32' })" +
                            ".then(() => { window.location.href = 'ManageProduct.aspx'; });", true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "error",
                            "Swal.fire({ icon: 'error', title: 'Invalid Credentials', " +
                            "text: 'Email or password is incorrect. Please try again.', " +
                            "confirmButtonColor: '#d33' });", true);

                        pnlError.Visible = true;
                        pnlSuccess.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "error",
                    "Swal.fire({ icon: 'error', title: 'Error', " +
                    "text: '" + ex.Message.Replace("'", "") + "', " +
                    "confirmButtonColor: '#d33' });", true);
            }
        }
    }
}