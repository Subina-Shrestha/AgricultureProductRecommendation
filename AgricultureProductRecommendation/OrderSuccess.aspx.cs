using System;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class OrderSuccess : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LastOrderID"] != null)
                lblOrderID.Text = Session["LastOrderID"].ToString();
            else
                Response.Redirect("~/HomePage.aspx");
        }
    }
}