<%@ Page Title="Register" Language="C#" 
    MasterPageFile="~/Site1.Master" 
    AutoEventWireup="true" 
    CodeBehind="CustomerRegister.aspx.cs" 
    Inherits="AgricultureProductRecommendation.CustomerRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-6">
                <div class="card shadow border-0 rounded-3">

                    <div class="card-header bg-success text-white text-center py-3">
                        <h4 class="mb-0 fw-bold">
                            <i class="bi bi-person-plus me-2"></i>Create Account
                        </h4>
                        <small>Register to get personalized recommendations</small>
                    </div>

                    <div class="card-body p-4">

                        <asp:Panel ID="pnlError" runat="server" Visible="false">
                            <div class="alert alert-danger d-flex align-items-center mb-3">
                                <i class="bi bi-exclamation-triangle me-2"></i>
                                <asp:Label ID="lblError" runat="server" Text="" />
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                            <div class="alert alert-success d-flex align-items-center mb-3">
                                <i class="bi bi-check-circle me-2"></i>
                                <asp:Label ID="lblSuccess" runat="server" Text="" />
                            </div>
                        </asp:Panel>

                        <!-- Full Name -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Full Name</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-person"></i>
                                </span>
                                <asp:TextBox ID="txtFullName" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter your full name" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                                ControlToValidate="txtFullName"
                                ErrorMessage="Full name is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

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

                        <!-- Phone -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Phone Number</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-telephone"></i>
                                </span>
                                <asp:TextBox ID="txtPhone" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter your phone number" />
                            </div>
                        </div>

                        <!-- Preferred Category -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Preferred Category</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-tag"></i>
                                </span>
                                <asp:DropDownList ID="ddlCategory" runat="server"
                                    CssClass="form-select">
                                    <asp:ListItem Value="">-- Select Preference --</asp:ListItem>
                                    <asp:ListItem Value="Fruits">Fruits</asp:ListItem>
                                    <asp:ListItem Value="Vegetables">Vegetables</asp:ListItem>
                                    <asp:ListItem Value="Grains">Grains</asp:ListItem>
                                    <asp:ListItem Value="Dairy">Dairy</asp:ListItem>
                                    <asp:ListItem Value="Organic">Organic</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvCategory" runat="server"
                                ControlToValidate="ddlCategory"
                                InitialValue=""
                                ErrorMessage="Please select a preferred category"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <!-- Password -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-lock"></i>
                                </span>
                                <asp:TextBox ID="txtPassword" runat="server"
                                    CssClass="form-control"
                                    placeholder="Create a password"
                                    TextMode="Password" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                ControlToValidate="txtPassword"
                                ErrorMessage="Password is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <!-- Confirm Password -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Confirm Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-lock-fill"></i>
                                </span>
                                <asp:TextBox ID="txtConfirmPassword" runat="server"
                                    CssClass="form-control"
                                    placeholder="Re-enter your password"
                                    TextMode="Password" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                                ControlToValidate="txtConfirmPassword"
                                ErrorMessage="Please confirm your password"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <asp:CompareValidator ID="cvPassword" runat="server"
                                ControlToValidate="txtConfirmPassword"
                                ControlToCompare="txtPassword"
                                ErrorMessage="Passwords do not match"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <!-- Register Button -->
                        <div class="d-grid mb-3">
                            <asp:Button ID="btnRegister" runat="server"
                                Text="Create Account"
                                CssClass="btn btn-success btn-lg"
                                OnClick="btnRegister_Click" />
                        </div>

                    </div>

                    <div class="card-footer text-center py-3 bg-light">
                        <small class="text-muted">
                            Already have an account?
                            <a href="CustomerLogin.aspx" class="text-success fw-semibold">Login here</a>
                        </small>
                    </div>

                </div>
            </div>
        </div>
        <div class="mb-5"></div>
    </div>

</asp:Content>