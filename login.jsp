<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Storefront Secure Login</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <header>
        <nav class="navbar">
            <div class="logo">
                <img src="images/logo.jpg" alt="Daily Bakery Logo" style="height: 50px; border-radius: 4px;">
            </div>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="signup.jsp">Register</a></li>
                <li><a href="#">Freegame</a></li>
                <li><a href="#">About Us</a></li>
            </ul>
        </nav>
    </header>

    <main class="form-container">
        <h2>Wholesale Secure Login</h2>
        <br>
        
        <% 
            String error = (String) request.getAttribute("errorMessage"); 
            if(error != null) { 
        %>
            <div class="error-msg"><%= error %></div>
        <% } %>

        <form action="Login" method="POST">
            <div class="form-group">
                <label for="phone">Registered Telephone Number:</label>
                <input type="text" id="phone" name="phone" placeholder="Enter telephone number" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
            </div>
            <button type="submit" class="btn-submit">Enter System</button>
        </form>
        <br>
        <p style="text-align: center;">New bulk retailer? <a href="signup.jsp" style="color: #d35400; font-weight: bold;">Register Here</a></p>
    </main>

    <footer>
        <p>© 2026 Daily Bakery Wholesale Solutions. All Rights Reserved.</p>
    </footer>

</body>
</html>