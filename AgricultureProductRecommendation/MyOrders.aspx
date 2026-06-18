<%@ Page Title="My Orders" Language="C#"
    MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="MyOrders.aspx.cs"
    Inherits="AgricultureProductRecommendation.MyOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="bg-success bg-opacity-10 border-bottom border-success py-3 mb-4">
        <div class="container">
            <h2 class="text-success fw-bold mb-0">
                <i class="bi bi-bag me-2"></i>My Orders
            </h2>
            <small class="text-muted">View your order history</small>
        </div>
    </div>

    <div class="container">

        <!-- No orders message -->
        <asp:Panel ID="pnlNoOrders" runat="server" Visible="false">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-bag-x fs-1 d-block mb-3"></i>
                <h5>You have no orders yet.</h5>
                <a href="viewproducts.aspx" class="btn btn-success mt-2">
                    Start Shopping
                </a>
            </div>
        </asp:Panel>

        <!-- Orders list -->
        <asp:Panel ID="pnlOrders" runat="server" Visible="false">
            <asp:Repeater ID="rptOrders" runat="server">
                <ItemTemplate>
                    <div class="card shadow-sm border-0 rounded-3 mb-4">

                        <!-- Order Header -->
                        <div class="card-header bg-light d-flex 
                                    justify-content-between align-items-center py-3">
                            <div>
                                <span class="fw-bold text-success me-3">
                                    Order #<%# Eval("OrderID") %>
                                </span>
                                <small class="text-muted">
                                    <i class="bi bi-calendar me-1"></i>
                                    <%# Convert.ToDateTime(Eval("OrderDate"))
                                        .ToString("dd MMM yyyy hh:mm tt") %>
                                </small>
                            </div>

                            <!-- Status Badge -->
                            <span class='<%# GetStatusBadge(Eval("Status").ToString()) %>'>
                                <%# Eval("Status") %>
                            </span>
                        </div>

                        <!-- Order Body -->
                        <div class="card-body p-4">
                            <div class="row">

                                <!-- Products -->
                                <div class="col-md-8">
                                    <h6 class="fw-bold text-muted mb-3">
                                        <i class="bi bi-box me-1"></i>Items Ordered
                                    </h6>
                                    <table class="table table-sm">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Product</th>
                                                <th>Qty</th>
                                                <th>Unit Price</th>
                                                <th>Subtotal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <asp:Repeater ID="rptOrderItems" runat="server"
                                                DataSource='<%# GetOrderItems(
                                                    Convert.ToInt32(Eval("OrderID"))) %>'>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td>
                                                            <img src='<%# Eval("ImageUrl") %>'
                                                                style="width:40px;height:40px;
                                                                       object-fit:cover;
                                                                       border-radius:4px;"
                                                                class="me-2" />
                                                            <%# Eval("ProductName") %>
                                                        </td>
                                                        <td><%# Eval("Quantity") %></td>
                                                        <td>Rs. <%# Eval("Price") %></td>
                                                        <td class="fw-bold text-success">
                                                            Rs. <%# String.Format("{0:0.00}",
                                                                  Convert.ToDecimal(Eval("Price")) *
                                                                  Convert.ToInt32(Eval("Quantity"))) %>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Delivery Info -->
                                <div class="col-md-4">
                                    <h6 class="fw-bold text-muted mb-3">
                                        <i class="bi bi-truck me-1"></i>Delivery Info
                                    </h6>
                                    <p class="mb-1">
                                        <i class="bi bi-person me-1 text-success"></i>
                                        <strong><%# Eval("FullName") %></strong>
                                    </p>
                                    <p class="mb-1">
                                        <i class="bi bi-telephone me-1 text-success"></i>
                                        <%# Eval("Phone") %>
                                    </p>
                                    <p class="mb-3">
                                        <i class="bi bi-geo-alt me-1 text-success"></i>
                                        <%# Eval("Address") %>
                                    </p>

                                    <div class="bg-success bg-opacity-10 
                                                rounded p-2 text-center">
                                        <small class="text-muted">Total Amount</small>
                                        <h5 class="text-success fw-bold mb-0">
                                            Rs. <%# Eval("TotalAmount") %>
                                        </h5>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>

        <div class="mb-5"></div>
    </div>
</asp:Content>