<%@ Page Title="Forgot Password" Language="C#" 
    MasterPageFile="~/Site1.Master" 
    AutoEventWireup="true" 
    CodeBehind="ForgotPassword.aspx.cs" 
    Inherits="AgricultureProductRecommendation.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #resetMethodTabs .nav-link {
            color: #2e7d32;
            border: 1px solid #2e7d32;
        }

        #resetMethodTabs .nav-link.active {
            background-color: #2e7d32;
            color: #fff;
            border-color: #2e7d32;
        }

        #resetMethodTabs .nav-item:first-child .nav-link {
            border-top-right-radius: 0;
            border-bottom-right-radius: 0;
        }

        #resetMethodTabs .nav-item:last-child .nav-link {
            border-top-left-radius: 0;
            border-bottom-left-radius: 0;
        }
    </style>
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
                        <small>Choose how you'd like to reset your password</small>
                    </div>

                    <div class="card-body p-4">

                        <!-- Method toggle -->
                        <ul class="nav nav-pills nav-fill mb-4" id="resetMethodTabs">
                            <li class="nav-item">
                                <button type="button" class="nav-link" id="btnTabEmail">
                                    <i class="bi bi-envelope me-1"></i> Email
                                </button>
                            </li>
                            <li class="nav-item">
                                <button type="button" class="nav-link" id="btnTabPhone">
                                    <i class="bi bi-phone me-1"></i> Phone Number
                                </button>
                            </li>
                        </ul>

                        <asp:HiddenField ID="hdnResetMethod" runat="server" Value="" ClientIDMode="Static" />

                        <!-- Email input (hidden until Email tab is clicked) -->
                        <div class="mb-4 d-none" id="emailInputGroup">
                            <label class="form-label fw-semibold">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-envelope"></i>
                                </span>
                                <asp:TextBox ID="txtEmail" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter your registered email"
                                    TextMode="Email"
                                    ClientIDMode="Static" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="Email is required"
                                CssClass="text-danger small"
                                Display="Dynamic"
                                ValidationGroup="EmailGroup" />
                        </div>

                        <!-- Phone input (dummy, hidden until Phone tab is clicked) -->
                        <div class="mb-4 d-none" id="phoneInputGroup">
                            <label class="form-label fw-semibold">Phone Number</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-phone"></i>
                                </span>
                                <asp:TextBox ID="txtPhone" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter your registered phone number"
                                    TextMode="Phone"
                                    ClientIDMode="Static" />
                            </div>
                      
                        </div>

                        <div class="d-grid mb-3 d-none" id="submitButtonGroup">
                            <asp:Button ID="btnSubmit" runat="server"
                                Text="Submit"
                                CssClass="btn btn-success btn-lg"
                                OnClick="btnSubmit_Click"
                                ValidationGroup="EmailGroup"
                                CausesValidation="true" />
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

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var tabEmail = document.getElementById('btnTabEmail');
            var tabPhone = document.getElementById('btnTabPhone');
            var hdn = document.getElementById('hdnResetMethod');
            var emailGroup = document.getElementById('emailInputGroup');
            var phoneGroup = document.getElementById('phoneInputGroup');
            var submitGroup = document.getElementById('submitButtonGroup');

            if (!tabEmail || !tabPhone) {
                console.error('Reset method tabs not found in DOM.');
                return;
            }

            function selectMethod(method) {
                hdn.value = method;
                submitGroup.classList.remove('d-none');

                if (method === 'email') {
                    emailGroup.classList.remove('d-none');
                    phoneGroup.classList.add('d-none');
                    tabEmail.classList.add('active');
                    tabPhone.classList.remove('active');
                } else {
                    emailGroup.classList.add('d-none');
                    phoneGroup.classList.remove('d-none');
                    tabEmail.classList.remove('active');
                    tabPhone.classList.add('active');
                }
            }

            tabEmail.addEventListener('click', function () {
                selectMethod('email');
            });

            tabPhone.addEventListener('click', function () {
                selectMethod('phone');
            });
        });
    </script>

</asp:Content>