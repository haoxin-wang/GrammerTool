package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;

// Google GenAI imports
import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;

@WebServlet("")
public class HomeServlet extends HttpServlet {
    private static final String API_KEY = "AIzaSyBhKDWT6qqeNMYSxV7_6s_xptAX1FIjyn0";
    private Client client;

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize the client once when the servlet is created
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
        }

        // Set data for the response
        request.setAttribute("pageTitle", "Grammar Correction Tool");
        request.setAttribute("sections", new String[]{"home", "grammar"});
        request.setAttribute("currentYear", LocalDateTime.now().getYear());
        request.setAttribute("userInput", userInput);
        request.setAttribute("correctedText", correctedText);

        // Forward to the same JSP page
        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }

    private String callGeminiAPI(String text) {
        try {
            String prompt = "Correct the grammar and improve the following text: \"" + text + "\". " +
                    "Return only the corrected text without any additional explanations.";

            GenerateContentResponse response = client.models.generateContent(
                    "gemini-2.5-flash", // Using gemini-pro as gemini-2.5-flash might not be available
                    prompt,
                    null);

            return response.text();
        } catch (Exception e) {
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