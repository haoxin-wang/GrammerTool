package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;

// Google GenAI imports
import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;

@WebServlet({"","/","/home"})
public class HomeServlet extends HttpServlet {
    private String API_KEY;
    private Client client;

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize the client once when the servlet is created
        API_KEY = System.getenv("GEMINI_API_KEY");
        // If not found in environment, try system property (for local testing)
        if (API_KEY == null || API_KEY.trim().isEmpty()) {
            API_KEY = System.getProperty("GEMINI_API_KEY");
        }
        if (API_KEY == null || API_KEY.trim().isEmpty()) {
            throw new ServletException("GEMINI_API_KEY environment variable is not set.");
        }
        client = Client.builder().apiKey(API_KEY).build();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set data for your single page
        request.setAttribute("pageTitle", "Grammar Correction Tool");
        request.setAttribute("sections", new String[]{"home", "grammar"});
        request.setAttribute("currentYear", LocalDateTime.now().getYear());

        // Forward to the single JSP page
        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userInput = request.getParameter("userInput");
        String correctedText = "";

        if (userInput != null && !userInput.trim().isEmpty()) {
            try {
                correctedText = callGeminiAPI(userInput);
            } catch (Exception e) {
                correctedText = "Error: " + e.getMessage();
                e.printStackTrace();
            }
        } else {
            correctedText = "Error: Please provide some text to correct.";
        }

        // Check if it's an AJAX request
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        if (isAjax) {
            // For AJAX requests, return plain text response
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(correctedText);
        } else {
            // For regular requests, set attributes and forward to JSP
            request.setAttribute("pageTitle", "Grammar Correction Tool");
            request.setAttribute("sections", new String[]{"home", "grammar"});
            request.setAttribute("currentYear", LocalDateTime.now().getYear());
            request.setAttribute("userInput", userInput);
            request.setAttribute("correctedText", correctedText);

            request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
        }
    }

    private String callGeminiAPI(String text) {
        try {
            // Check word count on server side as well
            String[] words = text.split("\\s+");
            if (words.length > 1024) {
                return "Error: Input exceeds 1024 words. Please shorten your text.";
            }
            String prompt = "Correct the grammar and improve the following text: \"" + text + "\". " +
                    "Return only the corrected text without any additional explanations.";

            // Log the prompt for debugging
            System.out.println("Prompt sent to Gemini API: " + prompt);

            GenerateContentResponse response = client.models.generateContent(
                    "gemini-2.5-flash",  // Make sure this is the correct model name
                    prompt,
                    null);

            String correctedText = response.text();

            // Log the raw response for debugging
            System.out.println("Gemini API raw response: " + correctedText);

            if (correctedText == null || correctedText.trim().isEmpty()) {
                return "Error: Gemini API returned an empty response.";
            }

            return correctedText.trim();

        } catch (Exception e) {
            // Log the full exception for debugging
            e.printStackTrace();
            return "Error calling Gemini API: " + e.getMessage();
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        // Clean up resources if needed
        if (client != null) {
            // Close the client if there's a close method
            // client.close();
        }
    }
}