<%@ Page Title="Admin Login" Language="C#" 
    MasterPageFile="~/Site1.Master" 
    AutoEventWireup="true" 
    CodeBehind="AdminLogin.aspx.cs" 
    Inherits="AgricultureProductRecommendation.AdminLogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-5">
                <div class="card shadow border-0 rounded-3">

                    <div class="card-header text-white text-center py-3"
                        style="background-color:#1a237e;">
                        <h4 class="mb-0 fw-bold">
                            <i class="bi bi-shield-lock me-2"></i>Admin Login
                        </h4>
                        <small>Restricted area — admins only</small>
                    </div>

                    <div class="card-body p-4">

                        <asp:Panel ID="pnlError" runat="server" Visible="false">
                            <div class="alert alert-danger d-flex align-items-center mb-3">
                                <i class="bi bi-exclamation-triangle me-2"></i>
                                <asp:Label ID="lblError" runat="server" Text="" />
                            </div>
                        </asp:Panel>

                        <!-- Email -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text text-white"
                                    style="background-color:#1a237e;">
                                    <i class="bi bi-envelope"></i>
                                </span>
                                <asp:TextBox ID="txtEmail" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter admin email"
                                    TextMode="Email" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="Email is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <!-- Password -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text text-white"
                                    style="background-color:#1a237e;">
                                    <i class="bi bi-lock"></i>
                                </span>
                                <asp:TextBox ID="txtPassword" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter admin password"
                                    TextMode="Password" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                ControlToValidate="txtPassword"
                                ErrorMessage="Password is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <!-- Login Button -->
                        <div class="d-grid">
                            <asp:Button ID="btnLogin" runat="server"
                                Text="Login as Admin"
                                CssClass="btn btn-lg text-white"
                                style="background-color:#1a237e;"
                                OnClick="btnLogin_Click" />
                        </div>

                    </div>

                    <div class="card-footer text-center py-3 bg-light">
                        <small class="text-muted">
                            <i class="bi bi-lock-fill me-1"></i>
                            This page is for authorized administrators only.
                        </small>
                    </div>

                </div>
            </div>
        </div>
        <div class="mb-5"></div>
    </div>

</asp:Content>