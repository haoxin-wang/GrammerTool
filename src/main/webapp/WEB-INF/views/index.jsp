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

        /* Word counter styling */
        .word-counter {
            text-align: right;
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }

        .word-counter.limit-exceeded {
            color: #d9534f;
            font-weight: bold;
        }

        /* Text area styling */
        textarea {
            width: 100%;
            min-height: 150px;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            resize: vertical;
            font-family: inherit;
            font-size: 16px;
        }

        /* Button styling */
        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }

        button:hover {
            background-color: #45a049;
        }

        button:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
        }

        /* Container and layout */
        .grammar-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .input-section, .output-section {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .output-text {
            background-color: white;
            padding: 15px;
            border-radius: 4px;
            border-left: 4px solid #4CAF50;
        }

        /* Navigation */
        nav {
            background-color: #333;
            padding: 10px 0;
        }

        nav ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
        }

        nav li {
            margin: 0 15px;
        }

        nav a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        /* Footer */
        footer {
            text-align: center;
            padding: 20px;
            background-color: #f5f5f5;
            margin-top: 40px;
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
            <p><strong>Note:</strong> Your text is limited to 1024 words maximum.</p>
        </div>
    </section>

    <section id="grammar">
        <div class="grammar-container">
            <h2 class="section-title">Grammar Correction</h2>

            <div class="input-section">
                <h3>Enter your text:</h3>
                <form id="grammarForm" method="post">
                    <textarea name="userInput" id="userInput" placeholder="Type or paste your text here (max 1024 words)..." required>${userInput != null ? userInput : ''}</textarea>
                    <div id="wordCounter" class="word-counter">0/1024 words</div>
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
    // Function to count words in a string
    function countWords(text) {
        text = text.trim();
        if (text === '') return 0;
        return text.split(/\s+/).length;
    }

    // Function to update word counter
    function updateWordCounter() {
        const text = document.getElementById('userInput').value;
        const wordCount = countWords(text);
        const counterElement = document.getElementById('wordCounter');
        const submitButton = document.getElementById('submitButton');

        counterElement.textContent = `${wordCount}/1024 words`;

        if (wordCount > 1024) {
            counterElement.classList.add('limit-exceeded');
            submitButton.disabled = true;
        } else {
            counterElement.classList.remove('limit-exceeded');
            submitButton.disabled = false;
        }
    }

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
            outputContainer.innerHTML =
                '<div class="output-section">' +
                '<h3>Corrected text:</h3>' +
                '<div class="output-text">' + correctedText + '</div>' +
                '</div>';
        }
    }

    // Add event listeners when DOM is loaded
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('grammarForm');
        const textarea = document.getElementById('userInput');

        // Initialize word counter
        updateWordCounter();

        // Add input event listener to update word counter
        textarea.addEventListener('input', updateWordCounter);

        form.addEventListener('submit', function(event) {
            // Prevent the default form submission
            event.preventDefault();

            // Get the input value
            const userInput = textarea.value.trim();

            // Validate input
            if (!userInput) {
                showError('Please enter some text to correct.');
                return;
            }

            // Validate word count
            const wordCount = countWords(userInput);
            if (wordCount > 1024) {
                showError('Text exceeds the maximum limit of 1024 words. Please shorten your text.');
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