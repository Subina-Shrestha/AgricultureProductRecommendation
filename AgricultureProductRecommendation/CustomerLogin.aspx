<%@ Page Title="Customer Login" Language="C#" 
    MasterPageFile="~/Site1.Master" 
    AutoEventWireup="true" 
    CodeBehind="CustomerLogin.aspx.cs" 
    Inherits="AgricultureProductRecommendation.CustomerLogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-5">
                <div class="card shadow border-0 rounded-3">

                    <div class="card-header bg-success text-white text-center py-3">
                        <h4 class="mb-0 fw-bold">
                            <i class="bi bi-person-check me-2"></i>Customer Login
                        </h4>
                        <small>Login to see personalized recommendations</small>
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
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-envelope"></i>
                                </span>
                                <asp:TextBox ID="txtEmail" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter your email"
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
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-lock"></i>
                                </span>
                                <asp:TextBox ID="txtPassword" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter your password"
                                    TextMode="Password" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                ControlToValidate="txtPassword"
                                ErrorMessage="Password is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <!-- Login Button -->
                        <div class="d-grid mb-3">
                            <asp:Button ID="btnLogin" runat="server"
                                Text="Login"
                                CssClass="btn btn-success btn-lg"
                                OnClick="btnLogin_Click" />
                        </div>

                    </div>

                    <div class="card-footer text-center py-3 bg-light">
                        <small class="text-muted">
                            Don't have an account?
                            <a href="CustomerRegister.aspx" class="text-success fw-semibold">Register here</a>
                        </small>
                    </div>

                </div>
            </div>
        </div>
        <div class="mb-5"></div>
    </div>

</asp:Content>