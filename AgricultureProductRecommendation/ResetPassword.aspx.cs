using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class ResetPassword : Page
    {
        private string Token => Request.QueryString["token"];

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (string.IsNullOrEmpty(Token) || !IsTokenValid(Token))
                {
                    pnlForm.Visible = false;
                    pnlInvalid.Visible = true;
                }
            }
        }

        private bool IsTokenValid(string token)
        {
            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT CustomerID FROM Customers WHERE ResetToken = @Token AND ResetTokenExpiry > GETDATE()", con))
            {
                cmd.Parameters.AddWithValue("@Token", token);
                con.Open();
                object result = cmd.ExecuteScalar();
                return result != null;
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Token) || !IsTokenValid(Token))
            {
                pnlForm.Visible = false;
                pnlInvalid.Visible = true;
                return;
            }

            string newPassword = txtNewPassword.Text.Trim();

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "UPDATE Customers SET Password = @Password, ResetToken = NULL, ResetTokenExpiry = NULL WHERE ResetToken = @Token",
                con))
            {
                cmd.Parameters.AddWithValue("@Password", newPassword);
                cmd.Parameters.AddWithValue("@Token", Token);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "resetSuccess",
                "Swal.fire({ icon: 'success', title: 'Password Reset!', text: 'You can now log in with your new password.', confirmButtonColor: '#3085d6' }).then(() => { window.location.href = 'CustomerLogin.aspx'; });", true);
        }
    }
}