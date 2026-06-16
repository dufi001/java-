<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bakery.model.User" %>
<%@ page import="com.bakery.config.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
    // Prevent back-button viewing after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Enforce active customer session authentication
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    User loggedUser = (User) userSession.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wholesale Storefront Marketplace</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .marketplace-grid { display: flex; flex-wrap: wrap; gap: 20px; padding: 40px 5%; max-width: 1200px; margin: 0 auto; }
        .product-card { background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); width: 30%; min-width: 280px; flex-grow: 1; border: 1px solid #eee; }
        .product-card h3 { color: #d35400; margin-bottom: 10px; }
        .product-card input { width: 100%; padding: 8px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; }
        .payment-selection { margin: 10px 0; }
        .payment-selection label { margin-right: 15px; font-weight: 600; }
        
        /* Simulated Phone Overlay Styles */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 2000; justify-content: center; align-items: center; }
        .phone-modal { background: #333; color: white; width: 320px; padding: 30px 20px; border-radius: 30px; border: 4px solid #555; text-align: center; font-family: monospace; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        .phone-modal h3 { background: #f1c40f; color: black; padding: 5px; margin-bottom: 15px; border-radius: 4px; }
        .phone-modal input { width: 90%; padding: 10px; margin: 10px 0; border: none; border-radius: 4px; text-align: center; font-size: 1.1rem; }
        .modal-buttons { display: flex; justify-content: space-around; margin-top: 15px; }
        .modal-btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; width: 45%; }
        .btn-approve { background: #2ecc71; color: white; }
        .btn-cancel { background: #e74c3c; color: white; }
        .status-alert { width: 90%; max-width: 1200px; margin: 20px auto; padding: 15px; border-radius: 5px; text-align: center; font-weight: bold; }
    </style>
</head>
<body>

    <header>
        <nav class="navbar">
            <div class="logo"><h2>Daily Marketplace</h2></div>
            <ul class="nav-links">
                <li><span style="font-weight: bold; color: #d35400;">Welcome, <%= loggedUser.getFullname() %></span></li>
                <li><a href="Logout" style="color: #c0392b; font-weight: bold;">Logout</a></li>
            </ul>
        </nav>
    </header>

    <% if("true".equals(request.getParameter("success"))) { %>
        <div class="status-alert" style="background: #d4edda; color: #155724;">Payment Confirmed! Your order has been registered as PAID. Your batch is processing.</div>
    <% } %>
    <% if("failed".equals(request.getParameter("error"))) { %>
        <div class="status-alert" style="background: #f8d7da; color: #721c24;">Transaction processing error. Please verify inventory levels or parameters.</div>
    <% } %>

    <h2 style="text-align: center; margin-top: 30px;">Available Bakery Inventory Bundles</h2>

    <main class="marketplace-grid">
        <%
            // Pull live wholesale offerings manually inputted by the admin
            String query = "SELECT * FROM products WHERE stock > 0";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {
                
                while(rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
        %>
            <div class="product-card">
                <h3><%= name %></h3>
                <p>Wholesale Unit Price: <strong><%= price %> RWF</strong></p>
                <p>Available Inventory Stock: <span style="color: blue; font-weight:bold;"><%= stock %> units</span></p>
                
                <label for="qty-<%= id %>">Enter Wholesale Quantity:</label>
                <input type="number" id="qty-<%= id %>" min="1" max="<%= stock %>" placeholder="0" 
                       oninput="calculateCardTotal(<%= id %>, <%= price %>)">
                
                <div class="payment-selection">
                    <p style="margin-bottom: 5px; font-weight: bold;">Select Local Gateway:</p>
                    <input type="radio" id="momo-<%= id %>" name="gateway-<%= id %>" value="MTN MoMo" checked>
                    <label for="momo-<%= id %>">MTN MoMo</label>
                    <input type="radio" id="airtel-<%= id %>" name="gateway-<%= id %>" value="Airtel Money">
                    <label for="airtel-<%= id %>">Airtel</label>
                </div>

                <h4>Total Valuation: <span id="total-display-<%= id %>" style="color: #e67e22;">0</span> RWF</h4>
                <br>
                <button type="button" class="btn-submit" onclick="openPaymentPrompt(<%= id %>, '<%= name %>', <%= price %>)">
                    Authorize Pre-Payment Order
                </button>
            </div>
        <% 
                }
            } catch(Exception e) { e.printStackTrace(); } 
        %>
    </main>

    <div id="paymentModal" class="modal-overlay">
        <div class="phone-modal">
            <h3 id="modalGatewayTitle">Local Payment Gateway</h3>
            <p id="modalDescription">Bakery Transaction request</p>
            <p style="margin-top: 10px; font-weight: bold; color: #f1c40f;">Amount: <span id="modalAmount">0</span> RWF</p>
            
            <form id="hiddenOrderForm" action="Order" method="POST">
                <input type="hidden" id="formProductId" name="productId">
                <input type="hidden" id="formQuantity" name="quantity">
                <input type="hidden" id="formTotalAmount" name="totalAmount">
                <input type="hidden" id="formPaymentMethod" name="paymentMethod">
                
                <input type="text" placeholder="Enter Physical Mobile No." required>
                <input type="password" placeholder="Enter Secret Wallet PIN" maxlength="4" required>
                
                <div class="modal-buttons">
                    <button type="button" class="modal-btn btn-cancel" onclick="closePaymentPrompt()">CANCEL</button>
                    <button type="submit" class="modal-btn btn-approve">APPROVE</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // 1. Local Automatic Price Multiplier Logic
        function calculateCardTotal(id, price) {
            let quantityField = document.getElementById('qty-' + id);
            let quantity = parseInt(quantityField.value);
            
            if (isNaN(quantity) || quantity < 0) {
                quantity = 0;
            }
            
            let finalBill = price * quantity;
            document.getElementById('total-display-' + id).innerText = finalBill.toLocaleString();
        }

        // 2. Intercept and Pop-Open Simulated Push Notification Modal
        function openPaymentPrompt(id, productName, price) {
            let qty = parseInt(document.getElementById('qty-' + id).value);
            if(isNaN(qty) || qty <= 0) {
                alert("Please declare a valid wholesale distribution quantity volume.");
                return;
            }

            let computedTotal = price * qty;
            let selectedProvider = document.querySelector('input[name="gateway-' + id + '"]:checked').value;

            // Map data to simulated form variables
            document.getElementById('formProductId').value = id;
            document.getElementById('formQuantity').value = qty;
            document.getElementById('formTotalAmount').value = computedTotal;
            document.getElementById('formPaymentMethod').value = selectedProvider;

            // Update user text inside phone container interface
            document.getElementById('modalGatewayTitle').innerText = selectedProvider + " Push Pay";
            document.getElementById('modalDescription').innerText = "Authorize batch release of " + qty + " units of " + productName;
            document.getElementById('modalAmount').innerText = computedTotal.toLocaleString();

            // Display UI container overlay frame
            document.getElementById('paymentModal').style.display = 'flex';
        }

        function closePaymentPrompt() {
            document.getElementById('paymentModal').style.display = 'none';
        }
    </script>
</body>
</html>