<%@ Page Title="All Products" Language="C#"
    MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="viewproducts.aspx.cs"
    Inherits="AgricultureProductRecommendation.viewproducts" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Page Banner -->
    <div class="bg-success bg-opacity-10 border-bottom border-success py-3 mb-4">
        <div class="container">
            <h2 class="text-success fw-bold mb-0">All Products</h2>
            <small class="text-muted">Browse our full range of fresh agriculture products</small>
        </div>
    </div>

    <div class="container">

        <!-- Filter Bar -->
        <div class="bg-light border rounded p-3 mb-4 d-flex flex-wrap align-items-center gap-2">

            <asp:TextBox ID="txtSearch" runat="server"
                placeholder="Search products..."
                CssClass="form-control"
                Style="width: 220px;" />

            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" Style="width: 160px;">
                <asp:ListItem Value="">All Categories</asp:ListItem>
                <asp:ListItem Value="Fruits">Fruits</asp:ListItem>
                <asp:ListItem Value="Vegetables">Vegetables</asp:ListItem>
                <asp:ListItem Value="Grains">Grains</asp:ListItem>
                <asp:ListItem Value="Dairy">Dairy</asp:ListItem>
                <asp:ListItem Value="Organic">Organic</asp:ListItem>
            </asp:DropDownList>

            <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-select" Style="width: 180px;">
                <asp:ListItem Value="newest">Newest First</asp:ListItem>
                <asp:ListItem Value="rating">Top Rated</asp:ListItem>
                <asp:ListItem Value="price_asc">Price: Low to High</asp:ListItem>
                <asp:ListItem Value="price_desc">Price: High to Low</asp:ListItem>
            </asp:DropDownList>

            <asp:Button ID="btnFilter" runat="server" Text="Filter"
                CssClass="btn btn-success"
                OnClick="btnFilter_Click" />

            <asp:Button ID="btnReset" runat="server" Text="Reset"
                CssClass="btn btn-secondary"
                OnClick="btnReset_Click" />

        </div>

        <!-- Product Count -->
        <p class="text-muted mb-3">
            Showing <strong>
                <asp:Label ID="lblCount" runat="server" Text="0" />
            </strong>products
       
        </p>

        <!-- Products Grid -->
        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4 g-3">
            <asp:Repeater ID="rptProducts" runat="server">
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
                                <p class="text-muted mb-1" style="font-size: 0.8rem;">
                                    <%# Eval("Description") %>
                                </p>
                                <p class="mb-2 fw-semibold" style="color: #f5a623; font-size: 0.9rem;">
                                    <%# Convert.ToDouble(Eval("AvgRating")) > 0
        ? "Rating: " + Eval("AvgRating") + "/5 (" + Eval("TotalRatings") + " ratings)"
        : "No ratings yet" %>
                                </p>
                                <a href='Productdetail.aspx?id=<%# Eval("ProductID") %>'
                                    class="btn btn-sm btn-outline-success w-100 mt-2">
                                    <i class="bi bi-eye me-1"></i>View Details
                                </a>
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- No Products Message -->
        <asp:Panel ID="pnlNoProducts" runat="server" Visible="false">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-basket fs-1 d-block mb-3"></i>
                No products found. Try a different search or category.
           
            </div>
        </asp:Panel>

        <div class="mb-5"></div>

    </div>
</asp:Content>
