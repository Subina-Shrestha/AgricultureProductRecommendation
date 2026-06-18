<%@ Page Title="Product Detail" Language="C#"
    MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="Productdetail.aspx.cs"
    Inherits="AgricultureProductRecommendation.ProductDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function changeQty(change) {
            var txtQty = document.getElementById('<%= txtQuantity.ClientID %>');
            var current = parseInt(txtQty.value);
            var newVal = current + change;
            if (newVal < 1) newVal = 1;
            if (newVal > 100) newVal = 100;
            txtQty.value = newVal;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4">

        <!-- Error Panel -->
        <asp:Panel ID="pnlError" runat="server" Visible="false">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle me-2"></i>
                <asp:Label ID="lblError" runat="server" Text="" />
            </div>
        </asp:Panel>

        <!-- Product Detail Card -->
        <asp:Panel ID="pnlProduct" runat="server" Visible="false">
            <div class="row g-4 mb-5">

                <!-- Product Image -->
                <div class="col-md-5">
                    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                        <asp:Image ID="imgProduct" runat="server"
                            CssClass="img-fluid w-100"
                            Style="height: 380px; object-fit: cover;" />
                    </div>
                </div>

                <!-- Product Info -->
                <div class="col-md-7">
                    <div class="card border-0 shadow-sm rounded-3 h-100 p-4">

                        <!-- Category Badge -->
                        <span class="badge bg-success bg-opacity-25 text-success mb-2"
                            style="width: fit-content; font-size: 0.85rem;">
                            <asp:Label ID="lblCategory" runat="server" Text="" />
                        </span>

                        <!-- Product Name -->
                        <h2 class="fw-bold text-success mb-2">
                            <asp:Label ID="lblProductName" runat="server" Text="" />
                        </h2>

                        <!-- Price -->
                        <h4 class="text-dark mb-3">Rs.
                            <asp:Label ID="lblPrice" runat="server" Text="" />
                            <small class="text-muted fs-6">/
                                <asp:Label ID="lblPriceUnit" runat="server" Text="" />
                            </small>
                        </h4>

                        <!-- Rating -->
                        <div class="mb-3">
                            <span class="fw-semibold">Rating: </span>
                            <!-- Show average rating -->
                            <div class="mb-3">
                                <span class="fw-semibold">Average Rating: </span>
                                <span style="color: #f5a623; font-size: 1.1rem; font-weight: 600;">
                                    <asp:Label ID="lblAvgRating" runat="server" Text="0" />/5
                                </span>
                                <small class="text-muted ms-1">(<asp:Label ID="lblTotalRatings" runat="server" Text="0" />
                                    ratings)
                                </small>
                            </div>

                            <!-- Rate this product — only show if customer is logged in -->
                            <asp:Panel ID="pnlRateProduct" runat="server" Visible="false">
                                <div class="card bg-light border-0 p-3 mb-3">
                                    <h6 class="fw-bold mb-2">Rate this Product</h6>

                                    <asp:Panel ID="pnlAlreadyRated" runat="server" Visible="false">
                                        <div class="alert alert-success py-2 mb-2">
                                            <i class="bi bi-check-circle me-1"></i>
                                            You have already rated this product.
                                        </div>
                                    </asp:Panel>

                                    <asp:Panel ID="pnlRatingForm" runat="server" Visible="true">
                                        <div class="d-flex align-items-center gap-2">
                                            <asp:DropDownList ID="ddlRating" runat="server"
                                                CssClass="form-select" Style="width: 150px;">
                                                <asp:ListItem Value="1">1 - Poor</asp:ListItem>
                                                <asp:ListItem Value="2">2 - Fair</asp:ListItem>
                                                <asp:ListItem Value="3">3 - Good</asp:ListItem>
                                                <asp:ListItem Value="4">4 - Very Good</asp:ListItem>
                                                <asp:ListItem Value="5">5 - Excellent</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:Button ID="btnSubmitRating" runat="server"
                                                Text="Submit Rating"
                                                CssClass="btn btn-success"
                                                OnClick="btnSubmitRating_Click"
                                                CausesValidation="false" />
                                        </div>
                                    </asp:Panel>

                                </div>
                            </asp:Panel>

                            <!-- Not logged in prompt -->
                            <asp:Panel ID="pnlRatingLoginPrompt" runat="server" Visible="false">
                                <div class="alert alert-info py-2 mb-3">
                                    <i class="bi bi-info-circle me-1"></i>
                                    <a href="CustomerLogin.aspx" class="alert-link">Login</a>
                                    to rate this product.
                                </div>
                            </asp:Panel>
                        </div>

                        <!-- Description -->
                        <div class="mb-4">
                            <h6 class="fw-bold text-muted">Description</h6>
                            <p class="text-muted">
                                <asp:Label ID="lblDescription" runat="server" Text="" />
                            </p>
                        </div>

                        <!-- Date Added -->
                        <div class="mb-4">
                            <small class="text-muted">
                                <i class="bi bi-calendar me-1"></i>Added on:
                                <asp:Label ID="lblDateAdded" runat="server" Text="" />
                            </small>
                        </div>
                        <!-- Quantity Selector -->
                        <div class="d-flex align-items-center gap-2 mb-3">
                            <label class="fw-semibold">Quantity:</label>
                            <div class="input-group" style="width: 130px;">
                                <button type="button" class="btn btn-outline-success"
                                    onclick="changeQty(-1)">
                                    −</button>
                                <asp:TextBox ID="txtQuantity" runat="server"
                                    Text="1"
                                    CssClass="form-control text-center"      
                                    Style="pointer-events: none;"/>
                                <button type="button" class="btn btn-outline-success"
                                    onclick="changeQty(1)">
                                    +</button>
                            </div>
                            <small class="text-muted">
                                <asp:Label ID="lblPriceUnitQty" runat="server" Text="" />
                            </small>
                        </div>
                        <!-- the user can type anything directly in the box. To prevent that while still allowing JavaScript to change it, we have added this style after textQuantity: also pointer-events: none means the user cannot click or type in the box directly, but JavaScript can still change the value AND the value posts back to the server correctly — best of both worlds. -->


                        <!-- Buy Now Button -->
                        <asp:Button ID="btnBuyNow" runat="server"
                            Text=" Buy Now"
                            CssClass="btn btn-success me-2"
                            OnClick="btnBuyNow_Click"
                            CausesValidation="false" />

                        <!-- Login prompt for ordering -->
                        <asp:Panel ID="pnlOrderLoginPrompt" runat="server" Visible="false">
                            <div class="alert alert-info py-2 mb-3">
                                <i class="bi bi-info-circle me-1"></i>
                                <a href="CustomerLogin.aspx" class="alert-link">Login</a>
                                to place an order.
                            </div>
                        </asp:Panel>

                        <!-- Back Button -->
                        <a href="viewproducts.aspx" class="btn btn-outline-success">
                            <i class="bi bi-arrow-left me-1"></i>Back to Products
                        </a>



                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- ═══ RECOMMENDATION SECTION ═══ -->
        <asp:Panel ID="pnlRecommendations" runat="server" Visible="false">

            <div class="border-bottom border-success mb-4">
                <h4 class="text-success fw-bold pb-2">
                    <i class="bi bi-stars me-2"></i>
                    <asp:Label ID="lblRecommendTitle" runat="server" Text="Recommended For You" />
                </h4>
            </div>

            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4 g-3 mb-5">
                <asp:Repeater ID="rptRecommended" runat="server">
                    <ItemTemplate>
                        <div class="col">
                            <div class="card h-100 shadow-sm border rounded-3 
                                        product-card-hover">
                                <img src='<%# Eval("ImageUrl") %>'
                                    alt='<%# Eval("ProductName") %>'
                                    class="card-img-top"
                                    style="height: 180px; object-fit: cover;" />
                                <div class="card-body">
                                    <span class="badge bg-success bg-opacity-25 
                                                 text-success mb-2">
                                        <%# Eval("Category") %>
                                    </span>
                                    <h6 class="card-title text-success fw-bold">
                                        <%# Eval("ProductName") %>
                                    </h6>
                                    <p class="text-muted mb-1" style="font-size: 0.9rem;">
                                        Rs. <%# Eval("Price") %>/<%# Eval("PriceUnit") %>
                                    </p>
                                    <p class="mb-2" style="color: #f5a623; font-weight: 600; font-size: 0.9rem;">
                                        Rating: <%# Eval("Rating") %>/5
                                    </p>
                                    <%--<a href='Products?id=<%# Eval("ProductID") %>'
                                        class="btn btn-sm btn-outline-success w-100">
                                        <i class="bi bi-eye me-1"></i>View Details
                                    </a>--%>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

        </asp:Panel>

        <!-- Not logged in message -->
        <asp:Panel ID="pnlLoginPrompt" runat="server" Visible="false">
            <div class="alert alert-info d-flex align-items-center mb-5">
                <i class="bi bi-info-circle me-2 fs-5"></i>
                <div>
                    <strong>Want personalized recommendations?</strong>
                    <a href="CustomerLogin.aspx" class="alert-link ms-1">Login</a> or
                    <a href="CustomerRegister.aspx" class="alert-link ms-1">Register</a>
                    to see products based on your preferred category.
                </div>
            </div>
        </asp:Panel>

    </div>

</asp:Content>
