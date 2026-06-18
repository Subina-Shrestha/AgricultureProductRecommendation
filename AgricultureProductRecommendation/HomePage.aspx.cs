using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AgricultureProductRecommendation
{
    public partial class WebForm2 : Page
    {
        string connStr = WebConfigurationManager
                         .ConnectionStrings["AgroDBCon"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTopProducts();
                LoadRecentProducts();
            }
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

            using (SqlConnection con = new SqlConnection(connStr))
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

            using (SqlConnection con = new SqlConnection(connStr))
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