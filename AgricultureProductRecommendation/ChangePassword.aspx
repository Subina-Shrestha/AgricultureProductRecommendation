<%@ Page Title="Change Password" Language="C#"
    MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="ChangePassword.aspx.cs"
    Inherits="AgricultureProductRecommendation.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-5">
                <div class="card shadow border-0 rounded-3">

                    <div class="card-header bg-success text-white text-center py-3">
                        <h4 class="mb-0 fw-bold">
                            <i class="bi bi-shield-lock me-2"></i>Change Password
                        </h4>
                        <small>Update your account password</small>
                    </div>

                    <div class="card-body p-4">

                        <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                            <div class="alert alert-info d-flex align-items-center mb-3">
                                <i class="bi bi-info-circle me-2"></i>
                                <asp:Label ID="lblMessage" runat="server" Text="" />
                            </div>
                        </asp:Panel>

                        <!-- Current Password -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Current Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-lock"></i>
                                </span>
                                <asp:TextBox ID="txtCurrentPassword" runat="server"
                                    CssClass="form-control"
                                    TextMode="Password"
                                    placeholder="Enter current password"
                                    ClientIDMode="Static" />
                                <button type="button" class="toggle-pw" onclick="toggleVisibility('txtCurrentPassword', 'eyeCurrentPassword')"
                                    title="Show / hide password" tabindex="-1">
                                    <i id="eyeCurrentPassword" class="bi bi-eye"></i>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvCurrent" runat="server"
                                ControlToValidate="txtCurrentPassword"
                                ErrorMessage="Current password is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <!-- New Password -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">New Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-lock"></i>
                                </span>
                                <asp:TextBox ID="txtNewPassword" runat="server"
                                    CssClass="form-control"
                                    TextMode="Password"
                                    placeholder="Enter new password"
                                    ClientIDMode="Static" />
                                <button type="button" class="toggle-pw" onclick="toggleVisibility('txtNewPassword', 'eyeNewPassword')"
                                    title="Show / hide password" tabindex="-1">
                                    <i id="eyeNewPassword" class="bi bi-eye"></i>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvNew" runat="server"
                                ControlToValidate="txtNewPassword"
                                ErrorMessage="New password is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <!-- Confirm New Password -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Confirm New Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-lock"></i>
                                </span>
                                <asp:TextBox ID="txtConfirmPassword" runat="server"
                                    CssClass="form-control"
                                    TextMode="Password"
                                    placeholder="Confirm new password"
                                    ClientIDMode="Static" />
                                <button type="button" class="toggle-pw" onclick="toggleVisibility('txtConfirmPassword', 'eyeConfirmPassword')"
                                    title="Show / hide password" tabindex="-1">
                                    <i id="eyeConfirmPassword" class="bi bi-eye"></i>
                                </button>
                            </div>
                            <asp:CompareValidator ID="cvConfirm" runat="server"
                                ControlToValidate="txtConfirmPassword"
                                ControlToCompare="txtNewPassword"
                                ErrorMessage="Passwords do not match"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <div class="d-grid mb-3">
                            <asp:Button ID="btnChange" runat="server"
                                Text="Update Password"
                                CssClass="btn btn-success btn-lg"
                                OnClick="btnChange_Click" />
                        </div>

                    </div>

                </div>
            </div>
        </div>
        <div class="mb-5"></div>
    </div>

    <script>
        function toggleVisibility(inputId, iconId) {
            var input = document.getElementById(inputId);
            var icon = document.getElementById(iconId);

            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");
            } else {
                input.type = "password";
                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            }
        }
    </script>

</asp:Content>