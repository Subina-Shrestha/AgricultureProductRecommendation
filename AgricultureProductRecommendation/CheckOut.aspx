<%@ Page Title="Checkout" Language="C#"
    MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="Checkout.aspx.cs"
    Inherits="AgricultureProductRecommendation.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="bg-success bg-opacity-10 border-bottom border-success py-3 mb-4">
        <div class="container">
            <h2 class="text-success fw-bold mb-0">Checkout</h2>
            <small class="text-muted">Complete your order</small>
        </div>
    </div>

    <div class="container">
        <div class="row g-4">

            <!-- Left — Delivery Details -->
            <div class="col-md-7">
                <div class="card shadow border-0 rounded-3">
                    <div class="card-header bg-success text-white py-3">
                        <h5 class="mb-0 fw-bold">
                            <i class="bi bi-truck me-2"></i>Delivery Details
                        </h5>
                    </div>
                    <div class="card-body p-4">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Full Name</label>
                            <asp:TextBox ID="txtFullName" runat="server"
                                CssClass="form-control"
                                placeholder="Your full name" />
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtFullName"
                                ErrorMessage="Full name is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Phone Number</label>
                            <asp:TextBox ID="txtPhone" runat="server"
                                CssClass="form-control"
                                placeholder="Your phone number" />
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtPhone"
                                ErrorMessage="Phone is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Delivery Address</label>
                            <asp:TextBox ID="txtAddress" runat="server"
                                CssClass="form-control"
                                placeholder="Full delivery address"
                                TextMode="MultiLine"
                                Rows="3" />
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtAddress"
                                ErrorMessage="Address is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Payment Method</label>
                            <asp:DropDownList ID="ddlPayment" runat="server"
                                CssClass="form-select">
                                <asp:ListItem Value="COD">Cash on Delivery</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                    </div>
                </div>
            </div>

            <!-- Right — Order Summary -->
            <div class="col-md-5">
                <div class="card shadow border-0 rounded-3">
                    <div class="card-header bg-success text-white py-3">
                        <h5 class="mb-0 fw-bold">
                            <i class="bi bi-receipt me-2"></i>Order Summary
                        </h5>
                    </div>
                    <div class="card-body p-0">

                        <asp:Repeater ID="rptOrderSummary" runat="server">
                            <ItemTemplate>
                                <div class="d-flex justify-content-between 
                                            align-items-center px-3 py-2 border-bottom">
                                    <div>
                                        <strong class="text-success">
                                            <%# Eval("ProductName") %>
                                        </strong><br />
                                        <small class="text-muted">
                                            Rs. <%# Eval("Price") %> 
                                            x <%# Eval("Quantity") %>
                                        </small>
                                    </div>
                                    <span class="fw-bold text-success">
                                        Rs. <%# String.Format("{0:0.00}",
                                              Convert.ToDecimal(Eval("Price")) *
                                              Convert.ToInt32(Eval("Quantity"))) %>
                                    </span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <!-- Total -->
                        <div class="d-flex justify-content-between px-3 py-3 bg-light">
                            <h5 class="fw-bold mb-0">Total</h5>
                            <h5 class="fw-bold text-success mb-0">
                                Rs. <asp:Label ID="lblTotal" runat="server" Text="0" />
                            </h5>
                        </div>

                    </div>
                </div>

                <!-- Place Order Button -->
                <div class="d-grid mt-3">
                    <asp:Button ID="btnPlaceOrder" runat="server"
                        Text=" Place Order"
                        CssClass="btn btn-success btn-lg"
                        OnClick="btnPlaceOrder_Click" />
                </div>

                <!-- Back link -->
                <div class="text-center mt-2">
                    <a href="javascript:history.back()"
                       class="text-muted small">
                        <i class="bi bi-arrow-left me-1"></i>Go Back
                    </a>
                </div>

            </div>
        </div>
        <div class="mb-5"></div>
    </div>

</asp:Content>
