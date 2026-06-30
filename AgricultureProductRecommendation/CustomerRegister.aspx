<%@ Page Title="Register" Language="C#" 
    MasterPageFile="~/Site1.Master" 
    AutoEventWireup="true" 
    CodeBehind="CustomerRegister.aspx.cs" 
    Inherits="AgricultureProductRecommendation.CustomerRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Password strength bar */
        #strengthBar {
            height: 5px;
            border-radius: 3px;
            transition: width 0.3s ease, background-color 0.3s ease;
            width: 0%;
        }
        .strength-weak   { width: 33%; background-color: #dc3545; }
        .strength-medium { width: 66%; background-color: #ffc107; }
        .strength-strong { width: 100%; background-color: #198754; }

        /* Toggle eye button sits flush inside the input-group */
        .toggle-pw {
            cursor: pointer;
            background: #fff;
            border: 1px solid #dee2e6;
            border-left: none;
            padding: 0 12px;
            color: #6c757d;
            border-radius: 0 0.375rem 0.375rem 0;
        }
        .toggle-pw:hover { color: #198754; }

        /* Red ring on invalid, green on valid */
        .form-control.is-invalid, .form-select.is-invalid { border-color: #dc3545; }
        .form-control.is-valid,   .form-select.is-valid   { border-color: #198754; }
    </style>
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
                        <small>Register to get personalised recommendations</small>
                    </div>

                    <div class="card-body p-4">

                        <%-- Server-side alerts --%>
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

                        <%-- ── Full Name ── --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Full Name</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-person"></i>
                                </span>
                                <asp:TextBox ID="txtFullName" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter your full name"
                                    onblur="validateFullName()" oninput="validateFullName()" />
                            </div>
                            <%-- ASP.NET server-side validator (fires on postback) --%>
                            <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                                ControlToValidate="txtFullName"
                                ErrorMessage="Full name is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <%-- Client-side message shown by JS --%>
                            <div id="msgFullName" class="small mt-1"></div>
                        </div>

                        <%-- ── Email ── --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-envelope"></i>
                                </span>
                                <asp:TextBox ID="txtEmail" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter your email"
                                    TextMode="Email"
                                    onblur="validateEmail()" oninput="validateEmail()" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="Email is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <div id="msgEmail" class="small mt-1"></div>
                        </div>

                        <%-- ── Phone ── --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Phone Number</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-telephone"></i>
                                </span>
                                <asp:TextBox ID="txtPhone" runat="server"
                                    CssClass="form-control"
                                    placeholder="Enter your phone number"
                                    onblur="validatePhone()" oninput="validatePhone()" />
                            </div>
                            <div id="msgPhone" class="small mt-1"></div>
                        </div>

                        <%-- ── Preferred Category ── --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Preferred Category</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-tag"></i>
                                </span>
                                <asp:DropDownList ID="ddlCategory" runat="server"
                                    CssClass="form-select"
                                    onchange="validateCategory()">
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
                            <div id="msgCategory" class="small mt-1"></div>
                        </div>

                        <%-- ── Password ── --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-lock"></i>
                                </span>
                                <asp:TextBox ID="txtPassword" runat="server"
                                    CssClass="form-control"
                                    placeholder="Create a password"
                                    TextMode="Password"
                                    oninput="validatePassword(); checkStrength(); validateConfirm();"
                                    onblur="validatePassword(); checkStrength();" />
                                <button type="button" class="toggle-pw" onclick="toggleVisibility('txtPassword', 'eyePassword')"
                                    title="Show / hide password" tabindex="-1">
                                    <i id="eyePassword" class="bi bi-eye"></i>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                ControlToValidate="txtPassword"
                                ErrorMessage="Password is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <div id="msgPassword" class="small mt-1"></div>
                            <%-- Strength bar --%>
                            <div class="bg-light rounded mt-2" style="height:5px;">
                                <div id="strengthBar"></div>
                            </div>
                            <div id="strengthLabel" class="small text-muted mt-1"></div>
                        </div>

                        <%-- ── Confirm Password ── --%>
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Confirm Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">
                                    <i class="bi bi-lock-fill"></i>
                                </span>
                                <asp:TextBox ID="txtConfirmPassword" runat="server"
                                    CssClass="form-control"
                                    placeholder="Re-enter your password"
                                    TextMode="Password"
                                    oninput="validateConfirm()"
                                    onblur="validateConfirm()" />
                                <button type="button" class="toggle-pw" onclick="toggleVisibility('txtConfirmPassword', 'eyeConfirm')"
                                    title="Show / hide password" tabindex="-1">
                                    <i id="eyeConfirm" class="bi bi-eye"></i>
                                </button>
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
                            <div id="msgConfirm" class="small mt-1"></div>
                        </div>

                        <%-- ── Submit ── --%>
                        <div class="d-grid mb-3">
                            <asp:Button ID="btnRegister" runat="server"
                                Text="Create Account"
                                CssClass="btn btn-success btn-lg"
                                OnClick="btnRegister_Click"
                                OnClientClick="return validateAll();" />
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

    <script>
        /* ──────────────────────────────────────────
           Helper: get the rendered <input> for an
           ASP.NET server control by its server ID.
        ────────────────────────────────────────── */
        function getEl(serverId) {
            // ASP.NET renders IDs like "ContentPlaceHolder1_txtFullName"
            return document.getElementById('<%= txtFullName.ClientID %>'.replace('txtFullName', serverId));
        }

        function setMsg(msgId, text, isError) {
            var el = document.getElementById(msgId);
            if (!el) return;
            el.textContent = text;
            el.className = 'small mt-1 ' + (isError ? 'text-danger' : 'text-success');
        }

        function markField(input, valid) {
            if (!input) return;
            input.classList.toggle('is-invalid', !valid);
            input.classList.toggle('is-valid',   valid);
        }

        /* ── Show / hide password ── */
        function toggleVisibility(serverId, eyeIconId) {
            var input = getEl(serverId);
            var icon  = document.getElementById(eyeIconId);
            if (!input) return;
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'bi bi-eye';
            }
        }

        /* ── Full Name ── */
        function validateFullName() {
            var input = getEl('txtFullName');
            var val   = input ? input.value.trim() : '';
            var valid = val.length >= 2 && /^[A-Za-z\s'-]+$/.test(val);
            markField(input, valid);
            if (val === '')          setMsg('msgFullName', 'Full name is required.', true);
            else if (!valid)         setMsg('msgFullName', 'Only letters, spaces, hyphens and apostrophes allowed (min 2 chars).', true);
            else                     setMsg('msgFullName', '✓ Looks good!', false);
            return valid;
        }

        /* ── Email ── */
        function validateEmail() {
            var input = getEl('txtEmail');
            var val   = input ? input.value.trim() : '';
            var re    = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;
            var valid = re.test(val);
            markField(input, valid);
            if (val === '')   setMsg('msgEmail', 'Email address is required.', true);
            else if (!valid)  setMsg('msgEmail', 'Enter a valid email — e.g. name@example.com', true);
            else              setMsg('msgEmail', '✓ Valid email.', false);
            return valid;
        }

        /* ── Phone (optional but validated if filled) ── */
        function validatePhone() {
            var input = getEl('txtPhone');
            var val   = input ? input.value.trim() : '';
            if (val === '') {
                markField(input, false);   // neutral — not required
                input.classList.remove('is-invalid', 'is-valid');
                setMsg('msgPhone', '');
                return true;               // phone is optional
            }
            // Accept digits, spaces, +, -, (), 7–15 chars
            var valid = /^[\d\s\+\-\(\)]{7,15}$/.test(val);
            markField(input, valid);
            if (!valid) setMsg('msgPhone', 'Enter a valid phone number (7–15 digits).', true);
            else        setMsg('msgPhone', '✓ Valid number.', false);
            return valid;
        }

        /* ── Category ── */
        function validateCategory() {
            var input = getEl('ddlCategory');
            var valid = input && input.value !== '';
            markField(input, valid);
            if (!valid) setMsg('msgCategory', 'Please select a preferred category.', true);
            else        setMsg('msgCategory', '✓ Category selected.', false);
            return valid;
        }

        /* ── Password ── */
        function validatePassword() {
            var input = getEl('txtPassword');
            var val   = input ? input.value : '';
            var valid = val.length >= 6;
            markField(input, valid);
            if (val === '')  setMsg('msgPassword', 'Password is required.', true);
            else if (!valid) setMsg('msgPassword', 'Password must be at least 6 characters.', true);
            else             setMsg('msgPassword', '✓ Password accepted.', false);
            return valid;
        }

        /* ── Password strength bar ── */
        function checkStrength() {
            var input = getEl('txtPassword');
            var val   = input ? input.value : '';
            var bar   = document.getElementById('strengthBar');
            var label = document.getElementById('strengthLabel');
            if (!bar) return;

            bar.className = '';   // reset

            if (val.length === 0) { bar.style.width = '0'; label.textContent = ''; return; }

            var score = 0;
            if (val.length >= 8)                    score++;
            if (/[A-Z]/.test(val))                  score++;
            if (/[0-9]/.test(val))                  score++;
            if (/[^A-Za-z0-9]/.test(val))           score++;

            if (score <= 1)      { bar.className = 'strength-weak';   label.textContent = 'Weak';   label.className = 'small text-danger mt-1'; }
            else if (score <= 2) { bar.className = 'strength-medium'; label.textContent = 'Medium'; label.className = 'small text-warning mt-1'; }
            else                 { bar.className = 'strength-strong'; label.textContent = 'Strong'; label.className = 'small text-success mt-1'; }
        }

        /* ── Confirm password ── */
        function validateConfirm() {
            var pw      = getEl('txtPassword');
            var confirm = getEl('txtConfirmPassword');
            if (!confirm) return true;
            var val   = confirm.value;
            var valid = val !== '' && val === (pw ? pw.value : '');
            markField(confirm, valid);
            if (val === '')  setMsg('msgConfirm', 'Please confirm your password.', true);
            else if (!valid) setMsg('msgConfirm', 'Passwords do not match.', true);
            else             setMsg('msgConfirm', '✓ Passwords match!', false);
            return valid;
        }

        /* ── Run all checks before postback ── */
        function validateAll() {
            var ok = true;
            ok = validateFullName()  && ok;
            ok = validateEmail()     && ok;
            ok = validatePhone()     && ok;
            ok = validateCategory()  && ok;
            ok = validatePassword()  && ok;
            ok = validateConfirm()   && ok;
            return ok;
        }
    </script>

</asp:Content>
