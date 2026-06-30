using System;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class OrderSuccess : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string orderID = Request.QueryString["OrderID"];

            if (!string.IsNullOrEmpty(orderID))
                lblOrderID.Text = orderID;
            else
                Response.Redirect("~/HomePage.aspx");
        }
    }
}