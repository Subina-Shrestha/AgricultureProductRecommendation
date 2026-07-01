<%@ Page Title="Forgot Password" Language="C#" 
    MasterPageFile="~/Site1.Master" 
    AutoEventWireup="true" 
    CodeBehind="ForgotPassword.aspx.cs" 
    Inherits="AgricultureProductRecommendation.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-5">
                <div class="card shadow border-0 rounded-3">

                    <div class="card-header bg-success text-white text-center py-3">
                        <h4 class="mb-0 fw-bold">
                            <i class="bi bi-key me-2"></i>Forgot Password
                        </h4>
                        <small>Enter your email to receive a reset link</small>
                    </div>

                    <div class="card-body p-4">

                        <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                            <div class="alert alert-info d-flex align-items-center mb-3">
                                <i class="bi bi-info-circle me-2"></i>
                                <asp:Label ID="lblMessage" runat="server" Text="" />
                            </div>
                        </asp:Panel>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-envelope"></i>
                                </span>
                                <asp:TextBox ID="txtEmail" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter your registered email"
                                    TextMode="Email" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="Email is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <div class="d-grid mb-3">
                            <asp:Button ID="btnSubmit" runat="server"
                                Text="Send New Password"
                                CssClass="btn btn-success btn-lg"
                                OnClick="btnSubmit_Click" />
                        </div>

                    </div>

                    <div class="card-footer text-center py-3 bg-light">
                        <small class="text-muted">
                            Remembered your password?
                            <a href="CustomerLogin.aspx" class="text-success fw-semibold">Back to Login</a>
                        </small>
                    </div>

                </div>
            </div>
        </div>
        <div class="mb-5"></div>
    </div>

</asp:Content>