<%@ Page Title="Admin Dashboard" Language="C#"
    MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="AdminDashboard.aspx.cs"
    Inherits="AgricultureProductRecommendation.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Page Banner -->
    <div class="text-white py-3 mb-4" style="background-color: #1a237e;">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="fw-bold mb-0">
                        <i class="bi bi-shield-check me-2"></i>Admin Dashboard
                    </h2>
                    <small>Welcome,
                        <asp:Label ID="lblAdminName" runat="server"
                            Text="" CssClass="fw-bold" />
                    </small>
                </div>
                <asp:Button ID="btnLogout" runat="server"
                    Text="Logout"
                    CssClass="btn btn-outline-light"
                    OnClick="btnLogout_Click"
                    CausesValidation="false" />
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Stats Row -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-3 text-center p-3"
                    style="border-left: 4px solid #1a237e !important;">
                    <i class="bi bi-people fs-2 text-primary"></i>
                    <h3 class="fw-bold mt-2">
                        <asp:Label ID="lblFarmerCount" runat="server" Text="0" />
                    </h3>
                    <p class="text-muted mb-0">Total Farmers</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-3 text-center p-3"
                    style="border-left: 4px solid #2e7d32 !important;">
                    <i class="bi bi-person-heart fs-2 text-success"></i>
                    <h3 class="fw-bold mt-2">
                        <asp:Label ID="lblCustomerCount" runat="server" Text="0" />
                    </h3>
                    <p class="text-muted mb-0">Total Customers</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-3 text-center p-3"
                    style="border-left: 4px solid #f57f17 !important;">
                    <i class="bi bi-basket fs-2 text-warning"></i>
                    <h3 class="fw-bold mt-2">
                        <asp:Label ID="lblProductCount" runat="server" Text="0" />
                    </h3>
                    <p class="text-muted mb-0">Total Products</p>
                </div>
            </div>
        </div>

        <!-- Tabs -->
        <ul class="nav nav-tabs mb-3" id="adminTabs">
            <li class="nav-item">
                <a class="nav-link active" data-bs-toggle="tab" href="#tabFarmers">
                    <i class="bi bi-people me-1"></i>Farmers
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-bs-toggle="tab" href="#tabCustomers">
                    <i class="bi bi-person-heart me-1"></i>Customers
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-bs-toggle="tab" href="#tabProducts">
                    <i class="bi bi-basket me-1"></i>Products
                </a>
            </li>
        </ul>

        <div class="tab-content">

            <!-- ── Farmers Tab ── -->
            <div class="tab-pane fade show active" id="tabFarmers">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body p-0">
                        <div class="card-header text-white py-3 d-flex justify-content-between align-items-center"
                            style="background-color: #1a237e;">
                            <h5 class="mb-0 fw-bold">
                                <i class="bi bi-people me-2"></i>All Farmers
    </h5>
                            <asp:Button ID="btnToggleAddFarmer" runat="server"
                                Text="+ Add Farmer"
                                CssClass="btn btn-sm btn-light"
                                OnClientClick="document.getElementById('addFarmerPanel').classList.toggle('d-none'); return false;" />
                        </div>



                        <!-- Add Farmer Form (hidden by default) -->
                        <div id="addFarmerPanel" class="card-body border-bottom d-none">
                            <div class="row g-2">
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtFarmerName" runat="server" CssClass="form-control" placeholder="Full Name" />
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtFarmerEmail" runat="server" CssClass="form-control" placeholder="Email" />
                                </div>
                                <div class="col-md-2">
                                    <asp:TextBox ID="txtFarmerPhone" runat="server" CssClass="form-control" placeholder="Phone" />
                                </div>
                                <div class="col-md-2">
                                    <asp:TextBox ID="txtFarmerPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password" />
                                </div>
                                <div class="col-md-2">
                                    <asp:Button ID="btnAddFarmer" runat="server"
                                        Text="Save"
                                        CssClass="btn btn-success w-100"
                                        OnClick="btnAddFarmer_Click" />
                                </div>
                            </div>
                            <asp:Label ID="lblAddFarmerMsg" runat="server" CssClass="d-block mt-2" />
                        </div>
                        <asp:GridView ID="gvFarmers" runat="server"
                            CssClass="table table-hover table-striped mb-0"
                            AutoGenerateColumns="false"
                            DataKeyNames="FarmerID"
                            OnRowDeleting="gvFarmers_RowDeleting">
                            <HeaderStyle CssClass="table-primary" />
                            <Columns>
                                <asp:BoundField DataField="FarmerID" HeaderText="ID" />
                                <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                                <asp:BoundField DataField="Email" HeaderText="Email" />
                                <asp:BoundField DataField="Phone" HeaderText="Phone" />
                                <asp:BoundField DataField="DateJoined" HeaderText="Date Joined"
                                    DataFormatString="{0:dd MMM yyyy}" />
                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkDeleteFarmer" runat="server"
                                            CommandName="Delete"
                                            CssClass="btn btn-sm btn-outline-danger"
                                            OnClientClick="return confirm('Are you sure you want to delete this farmer?');">
                                                <i class="bi bi-trash"></i> Delete
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        

        <!-- ── Customers Tab ── -->
        <div class="tab-pane fade" id="tabCustomers">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header text-white py-3"
                    style="background-color: #2e7d32;">
                    <h5 class="mb-0 fw-bold">
                        <i class="bi bi-person-heart me-2"></i>All Customers
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <asp:GridView ID="gvCustomers" runat="server"
                            CssClass="table table-hover table-striped mb-0"
                            AutoGenerateColumns="false"
                            DataKeyNames="CustomerID"
                            OnRowDeleting="gvCustomers_RowDeleting">
                            <HeaderStyle CssClass="table-success" />
                            <Columns>
                                <asp:BoundField DataField="CustomerID" HeaderText="ID" />
                                <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                                <asp:BoundField DataField="Email" HeaderText="Email" />
                                <asp:BoundField DataField="Phone" HeaderText="Phone" />
                                <asp:BoundField DataField="PreferredCategory" HeaderText="Preference" />
                                <asp:BoundField DataField="DateJoined" HeaderText="Date Joined"
                                    DataFormatString="{0:dd MMM yyyy}" />
                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkDeleteCustomer" runat="server"
                                            CommandName="Delete"
                                            CssClass="btn btn-sm btn-outline-danger"
                                            OnClientClick="return confirm('Are you sure you want to delete this customer?');">
                                                <i class="bi bi-trash"></i> Delete
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── Products Tab ── -->
        <div class="tab-pane fade" id="tabProducts">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header text-white py-3"
                    style="background-color: #f57f17;">
                    <h5 class="mb-0 fw-bold">
                        <i class="bi bi-basket me-2"></i>All Products
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <asp:GridView ID="gvProducts" runat="server"
                            CssClass="table table-hover table-striped mb-0"
                            AutoGenerateColumns="false"
                            DataKeyNames="ProductID">
                            <HeaderStyle CssClass="table-warning" />
                            <Columns>
                                <asp:BoundField DataField="ProductID" HeaderText="ID" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product" />
                                <asp:BoundField DataField="Category" HeaderText="Category" />
                                <asp:BoundField DataField="Price" HeaderText="Price"
                                    DataFormatString="Rs. {0}" />
                                <asp:BoundField DataField="PriceUnit" HeaderText="Unit" />
                                <asp:BoundField DataField="Rating" HeaderText="Rating" />
                                <asp:TemplateField HeaderText="Top Product">
                                    <ItemTemplate>
                                        <%# Convert.ToBoolean(Eval("IsTopProduct")) ?
                                                "<span class='badge bg-success'>Yes</span>" :
                                                "<span class='badge bg-secondary'>No</span>" %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
        </div>

    </div>
    <div class="mb-5"></div>
    

</asp:Content>
