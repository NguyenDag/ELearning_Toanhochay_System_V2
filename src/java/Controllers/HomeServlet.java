package Controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.LinkedHashMap; // Use LinkedHashMap to maintain order
import java.util.List;
import java.util.Map;

/**
 * Servlet for the home page. Maps to the root URL ("").
 * Prepares dynamic data (like menus) and forwards to home.jsp.
 */
@WebServlet(name="HomeServlet", value = "") // Maps to the root URL
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        // --- CREATE DYNAMIC DATA FOR NAVIGATION MENUS ---
        Map<String, List<String>> lectureMenu = new LinkedHashMap<>();
        lectureMenu.put("Lớp 6", Arrays.asList("Số học", "Hình học trực quan", "Thống kê & Xác suất"));
        lectureMenu.put("Lớp 7", Arrays.asList("Số hữu tỉ", "Hình học phẳng", "Biểu thức đại số"));
        lectureMenu.put("Lớp 8", Arrays.asList("Đa thức", "Định lý Thales", "Hàm số và đồ thị"));
        lectureMenu.put("Lớp 9", Arrays.asList("Căn bậc hai", "Hệ thức lượng", "Góc với đường tròn"));

        // Add more menus if needed (e.g., reviewMenu, testMenu)
        // Map<String, List<String>> reviewMenu = new LinkedHashMap<>();
        // ... add data ...

        // Pass data to the JSP via request attributes
        request.setAttribute("lectureMenu", lectureMenu);
        // request.setAttribute("reviewMenu", reviewMenu);

        // Forward to the home.jsp view
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Usually, the home page doesn't handle POST, so just call doGet
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Home page servlet preparing dynamic content";
    }
}