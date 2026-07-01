using System;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class ForgotPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            {
                con.Open();

                string checkQuery = "SELECT CustomerID FROM Customers WHERE Email = @Email";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    object result = checkCmd.ExecuteScalar();

                    if (result == null)
                    {
                        // Email not found — show error instead of proceeding
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "notFound",
                            "Swal.fire({ " +
                            "icon: 'error', " +
                            "title: 'Email Not Found', " +
                            "text: 'No account is registered with this email address.', " +
                            "confirmButtonColor: '#d33' " +
                            "});", true);
                        return;
                    }

                    string newPassword = GenerateRandomPassword(5);

                    string updateQuery = "UPDATE Customers SET Password = @Password WHERE Email = @Email";
                    using (SqlCommand updateCmd = new SqlCommand(updateQuery, con))
                    {
                        updateCmd.Parameters.AddWithValue("@Password", newPassword);
                        updateCmd.Parameters.AddWithValue("@Email", email);
                        updateCmd.ExecuteNonQuery();
                    }

                    string body = "<p>Hello,</p>"
                        + "<p>Your AgroRecSys password has been reset. Here is your new password:</p>"
                        + "<p style='font-size:18px;font-weight:bold;letter-spacing:1px;'>" + newPassword + "</p>"
                        + "<p>Please log in and change this password from your account settings if you'd like a different one.</p>"
                        + "<p>If you didn't request this, please contact support immediately.</p>";

                    bool emailSent = true;
                    try
                    {
                        EmailHelper.SendEmail(email, "Your New AgroRecSys Password", body);
                    }
                    catch (Exception)
                    {
                        emailSent = false;
                    }

                    if (!emailSent)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "sendFailed",
                            "Swal.fire({ " +
                            "icon: 'error', " +
                            "title: 'Something Went Wrong', " +
                            "text: 'We could not send the email right now. Please try again shortly.', " +
                            "confirmButtonColor: '#d33' " +
                            "});", true);
                        return;
                    }
                }
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "success",
                "Swal.fire({ " +
                "icon: 'success', " +
                "title: 'Congratulations!', " +
                "text: 'A new password is sent to your mail, Please check your email!', " +
                "confirmButtonColor: '#2e7d32', " +
                "timer: 5000, " +
                "timerProgressBar: true " +
                "}).then(() => { window.location.href = 'CustomerLogin.aspx'; });", true);
        }

        private string GenerateRandomPassword(int length)
        {
            const string upper = "ABCDEFGHJKLMNPQRSTUVWXYZ";
            const string lower = "abcdefghijkmnopqrstuvwxyz";
            const string digits = "23456789";
            const string all = upper + lower + digits;

            var rng = new Random();
            var sb = new StringBuilder();

            // Guarantee at least one of each type
            sb.Append(upper[rng.Next(upper.Length)]);
            sb.Append(lower[rng.Next(lower.Length)]);
            sb.Append(digits[rng.Next(digits.Length)]);

            for (int i = 3; i < length; i++)
                sb.Append(all[rng.Next(all.Length)]);

            // Shuffle so the guaranteed characters aren't always in the same position
            var chars = sb.ToString().ToCharArray();
            for (int i = chars.Length - 1; i > 0; i--)
            {
                int j = rng.Next(i + 1);
                (chars[i], chars[j]) = (chars[j], chars[i]);
            }

            return new string(chars);
        }
    }
}