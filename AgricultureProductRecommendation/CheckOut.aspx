<%@ Page Title="Checkout" Language="C#"
    MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="Checkout.aspx.cs"
    Inherits="AgricultureProductRecommendation.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <style>
        #deliveryMap {
            height: 300px;
            width: 100%;
            border-radius: 8px;
            border: 2px solid #198754;
            z-index: 0;
        }

        .map-coords-badge {
            font-size: 0.75rem;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 4px 10px;
            color: #555;
        }

        #addressSuggestions {
            position: absolute;
            z-index: 9999;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            width: 100%;
            max-height: 200px;
            overflow-y: auto;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

            #addressSuggestions .suggestion-item {
                padding: 8px 12px;
                cursor: pointer;
                font-size: 0.875rem;
                border-bottom: 1px solid #f0f0f0;
            }

                #addressSuggestions .suggestion-item:hover {
                    background-color: #e9f5ee;
                    color: #198754;
                }

        .address-wrapper {
            position: relative;
        }

        #geocodeSpinner {
            position: absolute;
            right: 10px;
            top: 10px;
            display: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="bg-success bg-opacity-10 border-bottom border-success py-3 mb-4">
        <div class="container">
            <h2 class="text-success fw-bold mb-0">Checkout</h2>
            <small class="text-muted">Complete your order</small>
        </div>
    </div>

    <div class="container">
        <div class="row g-4">

            <!-- Left — Delivery Details -->
            <div class="col-md-7">
                <div class="card shadow border-0 rounded-3">
                    <div class="card-header bg-success text-white py-3">
                        <h5 class="mb-0 fw-bold">
                            <i class="bi bi-truck me-2"></i>Delivery Details
                        </h5>
                    </div>
                    <div class="card-body p-4">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Full Name</label>
                            <asp:TextBox ID="txtFullName" runat="server"
                                CssClass="form-control"
                                placeholder="Your full name" />
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtFullName"
                                ErrorMessage="Full name is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Phone Number</label>
                            <asp:TextBox ID="txtPhone" runat="server"
                                CssClass="form-control"
                                placeholder="Your phone number" />
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtPhone"
                                ErrorMessage="Phone is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtPhone"
                                ValidationExpression="^[0-9]{10}$"
                                ErrorMessage="Phone must be exactly 10 digits (numbers only)"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>

                        <%-- Delivery Address with autocomplete suggestions --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Delivery Address</label>
                            <div class="address-wrapper">
                                <asp:TextBox ID="txtAddress" runat="server"
                                    CssClass="form-control"
                                    placeholder="Type your delivery address..."
                                    TextMode="MultiLine"
                                    Rows="3"
                                    ClientIDMode="Static" />
                                <div class="spinner-border spinner-border-sm text-success"
                                    id="geocodeSpinner" role="status">
                                    <span class="visually-hidden">Searching...</span>
                                </div>
                                <div id="addressSuggestions"></div>
                            </div>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtAddress"
                                ErrorMessage="Address is required"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <small class="text-muted">Type to search, or pin directly on the map below.
                            </small>
                        </div>

                        <%-- Map Section --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                <i class="bi bi-geo-alt-fill text-success me-1"></i>
                                Pin Delivery Location
                            </label>
                            <p class="text-muted small mb-2">
                                Click on the map to pin your delivery location — the address will fill automatically.
                            </p>
                            <div id="deliveryMap"></div>
                            <div class="mt-2 d-flex align-items-center gap-2 flex-wrap">
                                <span class="map-coords-badge" id="coordsDisplay">No location selected
                                </span>
                                <button type="button" class="btn btn-outline-secondary btn-sm"
                                    onclick="useMyLocation()">
                                    <i class="bi bi-crosshair me-1"></i>Use My Location
                                </button>
                            </div>
                            <asp:HiddenField ID="hdnLatitude" runat="server" Value="" />
                            <asp:HiddenField ID="hdnLongitude" runat="server" Value="" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Payment Method</label>
                            <asp:DropDownList ID="ddlPayment" runat="server"
                                CssClass="form-select">
                                <asp:ListItem Value="COD">Cash on Delivery</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                    </div>
                </div>
            </div>

            <!-- Right — Order Summary -->
            <div class="col-md-5">
                <div class="card shadow border-0 rounded-3">
                    <div class="card-header bg-success text-white py-3">
                        <h5 class="mb-0 fw-bold">
                            <i class="bi bi-receipt me-2"></i>Order Summary
                        </h5>
                    </div>
                    <div class="card-body p-0">

                        <asp:Repeater ID="rptOrderSummary" runat="server">
                            <ItemTemplate>
                                <div class="d-flex justify-content-between
                                            align-items-center px-3 py-2 border-bottom">
                                    <div>
                                        <strong class="text-success">
                                            <%# Eval("ProductName") %>
                                        </strong>
                                        <br />
                                        <small class="text-muted">Rs. <%# Eval("Price") %>
                                            x <%# Eval("Quantity") %>
                                        </small>
                                    </div>
                                    <span class="fw-bold text-success">Rs. <%# String.Format("{0:0.00}",
                                              Convert.ToDecimal(Eval("Price")) *
                                              Convert.ToInt32(Eval("Quantity"))) %>
                                    </span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <div class="d-flex justify-content-between px-3 py-3 bg-light">
                            <h5 class="fw-bold mb-0">Total</h5>
                            <h5 class="fw-bold text-success mb-0">Rs.
                                <asp:Label ID="lblTotal" runat="server" Text="0" />
                            </h5>
                        </div>

                    </div>
                </div>

                <div class="d-grid mt-3">
                    <asp:Button ID="btnPlaceOrder" runat="server"
                        Text=" Place Order"
                        CssClass="btn btn-success btn-lg"
                        OnClick="btnPlaceOrder_Click" />
                </div>

                <div class="text-center mt-2">
                    <a href="javascript:history.back()" class="text-muted small">
                        <i class="bi bi-arrow-left me-1"></i>Go Back
                    </a>
                </div>
            </div>

        </div>
        <div class="mb-5"></div>
    </div>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        // ── Map setup ──────────────────────────────────────────────────
        var map = L.map('deliveryMap').setView([27.7172, 85.3240], 13);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            maxZoom: 19
        }).addTo(map);

        var marker = null;
        var typingTimer = null;         // debounce timer for address input
        var isSyncingFromMap = false;   // flag: stop address→map loop

        var greenIcon = L.icon({
            iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-green.png',
            shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-shadow.png',
            iconSize: [25, 41], iconAnchor: [12, 41],
            popupAnchor: [1, -34], shadowSize: [41, 41]
        });

        // ── Place / move marker ────────────────────────────────────────
        function placeMarker(lat, lng) {
            if (marker) {
                marker.setLatLng([lat, lng]);
            } else {
                marker = L.marker([lat, lng], { icon: greenIcon, draggable: true }).addTo(map);
                marker.on('dragend', function (e) {
                    var pos = e.target.getLatLng();
                    saveCoords(pos.lat, pos.lng);
                    reverseGeocode(pos.lat, pos.lng);   // drag → update address
                });
            }
            saveCoords(lat, lng);
            marker.bindPopup('<b>Delivery here</b>').openPopup();
        }

        function saveCoords(lat, lng) {
            var latF = lat.toFixed(6), lngF = lng.toFixed(6);
            document.getElementById('<%= hdnLatitude.ClientID %>').value = latF;
            document.getElementById('<%= hdnLongitude.ClientID %>').value = lngF;
            document.getElementById('coordsDisplay').innerHTML =
                '<i class="bi bi-geo-alt-fill text-success me-1"></i>' +
                'Lat: ' + latF + ', Lng: ' + lngF;
        }


        // ── Live cursor coordinates ────────────────────────────────────
        map.on('mousemove', function (e) {
            document.getElementById('coordsDisplay').innerHTML =
                '<i class="bi bi-geo-alt text-secondary me-1"></i>' +
                'Lat: ' + e.latlng.lat.toFixed(6) +
                ', Lng: ' + e.latlng.lng.toFixed(6);
        });

        // When mouse leaves map, restore saved pin coords (or default text)
        map.on('mouseout', function () {
            var savedLat = document.getElementById('<%= hdnLatitude.ClientID %>').value;
            var savedLng = document.getElementById('<%= hdnLongitude.ClientID %>').value;
            if (savedLat && savedLng) {
                document.getElementById('coordsDisplay').innerHTML =
                    '<i class="bi bi-geo-alt-fill text-success me-1"></i>' +
                    'Lat: ' + savedLat + ', Lng: ' + savedLng;
            } else {
                document.getElementById('coordsDisplay').innerHTML = 'No location selected';
            }
        });
        // ── Map click → reverse geocode → fill address box ────────────
        map.on('click', function (e) {
            placeMarker(e.latlng.lat, e.latlng.lng);
            reverseGeocode(e.latlng.lat, e.latlng.lng);
        });

        // Nominatim reverse geocode: coords → human address
        function reverseGeocode(lat, lng) {
            var spinner = document.getElementById('geocodeSpinner');
            spinner.style.display = 'block';

            var url = 'https://nominatim.openstreetmap.org/reverse' +
                '?format=json&lat=' + lat + '&lon=' + lng +
                '&addressdetails=1';

            fetch(url, { headers: { 'Accept-Language': 'en' } })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    spinner.style.display = 'none';
                    if (data && data.display_name) {
                        isSyncingFromMap = true;
                        document.getElementById('txtAddress').value = data.display_name;
                        isSyncingFromMap = false;
                        hideSuggestions();
                    }
                })
                .catch(function () { spinner.style.display = 'none'; });
        }

        // ── Address typing → forward geocode → move map ───────────────
        var addrBox = document.getElementById('txtAddress');

        addrBox.addEventListener('input', function () {
            if (isSyncingFromMap) return;   // ignore changes we made ourselves
            clearTimeout(typingTimer);
            var query = addrBox.value.trim();
            if (query.length < 3) { hideSuggestions(); return; }

            // Wait 600 ms after the user stops typing before calling API
            typingTimer = setTimeout(function () { forwardGeocode(query); }, 600);
        });

        // Nominatim forward geocode: address text → suggestions list
        function forwardGeocode(query) {
            var spinner = document.getElementById('geocodeSpinner');
            spinner.style.display = 'block';

            var url = 'https://nominatim.openstreetmap.org/search' +
                '?format=json&q=' + encodeURIComponent(query) +
                '&addressdetails=1&limit=5&countrycodes=np';

            fetch(url, { headers: { 'Accept-Language': 'en' } })
                .then(function (r) { return r.json(); })
                .then(function (results) {
                    spinner.style.display = 'none';
                    showSuggestions(results);
                })
                .catch(function () { spinner.style.display = 'none'; });
        }

        // Show dropdown suggestions
        function showSuggestions(results) {
            var box = document.getElementById('addressSuggestions');
            box.innerHTML = '';
            if (!results || results.length === 0) { box.style.display = 'none'; return; }

            results.forEach(function (r) {
                var item = document.createElement('div');
                item.className = 'suggestion-item';
                item.textContent = r.display_name;
                item.addEventListener('click', function () {
                    isSyncingFromMap = true;
                    addrBox.value = r.display_name;
                    isSyncingFromMap = false;
                    hideSuggestions();

                    var lat = parseFloat(r.lat);
                    var lng = parseFloat(r.lon);
                    map.setView([lat, lng], 16);
                    placeMarker(lat, lng);
                });
                box.appendChild(item);
            });
            box.style.display = 'block';
        }

        function hideSuggestions() {
            var box = document.getElementById('addressSuggestions');
            box.innerHTML = '';
            box.style.display = 'none';
        }

        // Close suggestions when clicking outside
        document.addEventListener('click', function (e) {
            if (!e.target.closest('.address-wrapper')) hideSuggestions();
        });

        // ── Use My Location ───────────────────────────────────────────
        function useMyLocation() {
            if (!navigator.geolocation) {
                alert('Geolocation is not supported by your browser.');
                return;
            }
            navigator.geolocation.getCurrentPosition(function (pos) {
                var lat = pos.coords.latitude;
                var lng = pos.coords.longitude;
                map.setView([lat, lng], 16);
                placeMarker(lat, lng);
                reverseGeocode(lat, lng);
            }, function () {
                alert('Could not get your location. Please pin manually on the map.');
            });
        }
    </script>

</asp:Content>
