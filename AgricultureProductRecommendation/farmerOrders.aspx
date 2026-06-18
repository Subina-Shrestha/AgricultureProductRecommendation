<%@ Page Title="Customer Orders" Language="C#"
    MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="FarmerOrders.aspx.cs"
    Inherits="AgricultureProductRecommendation.FarmerOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Page Banner -->
    <div class="bg-success bg-opacity-10 border-bottom border-success py-3 mb-4">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="text-success fw-bold mb-0">
                        <i class="bi bi-bag-check me-2"></i>Customer Orders
                    </h2>
                    <small class="text-muted">View and manage all customer orders</small>
                </div>
                <div class="d-flex gap-2">
                    <a href="ManageProduct.aspx" class="btn btn-outline-success">
                        <i class="bi bi-grid me-1"></i>Manage Products
                    </a>
                    <a href="AddProduct.aspx" class="btn btn-success">
                        <i class="bi bi-plus-circle me-1"></i>Add Product
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Order Stats -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card border-0 shadow-sm text-center p-3">
                    <h3 class="text-success fw-bold mb-0">
                        <asp:Label ID="lblTotalOrders" runat="server" Text="0" />
                    </h3>
                    <small class="text-muted">Total Orders</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm text-center p-3">
                    <h3 class="text-warning fw-bold mb-0">
                        <asp:Label ID="lblPendingOrders" runat="server" Text="0" />
                    </h3>
                    <small class="text-muted">Pending</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm text-center p-3">
                    <h3 class="text-primary fw-bold mb-0">
                        <asp:Label ID="lblDeliveredOrders" runat="server" Text="0" />
                    </h3>
                    <small class="text-muted">Delivered</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm text-center p-3">
                    <h3 class="text-success fw-bold mb-0">
                        Rs. <asp:Label ID="lblTotalRevenue" runat="server" Text="0" />
                    </h3>
                    <small class="text-muted">Total Revenue</small>
                </div>
            </div>
        </div>

        <!-- Filter by Status -->
        <div class="bg-light border rounded p-3 mb-4 d-flex align-items-center gap-2">
            <label class="fw-semibold me-2">Filter by Status:</label>
            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" Style="width:180px;">
                <asp:ListItem Value="">All Orders</asp:ListItem>
                <asp:ListItem Value="Pending">Pending</asp:ListItem>
                <asp:ListItem Value="Processing">Processing</asp:ListItem>
                <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
            </asp:DropDownList>
            <asp:Button ID="btnFilter" runat="server" Text="Filter"
                CssClass="btn btn-success"
                OnClick="btnFilter_Click"
                CausesValidation="false" />
            <asp:Button ID="btnReset" runat="server" Text="Reset"
                CssClass="btn btn-secondary"
                OnClick="btnReset_Click"
                CausesValidation="false" />
        </div>

        <!-- Success Message -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
            <div class="alert alert-success mb-3">
                <i class="bi bi-check-circle me-2"></i>
                <asp:Label ID="lblSuccess" runat="server" Text="" />
            </div>
        </asp:Panel>

        <!-- Orders Table -->
        <div class="card shadow border-0 rounded-3">
            <div class="card-header bg-success text-white py-3">
                <h5 class="mb-0 fw-bold">All Orders</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <asp:GridView ID="gvOrders" runat="server"
                        CssClass="table table-hover mb-0"
                        AutoGenerateColumns="false"
                        DataKeyNames="OrderID"
                        OnRowCommand="gvOrders_RowCommand">

                        <HeaderStyle CssClass="table-success" />
                        <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                No orders found.
                            </div>
                        </EmptyDataTemplate>

                        <Columns>

                            <asp:BoundField DataField="OrderID"
                                HeaderText="Order ID"
                                ItemStyle-CssClass="fw-bold text-success" />

                            <asp:TemplateField HeaderText="Customer">
                                <ItemTemplate>
                                    <strong><%# Eval("FullName") %></strong><br />
                                    <small class="text-muted"><%# Eval("Phone") %></small>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Address">
                                <ItemTemplate>
                                    <small><%# Eval("Address") %></small>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Products">
                                <ItemTemplate>
                                    <small><%# Eval("ProductNames") %></small>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Total">
                                <ItemTemplate>
                                    <span class="fw-bold text-success">
                                        Rs. <%# Eval("TotalAmount") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Order Date">
                                <ItemTemplate>
                                    <%# Convert.ToDateTime(Eval("OrderDate"))
                                        .ToString("dd MMM yyyy") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:DropDownList ID="ddlOrderStatus" runat="server"
                                        CssClass="form-select form-select-sm"
                                        Style="width:130px;">
                                        <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                        <asp:ListItem Value="Processing">Processing</asp:ListItem>
                                        <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                                        <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                                    </asp:DropDownList>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkUpdateStatus" runat="server"
                                        CommandName="UpdateStatus"
                                        CommandArgument='<%# Eval("OrderID") %>'
                                        CssClass="btn btn-sm btn-success">
                                        <i class="bi bi-check2"></i> Update
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <div class="mb-5"></div>
    </div>
</asp:Content>