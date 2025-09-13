<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        /* Loading animation styles */
        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            z-index: 1000;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid #4CAF50;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-bottom: 15px;
        }

        .loading-text {
            font-size: 18px;
            color: #333;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Disable form during loading */
        .form-disabled {
            opacity: 0.6;
            pointer-events: none;
        }

        /* Error message styling */
        .error-message {
            color: #d9534f;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 5px;
            margin-top: 15px;
            display: none;
        }
    </style>
</head>
<body>
<nav>
    <ul>
        <c:forEach var="section" items="${sections}">
            <li><a href="#${section}">${section}</a></li>
        </c:forEach>
    </ul>
</nav>

<main>
    <section id="home">
        <div class="grammar-container">
            <h1>Grammar Correction Tool</h1>
            <p>Enter your text below and get instant grammar corrections powered by Google's Gemini AI.</p>
        </div>
    </section>

    <section id="grammar">
        <div class="grammar-container">
            <h2 class="section-title">Grammar Correction</h2>

            <div class="input-section">
                <h3>Enter your text:</h3>
                <form id="grammarForm" method="post">
                    <textarea name="userInput" id="userInput" placeholder="Type or paste your text here..." required>${userInput != null ? userInput : ''}</textarea>
                    <button type="submit" id="submitButton">Correct Grammar</button>
                </form>
                <div id="errorMessage" class="error-message"></div>
            </div>

            <div id="outputContainer">
                <c:if test="${not empty correctedText}">
                    <div class="output-section">
                        <h3>Corrected text:</h3>
                        <div class="output-text">${correctedText}</div>
                    </div>
                </c:if>
            </div>
        </div>
    </section>
</main>

<footer>
    <p>&copy; ${currentYear} Grammar Correction Tool. All rights reserved.</p>
</footer>

<!-- Loading Overlay -->
<div class="loading-overlay" id="loadingOverlay">
    <div class="loading-spinner"></div>
    <div class="loading-text">Processing your request...</div>
</div>

<script>
    // Function to show loading animation
    function showLoading() {
        document.getElementById('loadingOverlay').style.display = 'flex';
        document.getElementById('grammarForm').classList.add('form-disabled');
        document.getElementById('errorMessage').style.display = 'none';
    }

    // Function to hide loading animation
    function hideLoading() {
        document.getElementById('loadingOverlay').style.display = 'none';
        document.getElementById('grammarForm').classList.remove('form-disabled');
    }

    // Function to show error message
    function showError(message) {
        const errorElement = document.getElementById('errorMessage');
        errorElement.textContent = message;
        errorElement.style.display = 'block';
    }

    // Function to update the result in the page
    function updateResult(correctedText) {
        const outputContainer = document.getElementById('outputContainer');
        if (correctedText.startsWith('Error:')) {
            showError(correctedText);
            outputContainer.innerHTML = '';
        } else {
            // Create the HTML using proper string concatenation
            outputContainer.innerHTML =
                '<div class="output-section">' +
                '<h3>Corrected text:</h3>' +
                '<div class="output-text">' + correctedText + '</div>' +
                '</div>';
        }
    }

    // Add event listener to form submission
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('grammarForm');

        form.addEventListener('submit', function(event) {
            // Prevent the default form submission
            event.preventDefault();

            // Get the input value
            const userInput = document.getElementById('userInput').value.trim();

            // Validate input
            if (!userInput) {
                showError('Please enter some text to correct.');
                return;
            }

            // Show loading animation
            showLoading();

            // Use URLSearchParams for simple key-value data transfer
            const params = new URLSearchParams();
            params.append('userInput', userInput);

            // Send AJAX request
            fetch('', {
                method: 'POST',
                body: params,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.text();
                })
                .then(responseText => {
                    console.log('Raw response text:', responseText);
                    updateResult(responseText);
                })
                .catch(error => {
                    console.error('Error:', error);
                    showError('An error occurred: ' + error.message);
                })
                .finally(() => {
                    hideLoading();
                });
        });
    });
</script>
</body>
</html>