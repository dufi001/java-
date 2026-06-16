<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Bakery - Pastry Matcher</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Game Specific Layout Styles */
        .game-wrapper {
            max-width: 600px;
            width: 90%;
            margin: 40px auto;
            text-align: center;
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
        }

        .game-wrapper h2 {
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .game-wrapper p {
            color: #64748b;
            margin-bottom: 20px;
            font-size: 0.95rem;
        }

        .game-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            max-width: 400px;
            margin: 0 auto;
        }

        .card-tile {
            height: 85px;
            background-color: #d35400; /* Matching your orange theme */
            border-radius: 8px;
            cursor: pointer;
            font-size: 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: transparent;
            user-select: none;
            transition: background-color 0.2s ease, transform 0.1s ease;
        }

        .card-tile:active {
            transform: scale(0.95);
        }

        .card-tile.flipped {
            background-color: #f1f5f9;
            color: #333;
            border: 2px solid #e2e8f0;
            cursor: default;
        }

        .card-tile.matched {
            background-color: #10b981; /* Green for matches */
            color: white;
            cursor: default;
            animation: pulse 0.3s ease;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.08); }
            100% { transform: scale(1); }
        }

        .reset-btn {
            margin-top: 25px;
            padding: 10px 24px;
            background-color: #2c3e50;
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
        }

        .reset-btn:hover {
            background-color: #1e293b;
        }
    </style>
</head>
<body>

    <header>
        <nav class="navbar">
            <div class="logo">
                <img src="images/logo.jpg" alt="Daily Bakery Logo">
            </div>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="login.jsp">Login/SignUp</a></li>
                <li><a href="freegame.jsp" style="color: #d35400;">Freegame</a></li>
                <li><a href="#">About Us</a></li>
            </ul>
        </nav>
    </header>

    <main style="flex: 1;">
        <div class="game-wrapper">
            <h2>Pastry Matcher Memory Game</h2>
            <p>Match the identical bakery pairs to test your focus metrics!</p>
            
            <div class="game-grid" id="gridContainer">
                </div>

            <button class="reset-btn" onclick="initializeGame()">Restart Game</button>
        </div>
    </main>

    <footer>
        <p>© 2026 Daily Bakery Wholesale Solutions. All Rights Reserved.</p>
    </footer>

    <script>
        // Bakery item emojis
        const items = ['🥐', '🍞', '🥖', '🥨', '🥞', '🍩', '🎂', '🧁'];
        let gameCards = [...items, ...items]; // Create duplicate pairs
        let flippedCards = [];
        let matchedPairsCount = 0;
        let lockBoard = false;

        function shuffle(array) {
            return array.sort(() => Math.random() - 0.5);
        }

        function initializeGame() {
            const grid = document.getElementById("gridContainer");
            grid.innerHTML = ""; // Clear existing grid space
            flippedCards = [];
            matchedPairsCount = 0;
            lockBoard = false;
            
            shuffle(gameCards);

            gameCards.forEach((item, index) => {
                const card = document.createElement("div");
                card.classList.add("card-tile");
                card.dataset.value = item;
                card.dataset.id = index;
                card.innerText = item;
                card.addEventListener("click", flipCard);
                grid.appendChild(card);
            });
        }

        function flipCard() {
            if (lockBoard) return;
            if (this.classList.contains("flipped") || this.classList.contains("matched")) return;

            this.classList.add("flipped");
            flippedCards.push(this);

            if (flippedCards.length === 2) {
                checkMatch();
            }
        }

        function checkMatch() {
            lockBoard = true;
            let card1 = flippedCards[0];
            let card2 = flippedCards[1];

            if (card1.dataset.value === card2.dataset.value && card1.dataset.id !== card2.dataset.id) {
                // Found a match
                card1.classList.add("matched");
                card2.classList.add("matched");
                matchedPairsCount++;
                flippedCards = [];
                lockBoard = false;

                if (matchedPairsCount === items.length) {
                    setTimeout(() => {
                        alert("🎉 Incredible! You matched all the pastries perfectly!");
                    }, 300);
                }
            } else {
                // Not a match, flip them back over face-down
                setTimeout(() => {
                    card1.classList.remove("flipped");
                    card2.classList.remove("flipped");
                    flippedCards = [];
                    lockBoard = false;
                }, 800);
            }
        }

        // Initialize grid on document launch execution
        document.addEventListener("DOMContentLoaded", initializeGame);
    </script>
</body>
</html>