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
        .grammar-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .input-section, .output-section {
            margin-bottom: 30px;
        }
        textarea {
            width: 100%;
            min-height: 150px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-family: inherit;
            font-size: 16px;
            resize: vertical;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        button:hover {
            background-color: #45a049;
        }
        .output-text {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #4CAF50;
            white-space: pre-wrap;
        }
        .section-title {
            color: #333;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
            margin-bottom: 20px;
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
                <form action="" method="post">
                    <textarea name="userInput" placeholder="Type or paste your text here..." required>${userInput != null ? userInput : ''}</textarea>
                    <button type="submit">Correct Grammar</button>
                </form>
            </div>

            <c:if test="${not empty correctedText}">
                <div class="output-section">
                    <h3>Corrected text:</h3>
                    <div class="output-text">${correctedText}</div>
                </div>
            </c:if>
        </div>
    </section>
</main>

<footer>
    <p>&copy; ${currentYear} Grammar Correction Tool. All rights reserved.</p>
</footer>

<script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>