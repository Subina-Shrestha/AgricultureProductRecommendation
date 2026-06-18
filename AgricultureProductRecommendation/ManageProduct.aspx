<%@ Page Title="Manage Products" Language="C#" 
    MasterPageFile="~/Site1.Master" 
    AutoEventWireup="true" 
    CodeBehind="ManageProduct.aspx.cs" 
    Inherits="AgricultureProductRecommendation.ManageProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Page Banner -->
    <div class="bg-success bg-opacity-10 border-bottom border-success py-3 mb-4">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="text-success fw-bold mb-0">
                        <i class="bi bi-grid me-2"></i>Manage Products
                    </h2>
                    <small class="text-muted">View, edit and delete your products</small>
                </div>
                <div class="d-flex gap-2">
                    <a href="AddProduct.aspx" class="btn btn-success">
                        <i class="bi bi-plus-circle me-1"></i>Add Product
                    </a>
                    <asp:Button ID="btnLogout" runat="server"
                        Text="Log Out"
                        CssClass="btn btn-outline-danger"
                        OnClick="btnLogout_Click"
                        CausesValidation="false" />
                </div>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Welcome message -->
        <div class="alert alert-success d-flex align-items-center mb-4">
            <i class="bi bi-person-check me-2"></i>
            Welcome, <strong class="ms-1">
                <asp:Label ID="lblFarmerName" runat="server" Text="" />
            </strong>
        </div>

        <!-- Success / Error messages -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
            <div class="alert alert-success d-flex align-items-center mb-3">
                <i class="bi bi-check-circle me-2"></i>
                <asp:Label ID="lblSuccess" runat="server" Text="" />
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlError" runat="server" Visible="false">
            <div class="alert alert-danger d-flex align-items-center mb-3">
                <i class="bi bi-exclamation-triangle me-2"></i>
                <asp:Label ID="lblError" runat="server" Text="" />
            </div>
        </asp:Panel>

        <!-- Products Table -->
        <div class="card shadow border-0 rounded-3">
            <div class="card-header bg-success text-white py-3">
                <h5 class="mb-0 fw-bold">All Products</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <asp:GridView ID="gvProducts" runat="server"
                        CssClass="table table-hover table-striped mb-0"
                        AutoGenerateColumns="false"
                        DataKeyNames="ProductID"
                        OnRowEditing="gvProducts_RowEditing"
                        OnRowCancelingEdit="gvProducts_RowCancelingEdit"
                        OnRowUpdating="gvProducts_RowUpdating"
                        OnRowDeleting="gvProducts_RowDeleting">

                        <HeaderStyle CssClass="table-success" />

                        <Columns>

                            
                            <asp:TemplateField HeaderText="Image">
                                <ItemTemplate>
                                    <img src='<%# Eval("ImageURL") %>'
                                         alt='<%# Eval("ProductName") %>'
                                         style="width:60px;height:60px;
                                                object-fit:cover;
                                                border-radius:6px;" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            
                            <asp:TemplateField HeaderText="Product Name">
                                <ItemTemplate>
                                    <strong class="text-success">
                                        <%# Eval("ProductName") %>
                                    </strong>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditName" runat="server"
                                        Text='<%# Eval("ProductName") %>'
                                        CssClass="form-control form-control-sm" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            
                            <asp:TemplateField HeaderText="Price">
                                <ItemTemplate>
                                    Rs. <%# Eval("Price") %>/<%# Eval("PriceUnit") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditPrice" runat="server"
                                        Text='<%# Eval("Price") %>'
                                        CssClass="form-control form-control-sm"
                                        style="width:80px;" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            
                            <asp:TemplateField HeaderText="Category">
                                <ItemTemplate>
                                    <span class="badge bg-success bg-opacity-25 text-success">
                                        <%# Eval("Category") %>
                                    </span>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditCategory" runat="server"
                                        CssClass="form-select form-select-sm">
                                        <asp:ListItem Value="Fruits">Fruits</asp:ListItem>
                                        <asp:ListItem Value="Vegetables">Vegetables</asp:ListItem>
                                        <asp:ListItem Value="Grains">Grains</asp:ListItem>
                                        <asp:ListItem Value="Dairy">Dairy</asp:ListItem>
                                        <asp:ListItem Value="Organic">Organic</asp:ListItem>
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Rating">
                                <ItemTemplate>
                                    <span style="color:#f5a623; font-weight:600;">
                                        <%# Eval("Rating") %>/5
                                    </span>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditRating" runat="server"
                                        CssClass="form-select form-select-sm">
                                        <asp:ListItem Value="1">1</asp:ListItem>
                                        <asp:ListItem Value="2">2</asp:ListItem>
                                        <asp:ListItem Value="3">3</asp:ListItem>
                                        <asp:ListItem Value="4">4</asp:ListItem>
                                        <asp:ListItem Value="5">5</asp:ListItem>
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                           
                            <asp:TemplateField HeaderText="Top Product">
                                <ItemTemplate>
                                    <%# Convert.ToBoolean(Eval("IsTopProduct")) ? 
                                        "<span class='badge bg-success'>Yes</span>" : 
                                        "<span class='badge bg-secondary'>No</span>" %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:CheckBox ID="chkEditIsTop" runat="server"
                                        Checked='<%# Convert.ToBoolean(Eval("IsTopProduct")) %>' />
                                </EditItemTemplate>
                            </asp:TemplateField>

                           
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEdit" runat="server"
                                        CommandName="Edit"
                                        CssClass="btn btn-sm btn-outline-success me-1">
                                        <i class="bi bi-pencil"></i> Edit
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lnkDelete" runat="server"
                                        CommandName="Delete"
                                        CssClass="btn btn-sm btn-outline-danger"
                                        OnClientClick="return confirm('Are you sure you want to delete this product?');">
                                        <i class="bi bi-trash"></i> Delete
                                    </asp:LinkButton>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton ID="lnkUpdate" runat="server"
                                        CommandName="Update"
                                        CssClass="btn btn-sm btn-success me-1">
                                        <i class="bi bi-check"></i> Update
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lnkCancel" runat="server"
                                        CommandName="Cancel"
                                        CssClass="btn btn-sm btn-secondary">
                                        <i class="bi bi-x"></i> Cancel
                                    </asp:LinkButton>
                                </EditItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <div class="mb-5"></div>
    </div>

</asp:Content>