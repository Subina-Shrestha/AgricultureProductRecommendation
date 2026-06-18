<%@ Page Title="Order Placed" Language="C#"
    MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="OrderSuccess.aspx.cs"
    Inherits="AgricultureProductRecommendation.OrderSuccess" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container text-center py-5">

        <i class="bi bi-check-circle-fill text-success"
           style="font-size: 5rem;"></i>

        <h2 class="text-success fw-bold mt-3">Order Placed Successfully!</h2>

        <p class="text-muted fs-5">
            Your Order ID is
            <strong class="text-success">
                #<asp:Label ID="lblOrderID" runat="server" />
            </strong>
        </p>

        <p class="text-muted">
            We will contact you on your provided phone number for delivery.
        </p>

        <div class="mt-4 d-flex justify-content-center gap-3">
            <a href="HomePage.aspx" class="btn btn-success">
                <i class="bi bi-house me-1"></i>Back to Home
            </a>
            <a href="viewproducts.aspx" class="btn btn-outline-success">
                <i class="bi bi-bag me-1"></i>Continue Shopping
            </a>
        </div>

    </div>
</asp:Content>