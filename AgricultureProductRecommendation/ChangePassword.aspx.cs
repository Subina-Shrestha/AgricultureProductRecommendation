using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class ChangePassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerID"] == null)
                Response.Redirect("~/CustomerLogin.aspx");
        }

        protected void btnChange_Click(object sender, EventArgs e)
        {
            string customerId = Session["CustomerID"].ToString();
            string currentPassword = txtCurrentPassword.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            {
                con.Open();

                // Verify current password first
                string checkQuery = "SELECT CustomerID FROM Customers WHERE CustomerID = @CustomerID AND Password = @CurrentPassword";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@CustomerID", customerId);
                    checkCmd.Parameters.AddWithValue("@CurrentPassword", currentPassword);
                    object result = checkCmd.ExecuteScalar();

                    if (result == null)
                    {
                        pnlMessage.Visible = true;
                        lblMessage.CssClass = "text-danger";
                        lblMessage.Text = "Current password is incorrect.";
                        return;
                    }
                }

                string updateQuery = "UPDATE Customers SET Password = @NewPassword WHERE CustomerID = @CustomerID";
                using (SqlCommand updateCmd = new SqlCommand(updateQuery, con))
                {
                    updateCmd.Parameters.AddWithValue("@NewPassword", newPassword);
                    updateCmd.Parameters.AddWithValue("@CustomerID", customerId);
                    updateCmd.ExecuteNonQuery();
                }
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "changeSuccess",
                "Swal.fire({ icon: 'success', title: 'Password Updated!', text: 'Your password has been changed successfully.', confirmButtonColor: '#3085d6' }).then(() => { window.location.href = 'Default.aspx'; });", true);
        }
    }
}