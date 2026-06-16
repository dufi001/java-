<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.bakery.model.User" %>

<!DOCTYPE html>
<html>
<head>
    <title>Bakery Command Center</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Scoped styles specifically for layout integrity */
        .dashboard-container { width: 90%; margin: 30px auto; font-family: 'Segoe UI', sans-serif; }
        .directory-table { width: 100%; border-collapse: collapse; margin: 20px 0; background: #fff; box-shadow: 0 4px 6px rgba(0,0,0,0.02); }
        .directory-table th { background-color: #d35400; color: white; padding: 14px; text-align: left; }
        .directory-table td { padding: 14px; border-bottom: 1px solid #e2e8f0; }
        .btn-update { background-color: #3498db; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-weight: 600; }
        .btn-delete { background-color: #e74c3c; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-weight: 600; margin-left: 8px; }
        .product-grid { display: flex; gap: 20px; margin-top: 20px; }
        .product-card { border: 2px solid #cbd5e1; padding: 20px; border-radius: 8px; cursor: pointer; flex: 1; background: #fff; transition: all 0.2s ease; }
        .product-card:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        #checkout-panel { margin-top: 30px; background: #f8fafc; padding: 25px; border-radius: 8px; border: 1px solid #e2e8f0; }
        .btn-submit { background-color: #d35400; color: white; padding: 12px 24px; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; width: 100%; max-width: 250px; }
    </style>
</head>
<body>

    <header>
        <nav class="navbar">
            <div class="logo"><img src="images/logo.jpg" alt="Logo"></div>
            <div style="display: flex; align-items: center; gap: 20px;">
                <span style="font-weight: bold; color: #2c3e50;">Session Mode: Bakery Administrator</span>
                <a href="LogoutServlet" style="color: #e74c3c; text-decoration: none; font-weight: bold;">Logout</a>
            </div>
        </nav>
    </header>

    <main class="dashboard-container">
        
        <h2>Registered Wholesale Customers Directory</h2>
        <p style="color: #666;">Perform structural account adjustments, details updates, or access revocation updates below.</p>
        
        <table class="directory-table">
            <thead>
                <tr>
                    <th>Customer Unique ID</th>
                    <th>Business Entity/Owner Name</th>
                    <th>Registered Telephone System Link</th>
                    <th>Administrative Actions Available</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Retrieve dynamic buyer data passed down from your controller servlet
                    List<User> customerList = (List<User>) request.getAttribute("activeCustomers");
                    if (customerList != null && !customerList.isEmpty()) {
                        for (User customer : customerList) {
                %>
                        <tr id="user-row-<%= customer.getId() %>">
                            <td>#<%= customer.getId() %></td>
                            <td id="name-field-<%= customer.getId() %>"><%= customer.getFullname() %></td>
                            <td id="phone-field-<%= customer.getId() %>"><%= customer.getPhone() %></td>
                            <td>
                                <button class="btn-update" onclick="openUpdateModal(<%= customer.getId() %>, '<%= customer.getFullname() %>', '<%= customer.getPhone() %>')">Update Data</button>
                                <button class="btn-delete" onclick="executeDeletion(<%= customer.getId() %>)">Delete Account</button>
                            </td>
                        </tr>
                <% 
                        }
                    } else { 
                %>
                    <tr>
                        <td colspan="4" style="text-align:center; padding: 30px; color:#94a3b8; font-weight: bold;">
                            No registered wholesale customers found. Ensure you route through AdminDashboardServlet!
                        </td>
                    </tr>
                <% 
                    } 
                %>
            </tbody>
        </table>

        <hr style="border: 0; height: 1px; background: #e2e8f0; margin: 40px 0;">

        <h2>Wholesale Pastry Dispatch & Payment Control</h2>
        <p style="color: #666;">Select a product line to review real-time stock balances and initialize localized terminal payments.</p>

        <div class="product-grid">
            <%
                // Retrieve stock levels and prices directly mapped out from the persistent schema layers
                Map<String, Integer> stockMap = (Map<String, Integer>) request.getAttribute("productStock");
                Map<String, Double> priceMap = (Map<String, Double>) request.getAttribute("productPrices");
                
                String[] products = {"Chapati", "Breads", "Mandazy"};
                for (String item : products) {
                    int stock = (stockMap != null && stockMap.containsKey(item)) ? stockMap.get(item) : 0;
                    double price = (priceMap != null && priceMap.containsKey(item)) ? priceMap.get(item) : 0.0;
                    
                    // Enforce your pricing updates (Breads hard-coded fallback backup to 300 RWF)
                    if (item.equals("Breads") && (price == 1200.00 || price == 0.0)) {
                        price = 300.00; 
                    }
            %>
                <div class="product-card" id="card-<%= item.toLowerCase() %>" onclick="selectProduct('<%= item %>', <%= price %>, <%= stock %>)">
                    <h3 style="margin-bottom: 10px;"><%= item %></h3>
                    <p style="color: #d35400; font-weight: bold; font-size: 1.3rem; margin-bottom: 5px;"><%= (int)price %> RWF <span style="font-size:0.9rem; color:#777;">/ unit</span></p>
                    <p style="font-size: 0.95rem; color: #555;">Available Stock: <span id="stock-<%= item.toLowerCase() %>" style="font-weight: bold; color: #2c3e50;"><%= stock %></span> units</p>
                </div>
            <% } %>
        </div>

        <div id="checkout-panel" style="display: none;">
            <h3 style="margin-bottom: 15px;">Selected Line: <span id="active-product-name" style="color: #d35400;">None</span></h3>
            
            <div style="margin-bottom: 20px;">
                <label style="display:block; margin-bottom: 8px; font-weight: bold;">Enter Dispatch Quantity:</label>
                <input type="number" id="order-quantity" min="1" value="1" oninput="calculateTerminalTotal()" style="padding: 10px; width: 100%; max-width: 200px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 1rem;">
            </div>

            <div style="margin-bottom: 20px; font-size: 1.3rem; font-weight: bold;">
                Total Processing Cost: <span id="terminal-total-display" style="color: #10b981;">0</span> RWF
            </div>

            <div style="margin-bottom: 25px;">
                <label style="display:block; margin-bottom: 8px; font-weight: bold;">Choose Payment Network Operator:</label>
                <select id="payment-operator" style="padding: 12px; border-radius: 4px; border: 1px solid #cbd5e1; font-weight: bold; background: #fff; width: 100%; max-width: 400px; font-size: 0.95rem;">
                    <option value="MTN">MTN Mobile Money (*182*1*1*0793197955#)</option>
                    <option value="Airtel">Airtel Money (*182*1*1*0726275105#)</option>
                </select>
            </div>

            <button class="btn-submit" onclick="triggerMobileMoneyModal()">Proceed to Payment</button>
        </div>
    </main>

    <script>
        let currentProduct = "";
        let currentPrice = 0;
        let maxStock = 0;

        // Inventory Item Select State Handling Matrix
        function selectProduct(productName, price, stock) {
            document.querySelectorAll('.product-card').forEach(card => card.style.borderColor = '#cbd5e1');
            document.getElementById('card-' + productName.toLowerCase()).style.borderColor = '#d35400';
            
            currentProduct = productName;
            currentPrice = price;
            maxStock = stock;
            
            document.getElementById('checkout-panel').style.display = 'block';
            document.getElementById('active-product-name').innerText = productName;
            document.getElementById('order-quantity').value = 1;
            document.getElementById('order-quantity').max = stock;
            
            calculateTerminalTotal();
        }

        // Live Dynamic Multiplier Math
        function calculateTerminalTotal() {
            let quantityInput = document.getElementById('order-quantity');
            let qty = parseInt(quantityInput.value);
            
            if (qty > maxStock) {
                alert("Requested quantity exceeds raw stock counts remaining in storage!");
                quantityInput.value = maxStock;
                qty = maxStock;
            }
            if (isNaN(qty) || qty < 1) qty = 0;
            
            let totalCost = qty * currentPrice;
            document.getElementById('terminal-total-display').innerText = totalCost.toLocaleString();
        }

        // Generate Simulated Phone Layout Overlay with target USSD string configuration
        function triggerMobileMoneyModal() {
            let qty = parseInt(document.getElementById('order-quantity').value);
            let totalCost = qty * currentPrice;
            let operator = document.getElementById('payment-operator').value;
            
            if (qty <= 0 || isNaN(qty)) { alert("Please enter a valid amount."); return; }

            // Assign exact local merchant strings given your network routes
            let ussdCode = (operator === "MTN") ? "*182*1*1*0793197955#" : "*182*1*1*0726275105#";

            const modal = document.createElement("div");
            modal.className = "modal-overlay";
            modal.id = "paymentModal";
            modal.style = "position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); display: flex; justify-content: center; align-items: center; z-index: 5000;";
            modal.innerHTML = `
                <div class="phone-container" style="width: 320px; background: #111; border: 8px solid #222; border-radius: 36px; padding: 25px; color: white; text-align: center; font-family: sans-serif;">
                    <div style="width: 60px; height: 4px; background: #333; margin: 0 auto 15px; border-radius: 2px;"></div>
                    <h3>${operator} Terminal</h3>
                    <p style="color: #aaa; font-size: 0.85rem; margin-bottom: 5px;">Localized Push Routing String:</p>
                    <code style="background: #222; padding: 6px 12px; border-radius: 4px; color: #f1c40f; font-weight: bold; font-size: 1.1rem; display: inline-block; margin-bottom: 10px;">${ussdCode}</code>
                    
                    <p style="font-size: 1.5rem; color: #10b981; font-weight: bold; margin: 10px 0;">${totalCost.toLocaleString()} RWF</p>
                    
                    <div style="margin-top: 15px;">
                        <label style="font-size: 0.85rem; color: #ccc; display: block; margin-bottom: 5px;">ENTER MOBILE WALLET PIN:</label>
                        <input type="password" maxlength="5" id="walletPin" placeholder="*****" 
                               style="width: 80%; padding: 12px; text-align: center; font-size: 1.5rem; letter-spacing: 6px; border-radius: 6px; border: none; margin-bottom: 15px;">
                        <button onclick="executeUSSDDialTransaction('${ussdCode}', '${currentProduct}', ${qty})" 
                                style="width: 100%; background: #d35400; color: white; padding: 12px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; text-transform: uppercase;">
                            Confirm & Execute Dial
                        </button>
                    </div>
                </div>
            `;
            document.body.appendChild(modal);
        }

        // Deducts stock counts silently from database and passes command directly to device dialer
        function executeUSSDDialTransaction(ussdCode, product, qty) {
            const pin = document.getElementById("walletPin").value;
            if (pin.length < 4) { alert("Invalid pin verification credentials."); return; }

            fetch("OrderServlet", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: `productName=${product}&quantity=${qty}`
            })
            .then(res => res.text())
            .then(status => {
                if (status === "payment_verified") {
                    document.getElementById("paymentModal").remove();
                    
                    // Hardware link conversion hook formatting char '#' to clear browser navigation rules cleanly
                    let encodedUssd = ussdCode.replace("#", "%23");
                    window.location.href = "tel:" + encodedUssd;

                    alert("🎉 Database stock updated! Triggering device phone dialer loop.");
                    window.location.reload(); 
                } else {
                    alert("Execution rejected: Storage repository reported stock constraints.");
                }
            });
        }

        // Asynchronous Admin Account Management Deletion Call
        function executeDeletion(userId) {
            if (!confirm("Revoke all administrative clearing rights for account user #" + userId + "?")) return;

            fetch("AdminCrudServlet?id=" + userId, { method: "DELETE" })
            .then(res => res.text())
            .then(data => {
                if (data === "delete_success") {
                    document.getElementById("user-row-" + userId).remove();
                } else {
                    alert("Action Denied: Protected administrative identity.");
                }
            });
        }
    </script>
</body>
</html>