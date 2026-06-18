<%@ Page Title="Add Product" Language="C#" 
    MasterPageFile="~/Site1.Master" 
    AutoEventWireup="true" 
    CodeBehind="AddProduct.aspx.cs" 
    Inherits="AgricultureProductRecommendation.AddProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Page Banner -->
    <div class="bg-success bg-opacity-10 border-bottom border-success py-3 mb-4">
        <div class="container">
            <h2 class="text-success fw-bold mb-0">
                <i class="bi bi-plus-circle me-2"></i>Add Product
            </h2>
            <small class="text-muted">Add a new agriculture product to the system</small>
        </div>
    </div>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7">
                <div class="card shadow border-0 rounded-3">

                    <!-- Card Header -->
                    <div class="card-header bg-success text-white py-3">
                        <h5 class="mb-0 fw-bold">Product Details</h5>
                    </div>

                    <!-- Card Body -->
                    <div class="card-body p-4">

                        <!-- Success Message -->
                        <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                            <div class="alert alert-success d-flex align-items-center mb-3">
                                <i class="bi bi-check-circle me-2"></i>
                                <asp:Label ID="lblSuccess" runat="server" Text="" />
                            </div>
                        </asp:Panel>

                        <!-- Error Message -->
                        <asp:Panel ID="pnlError" runat="server" Visible="false">
                            <div class="alert alert-danger d-flex align-items-center mb-3">
                                <i class="bi bi-exclamation-triangle me-2"></i>
                                <asp:Label ID="lblError" runat="server" Text="" />
                            </div>
                        </asp:Panel>

                        <!-- Product Name -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Product Name</label>
                            <asp:TextBox ID="txtProductName" runat="server"
                                CssClass="form-control"
                                placeholder="e.g. Orange" />
                            <asp:RequiredFieldValidator ID="rfvProductName" runat="server"
                                ControlToValidate="txtProductName"
                                ErrorMessage="Product name is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <!-- Price and Price Unit in one row -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Price (Rs.)</label>
                                <asp:TextBox ID="txtPrice" runat="server"
                                    CssClass="form-control"
                                    placeholder="e.g. 100"
                                    TextMode="Number" />
                                <asp:RequiredFieldValidator ID="rfvPrice" runat="server"
                                    ControlToValidate="txtPrice"
                                    ErrorMessage="Price is required"
                                    CssClass="text-danger small"
                                    Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Price Unit</label>
                                <asp:DropDownList ID="ddlPriceUnit" runat="server"
                                    CssClass="form-select">
                                    <asp:ListItem Value="Kg">Kg</asp:ListItem>
                                    <asp:ListItem Value="Dozon">Dozon</asp:ListItem>
                                    <asp:ListItem Value="Piece">Piece</asp:ListItem>
                                    <asp:ListItem Value="100 kg">100 kg</asp:ListItem>
                                    <asp:ListItem Value="200 kg">200 kg</asp:ListItem>
                                    <asp:ListItem Value="Litre">Litre</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <!-- Category -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server"
                                CssClass="form-select">
                                <asp:ListItem Value="">-- Select Category --</asp:ListItem>
                                <asp:ListItem Value="Fruits">Fruits</asp:ListItem>
                                <asp:ListItem Value="Vegetables">Vegetables</asp:ListItem>
                                <asp:ListItem Value="Grains">Grains</asp:ListItem>
                                <asp:ListItem Value="Dairy">Dairy</asp:ListItem>
                                <asp:ListItem Value="Organic">Organic</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvCategory" runat="server"
                                ControlToValidate="ddlCategory"
                                InitialValue=""
                                ErrorMessage="Please select a category"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Description</label>
                            <asp:TextBox ID="txtDescription" runat="server"
                                CssClass="form-control"
                                placeholder="Brief description of the product"
                                TextMode="MultiLine"
                                Rows="3" />
                        </div>

                        <!-- Rating -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Rating</label>
                            <asp:DropDownList ID="ddlRating" runat="server"
                                CssClass="form-select">
                                <asp:ListItem Value="1">1 - Poor</asp:ListItem>
                                <asp:ListItem Value="2">2 - Fair</asp:ListItem>
                                <asp:ListItem Value="3">3 - Good</asp:ListItem>
                                <asp:ListItem Value="4">4 - Very Good</asp:ListItem>
                                <asp:ListItem Value="5">5 - Excellent</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- Image Upload -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Product Image</label>
                            <asp:FileUpload ID="fuImage" runat="server"
                                CssClass="form-control" />
                            <small class="text-muted">Accepted formats: .jpg, .jpeg, .png, .gif</small>
                        </div>

                        <!-- Is Top Product -->
                        <div class="mb-4 form-check">
                            <asp:CheckBox ID="chkIsTop" runat="server"
                                CssClass="form-check-input" />
                            <label class="form-check-label fw-semibold">
                                Mark as Top Product
                            </label>
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex gap-2">
                            <asp:Button ID="btnAdd" runat="server"
                                Text="Add Product"
                                CssClass="btn btn-success"
                                OnClick="btnAdd_Click" />
                            <asp:Button ID="btnClear" runat="server"
                                Text="Clear"
                                CssClass="btn btn-secondary"
                                OnClick="btnClear_Click"
                                CausesValidation="false" />
                            <a href="ManageProduct.aspx" class="btn btn-outline-success">
                                Manage Products
                            </a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <div class="mb-5"></div>
    </div>

</asp:Content>