<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wholesale Registration</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <header>
        <nav class="navbar">
            <div class="logo">
                <img src="images/logo.jpg" alt="Daily Bakery Logo">
            </div>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="signup.jsp">SignUp</a></li>
                <li><a href="#">Freegame</a></li>
                <li><a href="#">About Us</a></li>
            </ul>
        </nav>
    </header>

    <main class="form-container">
        <h2>Wholesale Registration</h2>
        <p>Create your local business profile</p>
        
        <form action="Register" method="POST">
            <div class="form-group">
                <label for="fullname">Full Business/Owner Name:</label>
                <input type="text" id="fullname" name="fullname" placeholder="Enter your full business name" required>
            </div>
            
            <div class="form-group">
                <label for="phone">Telephone Number:</label>
                <input type="text" id="phone" name="phone" placeholder="e.g. 0726275105" onkeyup="verifyUniquePhone()" required>
                <span id="phoneStatus" style="font-size: 0.85rem; font-weight: bold; display: block; margin-top: 5px;"></span>
            </div>
            
            <div class="form-group">
                <label for="password">Create Password:</label>
                <input type="password" id="password" name="password" placeholder="Create a secure password" required>
            </div>
            
            <button type="submit" id="submitBtn" class="btn-submit">Complete Registration</button>
        </form>
        
        <p class="switch-page-text">Already registered? <a href="login.jsp">Login Here</a></p>
    </main>

    <footer>
        <p>© 2026 Daily Bakery Wholesale Solutions. All Rights Reserved.</p>
    </footer>

    <script>
        function verifyUniquePhone() {
            var phoneValue = document.getElementById("phone").value;
            var statusLabel = document.getElementById("phoneStatus");
            var submitButton = document.getElementById("submitBtn");

            // If input is too short, reset state parameters
            if (phoneValue.length < 3) {
                statusLabel.innerText = "";
                submitButton.disabled = false;
                return;
            }

            // Initiate a background AJAX request to our check servlet
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "CheckPhoneServlet?phone=" + encodeURIComponent(phoneValue), true);
            
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    var serverResponse = xhr.responseText.trim();
                    
                    if (serverResponse === "exists") {
                        // 1. Target number is already taken! Show warning message and block submission
                        statusLabel.style.color = "#dc2626"; // Alert Red
                        statusLabel.innerText = "❌ This phone number already exists! Please use a different number.";
                        submitButton.disabled = true;
                        submitButton.style.backgroundColor = "#94a3b8"; // Grays out button
                        submitButton.style.cursor = "not-allowed";
                    } else {
                        // 2. Number is unique and completely available
                        statusLabel.style.color = "#10b981"; // Fresh Green
                        statusLabel.innerText = "✓ Telephone number is available.";
                        submitButton.disabled = false;
                        submitButton.style.backgroundColor = "#d35400"; // Restores original orange theme
                        submitButton.style.cursor = "pointer";
                    }
                }
            };
            xhr.send();
        }
    </script>

</body>
</html>