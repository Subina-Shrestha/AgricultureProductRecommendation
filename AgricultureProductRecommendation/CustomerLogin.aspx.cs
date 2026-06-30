using System;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class CustomerLogin : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerID"] != null)
                Response.Redirect("~/Default.aspx");

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            string query = "SELECT CustomerID, FullName, PreferredCategory, Email FROM Customers WHERE Email = @Email AND Password = @Password";

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    Session["CustomerID"] = dr["CustomerID"].ToString();
                    Session["CustomerName"] = dr["FullName"].ToString();
                    Session["PreferredCategory"] = dr["PreferredCategory"].ToString();
                    Session["CustomerEmail"] = dr["Email"].ToString();

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "success", "Swal.fire({ icon: 'success', title: 'Success!', text: 'Logged in Successfully!', confirmButtonColor: '#3085d6' }).then(() => { window.location.href = 'homepage.aspx'; });", true);
                    
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "duplicate", "Swal.fire({ icon: 'warning', title: 'Invalid', text: 'Invalid Email or Password, Please Try Again', confirmButtonColor: '#d33' });", true);
                }
            }
        }
    }
    }
