<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="AgricultureProductRecommendation.WebForm2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <section>
        <img src="Images/Vegetables.png" class="img-fluid" alt="Agriculture Product Recommendation" />
    </section>

    <div class="container">

        <!-- Top Products -->
        <div class="section-header">
            <h2>Top Products</h2>
            <a href="viewproducts.aspx" class="btn-view-all">View all Products</a>
        </div>

        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4 g-3">
            <asp:Repeater ID="rptTopProducts" runat="server">
                <ItemTemplate>
                    <div class="col">
                        <div class="card h-100 shadow-sm border rounded">
                            <img src='<%# Eval("ImageUrl") %>'
                                alt='<%# Eval("ProductName") %>'
                                class="card-img-top"
                                style="height: 190px; object-fit: cover;" />
                            <div class="card-body">
                                <span class="badge bg-success bg-opacity-25 text-success mb-2">
                                    <%# Eval("Category") %>
                                </span>
                                <h6 class="card-title text-success fw-bold">
                                    <%# Eval("ProductName") %>
                                </h6>
                                <p class="text-muted mb-1" style="font-size: 0.9rem;">
                                    Rs. <%# Eval("Price") %>/<%# Eval("PriceUnit") %>
                                </p>
                                <p class="mb-2 fw-semibold" style="color: #f5a623; font-size: 0.9rem;">
                                    <%# Convert.ToDouble(Eval("AvgRating")) > 0
                                        ? "Rating: " + Eval("AvgRating") + "/5 (" + Eval("TotalRatings") + " ratings)"
                                        : "No ratings yet" %>
                                </p>
                                <a href='Productdetail.aspx?id=<%# Eval("ProductID") %>'
                                    class="btn btn-sm btn-outline-success w-100">
                                    <i class="bi bi-eye me-1"></i>View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Recently Added -->
        <div class="section-header" style="padding-top: 40px;">
            <h2>Recently Added</h2>
            <a href="viewproducts.aspx?filter=recent" class="btn-view-all">View all</a>
        </div>

        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4 g-3">
            <asp:Repeater ID="rptRecentProducts" runat="server">
                <ItemTemplate>
                    <div class="col">
                        <div class="card h-100 shadow-sm border rounded">
                            <img src='<%# Eval("ImageUrl") %>'
                                alt='<%# Eval("ProductName") %>'
                                class="card-img-top"
                                style="height: 190px; object-fit: cover;" />
                            <div class="card-body">
                                <span class="badge bg-success bg-opacity-25 text-success mb-2">
                                    <%# Eval("Category") %>
                                </span>
                                <h6 class="card-title text-success fw-bold">
                                    <%# Eval("ProductName") %>
                                </h6>
                                <p class="text-muted mb-1" style="font-size: 0.9rem;">
                                    Rs. <%# Eval("Price") %>/<%# Eval("PriceUnit") %>
                                </p>
                                <p class="mb-2 fw-semibold" style="color: #f5a623; font-size: 0.9rem;">
                                    <%# Convert.ToDouble(Eval("AvgRating")) > 0
                                        ? "Rating: " + Eval("AvgRating") + "/5 (" + Eval("TotalRatings") + " ratings)"
                                        : "No ratings yet" %>
                                </p>
                                <a href='Productdetail.aspx?id=<%# Eval("ProductID") %>'
                                    class="btn btn-sm btn-outline-success w-100">
                                    <i class="bi bi-eye me-1"></i>View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div style="height: 40px;"></div>
    </div>

</asp:Content>