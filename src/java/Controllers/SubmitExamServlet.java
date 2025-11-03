package Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SubmitExamServlet", value = "/SubmitExam")
public class SubmitExamServlet extends HttpServlet {

    private static final List<Map<String, Object>> questions = new ArrayList<>();
    private static final Map<Integer, Integer> correctAnswers = new HashMap<>();

    @Override
    public void init() {
        // Chỉ khởi tạo nếu danh sách rỗng để tránh trùng lặp
        if (questions.isEmpty()) {
    // --- BỔ SUNG GIẢI THÍCH CHO TỪNG CÂU HỎI MÔN TOÁN LỚP 6 ---

    // Question 1
    Map<String, Object> q1 = new HashMap<>();
    q1.put("id", 1);
    q1.put("text", "Số đối của -7 là số nào?");
    q1.put("choices", List.of("-7", "0", "7", "1"));
    q1.put("explanation", "Số đối của -7 là 7 vì -7 + 7 = 0.");
    questions.add(q1);
    correctAnswers.put(1, 2); // "7"

    // Question 2
    Map<String, Object> q2 = new HashMap<>();
    q2.put("id", 2);
    q2.put("text", "Số nhỏ nhất có ba chữ số là số nào?");
    q2.put("choices", List.of("99", "100", "101", "110"));
    q2.put("explanation", "Số có ba chữ số nhỏ nhất là 100 vì 99 chỉ có hai chữ số.");
    questions.add(q2);
    correctAnswers.put(2, 1); // "100"

    // Question 3
    Map<String, Object> q3 = new HashMap<>();
    q3.put("id", 3);
    q3.put("text", "Một hình vuông có cạnh 5 cm. Chu vi của hình vuông đó là bao nhiêu?");
    q3.put("choices", List.of("10 cm", "15 cm", "20 cm", "25 cm"));
    q3.put("explanation", "Chu vi hình vuông được tính bằng công thức P = 4 × cạnh = 4 × 5 = 20 cm.");
    questions.add(q3);
    correctAnswers.put(3, 2); // "54"

    // Question 4
    Map<String, Object> q4 = new HashMap<>();
    q4.put("id", 4);
    q4.put("text", "Tổng của các góc trong một tam giác bằng bao nhiêu độ?");
    q4.put("choices", List.of("90°", "120°", "180°", "360°"));
    q4.put("explanation", "Tổng ba góc trong một tam giác luôn bằng 180° theo định lý hình học cơ bản.");
    questions.add(q4);
    correctAnswers.put(4, 2); // "180°"

    // Question 5
    Map<String, Object> q5 = new HashMap<>();
    q5.put("id", 5);
    q5.put("text", "Phân số nào bằng 1/2?");
    q5.put("choices", List.of("2/4", "3/4", "4/6", "1/3"));
    q5.put("explanation", "Phân số 2/4 rút gọn được thành 1/2, nên chúng bằng nhau.");
    questions.add(q5);
    correctAnswers.put(5, 0); // "2/4"
}

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int score = 0;
        List<Map<String, Object>> results = new ArrayList<>();

        for (Map<String, Object> q : questions) {
            int questionId = (int) q.get("id");
            String paramName = "question_" + questionId;
            String userAnswerStr = request.getParameter(paramName);
            int userAnswerIndex = -1;
            
            if (userAnswerStr != null && !userAnswerStr.isEmpty()) {
                userAnswerIndex = Integer.parseInt(userAnswerStr);
            }

            int correctAnswerIndex = correctAnswers.get(questionId);

            if (userAnswerIndex == correctAnswerIndex) {
                score++;
            }

            Map<String, Object> resultDetail = new HashMap<>();
            resultDetail.put("questionText", q.get("text"));
            resultDetail.put("choices", q.get("choices"));
            resultDetail.put("userAnswerIndex", userAnswerIndex);
            resultDetail.put("correctAnswerIndex", correctAnswerIndex);
            // THÊM MỚI: Gửi cả phần giải thích sang trang JSP
            resultDetail.put("explanation", q.get("explanation")); 
            results.add(resultDetail);
        }

        request.setAttribute("score", score);
        request.setAttribute("totalQuestions", questions.size());
        request.setAttribute("results", results);

        // Chuyển hướng đến file result.jsp ở thư mục gốc
        request.getRequestDispatcher("result.jsp").forward(request, response);
    }
}