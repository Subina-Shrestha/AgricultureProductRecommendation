<%@ Page Title="Reset Password" Language="C#" 
    MasterPageFile="~/Site1.Master" 
    AutoEventWireup="true" 
    CodeBehind="ResetPassword.aspx.cs" 
    Inherits="AgricultureProductRecommendation.ResetPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-5">
                <div class="card shadow border-0 rounded-3">

                    <div class="card-header bg-success text-white text-center py-3">
                        <h4 class="mb-0 fw-bold">
                            <i class="bi bi-shield-lock me-2"></i>Reset Password
                        </h4>
                        <small>Choose a new password</small>
                    </div>

                    <div class="card-body p-4">

                        <asp:Panel ID="pnlInvalid" runat="server" Visible="false">
                            <div class="alert alert-danger d-flex align-items-center mb-3">
                                <i class="bi bi-exclamation-triangle me-2"></i>
                                This reset link is invalid or has expired. Please request a new one.
                            </div>
                            <div class="d-grid">
                                <a href="ForgotPassword.aspx" class="btn btn-outline-success">Request New Link</a>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnlForm" runat="server">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">New Password</label>
                                <asp:TextBox ID="txtNewPassword" runat="server"
                                    CssClass="form-control"
                                    TextMode="Password"
                                    placeholder="Enter new password" />
                                <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server"
                                    ControlToValidate="txtNewPassword"
                                    ErrorMessage="New password is required"
                                    CssClass="text-danger small"
                                    Display="Dynamic" />
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Confirm Password</label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server"
                                    CssClass="form-control"
                                    TextMode="Password"
                                    placeholder="Confirm new password" />
                                <asp:CompareValidator ID="cvPassword" runat="server"
                                    ControlToValidate="txtConfirmPassword"
                                    ControlToCompare="txtNewPassword"
                                    ErrorMessage="Passwords do not match"
                                    CssClass="text-danger small"
                                    Display="Dynamic" />
                            </div>

                            <div class="d-grid mb-3">
                                <asp:Button ID="btnReset" runat="server"
                                    Text="Reset Password"
                                    CssClass="btn btn-success btn-lg"
                                    OnClick="btnReset_Click" />
                            </div>

                        </asp:Panel>

                    </div>

                </div>
            </div>
        </div>
        <div class="mb-5"></div>
    </div>

</asp:Content>