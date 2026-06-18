using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;

namespace AgricultureProductRecommendation
{
    public partial class ProductDetail : Page
    {
        string connStr = WebConfigurationManager
                         .ConnectionStrings["AgroDBCon"].ConnectionString;

        int currentProductID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Back to QueryString only since Global.asax is removed
            string idParam = Request.QueryString["id"];

            if (string.IsNullOrEmpty(idParam) ||
                !int.TryParse(idParam, out currentProductID))
            {
                pnlError.Visible = true;
                lblError.Text = "Invalid product selected.";
                return;
            }

            if (!IsPostBack)
            {
                LoadProduct(currentProductID);
                LoadRecommendations(currentProductID);
                LoadRating(currentProductID);

                if (Session["CustomerID"] != null)
                {
                    LogView(currentProductID);
                    btnBuyNow.Visible = true;
                    pnlOrderLoginPrompt.Visible = false;
                }
                else
                {
                    btnBuyNow.Visible = false;
                    pnlOrderLoginPrompt.Visible = true;
                }
            }
            else
            {
                // Keep panel visible on postback so buttons work
                pnlProduct.Visible = true;
                if (Session["CustomerID"] != null)
                    btnBuyNow.Visible = true;
            }
        }

        private void LoadProduct(int productID)
        {
            string query = "SELECT * FROM Products WHERE ProductID = @ProductID";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@ProductID", productID);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    pnlProduct.Visible = true;
                    imgProduct.ImageUrl = dr["ImageUrl"].ToString();
                    lblProductName.Text = dr["ProductName"].ToString();
                    lblCategory.Text = dr["Category"].ToString();
                    lblPrice.Text = dr["Price"].ToString();
                    lblPriceUnit.Text = dr["PriceUnit"].ToString();
                    lblDescription.Text = dr["Description"].ToString();
                    lblDateAdded.Text = Convert.ToDateTime(
                                             dr["DateAdded"]).ToString("dd MMM yyyy");
                    lblPriceUnitQty.Text = dr["PriceUnit"].ToString();
                    Page.Title = dr["ProductName"].ToString() + " - AgroRecSys";
                }
                else
                {
                    pnlError.Visible = true;
                    lblError.Text = "Product not found.";
                }
            }
        }

        protected void btnBuyNow_Click(object sender, EventArgs e)
        {
            if (Session["CustomerID"] == null)
            {
                Response.Redirect("~/CustomerLogin.aspx");
                return;
            }

            int productID = Convert.ToInt32(Request.QueryString["id"]);
            int quantity = Convert.ToInt32(txtQuantity.Text);

            Session["BuyNowProductID"] = productID;
            Session["BuyNowQuantity"] = quantity;
            Response.Redirect("~/CheckOut.aspx");
        }

        private void LoadRating(int productID)
        {
            string query = @"SELECT 
                                ISNULL(CAST(AVG(CAST(Rating AS FLOAT)) 
                                AS DECIMAL(3,1)), 0) AS AvgRating,
                                COUNT(RatingID) AS TotalRatings
                             FROM Ratings
                             WHERE ProductID = @ProductID";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@ProductID", productID);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblAvgRating.Text = dr["AvgRating"].ToString();
                    lblTotalRatings.Text = dr["TotalRatings"].ToString();
                }
            }

            if (Session["CustomerID"] != null)
            {
                pnlRateProduct.Visible = true;

                int customerID = Convert.ToInt32(Session["CustomerID"]);
                string checkQuery = @"SELECT COUNT(*) FROM Ratings 
                                     WHERE ProductID = @ProductID 
                                     AND CustomerID = @CustomerID";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(checkQuery, con))
                {
                    cmd.Parameters.AddWithValue("@ProductID", productID);
                    cmd.Parameters.AddWithValue("@CustomerID", customerID);
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();

                    if (count > 0)
                    {
                        pnlAlreadyRated.Visible = true;
                        pnlRatingForm.Visible = false;
                    }
                }
            }
            else
            {
                pnlRatingLoginPrompt.Visible = true;
            }
        }

        protected void btnSubmitRating_Click(object sender, EventArgs e)
        {
            if (Session["CustomerID"] == null)
            {
                Response.Redirect("~/CustomerLogin.aspx");
                return;
            }

            int customerID = Convert.ToInt32(Session["CustomerID"]);
            int productID = Convert.ToInt32(Request.QueryString["id"]);
            int rating = Convert.ToInt32(ddlRating.SelectedValue);

            string query = @"INSERT INTO Ratings 
                            (ProductID, CustomerID, Rating, RatedAt)
                            VALUES 
                            (@ProductID, @CustomerID, @Rating, GETDATE())";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@ProductID", productID);
                cmd.Parameters.AddWithValue("@CustomerID", customerID);
                cmd.Parameters.AddWithValue("@Rating", rating);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadRating(productID);

            ScriptManager.RegisterStartupScript(this, this.GetType(), "rated",
                "Swal.fire({ icon: 'success', title: 'Thank you!', " +
                "text: 'Your rating has been submitted.', " +
                "confirmButtonColor: '#2e7d32' });", true);
        }

        private void LoadRecommendations(int currentProductID)
        {
            string category = "";
            string recommendTitle = "";

            if (Session["CustomerID"] != null)
            {
                category = Session["PreferredCategory"] != null
                                 ? Session["PreferredCategory"].ToString()
                                 : "";
                recommendTitle = "Recommended For You — " + category;
            }
            else
            {
                string catQuery = "SELECT Category FROM Products WHERE ProductID = @ID";
                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(catQuery, con))
                {
                    cmd.Parameters.AddWithValue("@ID", currentProductID);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    category = result != null ? result.ToString() : "";
                }
                recommendTitle = "More in " + category;
                pnlLoginPrompt.Visible = true;
            }

            if (string.IsNullOrEmpty(category)) return;

            string query = @"SELECT TOP 4 * FROM Products
                             WHERE Category  = @Category
                             AND   ProductID != @CurrentID
                             ORDER BY Rating DESC";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Category", category);
                cmd.Parameters.AddWithValue("@CurrentID", currentProductID);

                con.Open();
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                if (dt.Rows.Count > 0)
                {
                    pnlRecommendations.Visible = true;
                    lblRecommendTitle.Text = recommendTitle;
                    rptRecommended.DataSource = dt;
                    rptRecommended.DataBind();
                }
            }
        }

        private void LogView(int productID)
        {
            try
            {
                int customerID = Convert.ToInt32(Session["CustomerID"]);
                string query = @"INSERT INTO CustomerViews 
                                  (CustomerID, ProductID, ViewedAt)
                                  VALUES (@CustomerID, @ProductID, GETDATE())";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CustomerID", customerID);
                    cmd.Parameters.AddWithValue("@ProductID", productID);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch { }
        }
    }
}