using System;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class AdminLogin : Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminID"] != null)
                Response.Redirect("~/AdminDashboard.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text.Trim();

                string query = "SELECT AdminID, FullName FROM Admins " +
                               "WHERE Email = @Email AND Password = @Password";

                using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        Session["AdminID"] = dr["AdminID"].ToString();
                        Session["AdminName"] = dr["FullName"].ToString();

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "success",
                            "Swal.fire({ icon: 'success', title: 'Login Successful!', " +
                            "text: 'Welcome Admin!', confirmButtonColor: '#1a237e' })" +
                            ".then(() => { window.location.href = 'AdminDashboard.aspx'; });", true);
                    }
                    else
                    {
                        pnlError.Visible = true;
                        lblError.Text = "Invalid email or password. Please try again.";
                    }
                }
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                lblError.Text = "Error: " + ex.Message;
            }
        }
    }
}