using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AgricultureProductRecommendation
{
    public partial class WebForm2 : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTopProducts();
                LoadRecentProducts();

                // ML Recommendations — only for logged in customers
                if (Session["CustomerID"] != null)
                {
                    int customerID = Convert.ToInt32(Session["CustomerID"]);
                    TriggerML(customerID);
                    LoadMLRecommendations(customerID);
                }
            }
        }

        private void TriggerML(int customerID)
        {
            try
            {
                string url = "http://localhost:5000/recommend/" + customerID;
                using (System.Net.WebClient client = new System.Net.WebClient())
                {
                    client.DownloadString(url);
                }
            }
            catch { } // Flask not running — fail silently
        }

        private void LoadMLRecommendations(int customerID)
        {
            try
            {
                string query = @"
            SELECT p.ProductID, p.ProductName, p.Price,
                   p.PriceUnit, p.ImageUrl, p.Category,
                   ISNULL(CAST(AVG(CAST(r.Rating AS FLOAT))
                       AS DECIMAL(3,1)), 0) AS AvgRating,
                   COUNT(r.RatingID) AS TotalRatings
            FROM Recommendations rec
            JOIN Products p ON rec.ProductID = p.ProductID
            LEFT JOIN Ratings r ON p.ProductID = r.ProductID
            WHERE rec.CustomerID = @CustomerID
            GROUP BY p.ProductID, p.ProductName, p.Price,
                     p.PriceUnit, p.ImageUrl, p.Category";

                using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CustomerID", customerID);
                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    if (dt.Rows.Count > 0)
                    {
                        pnlMLRecommendations.Visible = true;
                        rptMLRecommendations.DataSource = dt;
                        rptMLRecommendations.DataBind();
                    }
                }
            }
            catch { }
        }

        private void LoadTopProducts()
        {
            string query = @"
                SELECT TOP 4
                    p.ProductID, p.ProductName, p.Price, p.PriceUnit,
                    p.ImageUrl, p.Category, p.Description,
                    p.IsTopProduct, p.DateAdded,
                    ISNULL(CAST(AVG(CAST(r.Rating AS FLOAT)) 
                        AS DECIMAL(3,1)), 0) AS AvgRating,
                    COUNT(r.RatingID) AS TotalRatings
                FROM Products p
                LEFT JOIN Ratings r ON p.ProductID = r.ProductID
                WHERE p.IsTopProduct = 1
                GROUP BY
                    p.ProductID, p.ProductName, p.Price, p.PriceUnit,
                    p.ImageUrl, p.Category, p.Description,
                    p.IsTopProduct, p.DateAdded
                ORDER BY AvgRating DESC";

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                rptTopProducts.DataSource = dt;
                rptTopProducts.DataBind();
            }
        }

        private void LoadRecentProducts()
        {
            string query = @"
                SELECT TOP 4
                    p.ProductID, p.ProductName, p.Price, p.PriceUnit,
                    p.ImageUrl, p.Category, p.Description,
                    p.IsTopProduct, p.DateAdded,
                    ISNULL(CAST(AVG(CAST(r.Rating AS FLOAT)) 
                        AS DECIMAL(3,1)), 0) AS AvgRating,
                    COUNT(r.RatingID) AS TotalRatings
                FROM Products p
                LEFT JOIN Ratings r ON p.ProductID = r.ProductID
                GROUP BY
                    p.ProductID, p.ProductName, p.Price, p.PriceUnit,
                    p.ImageUrl, p.Category, p.Description,
                    p.IsTopProduct, p.DateAdded
                ORDER BY p.DateAdded DESC";

            using (SqlConnection con = new SqlConnection(DbConfig.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                rptRecentProducts.DataSource = dt;
                rptRecentProducts.DataBind();
            }
        }
    }
}