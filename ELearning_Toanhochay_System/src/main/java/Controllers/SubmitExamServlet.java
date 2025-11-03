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

@WebServlet(name = "SubmitExamServlet", value = "/submitExam")
public class SubmitExamServlet extends HttpServlet {

    private static final List<Map<String, Object>> questions = new ArrayList<>();
    private static final Map<Integer, Integer> correctAnswers = new HashMap<>();

    @Override
    public void init() {
        if (questions.isEmpty()) {
            // Question 1
            Map<String, Object> q1 = new HashMap<>();
            q1.put("id", 1);
            q1.put("text", "Trong Java, interface nào là gốc của tất cả các Collection?");
            q1.put("choices", List.of("List", "Collection", "Set", "Iterable"));
            // THÊM MỚI: Dòng giải thích
            q1.put("explanation", "Tất cả các interface trong Collection Framework đều kế thừa từ interface `Iterable`. Cấu trúc kế thừa là: Iterable -> Collection -> List/Set.");
            questions.add(q1);
            correctAnswers.put(1, 3);

            // Question 2
            Map<String, Object> q2 = new HashMap<>();
            q2.put("id", 2);
            q2.put("text", "Từ khóa 'final' có thể được áp dụng cho thành phần nào sau đây?");
            q2.put("choices", List.of("Biến", "Phương thức", "Lớp", "Tất cả các đáp án trên"));
            // THÊM MỚI: Dòng giải thích
            q2.put("explanation", "Từ khóa `final` có thể dùng cho biến (để tạo hằng số), phương thức (để ngăn override), và lớp (để ngăn kế thừa).");
            questions.add(q2);
            correctAnswers.put(2, 3);

            // Question 3
            Map<String, Object> q3 = new HashMap<>();
            q3.put("id", 3);
            q3.put("text", "Phương thức nào được gọi tự động khi một đối tượng được tạo?");
            q3.put("choices", List.of("Constructor", "Destructor", "Finalize", "Initialize"));
            // THÊM MỚI: Dòng giải thích
            q3.put("explanation", "`Constructor` (phương thức khởi tạo) là phương thức đặc biệt được gọi tự động ngay khi một đối tượng mới được tạo ra bằng từ khóa `new`.");
            questions.add(q3);
            correctAnswers.put(3, 0);

            // Question 4
            Map<String, Object> q4 = new HashMap<>();
            q4.put("id", 4);
            q4.put("text", "Đâu là một checked exception trong Java?");
            q4.put("choices", List.of("RuntimeException", "NullPointerException", "IOException", "ArrayIndexOutOfBoundsException"));
            // THÊM MỚI: Dòng giải thích
            q4.put("explanation", "`IOException` là một `checked exception`, buộc lập trình viên phải xử lý nó bằng `try-catch` hoặc `throws`. Các ngoại lệ còn lại đều là `unchecked exception` (kế thừa từ `RuntimeException`).");
            questions.add(q4);
            correctAnswers.put(4, 2);

            // Question 5
            Map<String, Object> q5 = new HashMap<>();
            q5.put("id", 5);
            q5.put("text", "Lớp nào dùng để đọc dữ liệu từ một file?");
            q5.put("choices", List.of("FileWriter", "FileInputStream", "FileScanner", "FileBuffer"));
            // THÊM MỚI: Dòng giải thích
            q5.put("explanation", "`FileInputStream` được sử dụng để đọc dữ liệu dạng byte từ một file. `FileWriter` dùng để ghi dữ liệu vào file.");
            questions.add(q5);
            correctAnswers.put(5, 1);
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

        request.getRequestDispatcher("Pages/result.jsp").forward(request, response);
    }
}