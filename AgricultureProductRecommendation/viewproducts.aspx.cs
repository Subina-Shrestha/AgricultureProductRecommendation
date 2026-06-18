using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;

namespace AgricultureProductRecommendation
{

    public partial class viewproducts : Page
    {
        string connStr = WebConfigurationManager
                         .ConnectionStrings["AgroDBCon"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts();
            }
        }

        private void LoadProducts()
        {
            string search = txtSearch.Text.Trim();
            string category = ddlCategory.SelectedValue;
            string sort = ddlSort.SelectedValue;

            string orderBy = "p.DateAdded DESC";
            if (sort == "rating") orderBy = "AvgRating DESC";
            if (sort == "price_asc") orderBy = "p.Price ASC";
            if (sort == "price_desc") orderBy = "p.Price DESC";

            string query = @"
    SELECT 
        p.ProductID, p.ProductName, p.Price, p.PriceUnit,
        p.ImageUrl, p.Category, p.Description,
        p.Rating, p.IsTopProduct, p.DateAdded,
        ISNULL(CAST(AVG(CAST(r.Rating AS FLOAT)) AS DECIMAL(3,1)), 0) AS AvgRating,
        COUNT(r.RatingID) AS TotalRatings
    FROM Products p
    LEFT JOIN Ratings r ON p.ProductID = r.ProductID
    WHERE 
        (@Search = '' OR p.ProductName LIKE '%' + @Search + '%'
         OR p.Description LIKE '%' + @Search + '%')
    AND (@Category = '' OR p.Category = @Category)
    GROUP BY 
        p.ProductID, p.ProductName, p.Price, p.PriceUnit,
        p.ImageUrl, p.Category, p.Description,
        p.Rating, p.IsTopProduct, p.DateAdded
    ORDER BY " + orderBy;

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Search", search);
                cmd.Parameters.AddWithValue("@Category", category);

                con.Open();
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                lblCount.Text = dt.Rows.Count.ToString();

                if (dt.Rows.Count == 0)
                {
                    pnlNoProducts.Visible = true;
                    rptProducts.Visible = false;
                }
                else
                {
                    pnlNoProducts.Visible = false;
                    rptProducts.Visible = true;
                    rptProducts.DataSource = dt;
                    rptProducts.DataBind();
                }
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlCategory.SelectedIndex = 0;
            ddlSort.SelectedIndex = 0;
            LoadProducts();
        }
    }
}