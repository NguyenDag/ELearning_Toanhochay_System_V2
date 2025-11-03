<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Bài Thi - Xuất sắc!</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --success-color: #16a34a;
            --danger-color: #dc2626;
            --warning-color: #f59e0b;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f0f8ff 0%, #e6f2ff 100%);
            padding: 50px 20px;
            color: #334155;
            overflow-x: hidden;
        }

        .result-container {
            max-width: 900px;
            margin: auto;
            background: white;
            border-radius: 24px;
            padding: 40px 50px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
            border: 1px solid #e2e8f0;
            animation: fadeInUp 0.8s ease-out;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Score Display Section */
        .score-display {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 40px;
            text-align: left;
            padding-bottom: 30px;
            margin-bottom: 30px;
            border-bottom: 1px solid #e2e8f0;
        }

        .progress-circle {
            position: relative;
            width: 160px;
            height: 160px;
            border-radius: 50%;
            display: grid;
            place-items: center;
            background: conic-gradient(var(--primary-color) 0deg, #e0e7ff 0deg);
            transition: background 1.5s ease-out;
        }
        .progress-circle::before {
            content: "";
            position: absolute;
            width: 85%;
            height: 85%;
            background: white;
            border-radius: 50%;
        }
        .score-value {
            position: relative;
            font-size: 2.8rem;
            font-weight: 800;
            color: var(--primary-color);
        }
        .score-total {
            font-size: 1rem;
            color: #64748b;
            font-weight: 500;
        }

        .result-message h1 {
            font-weight: 800;
            color: #1e293b;
            font-size: 2.5rem;
        }
        .result-message p {
            font-size: 1.1rem;
            color: #475569;
        }

        /* Stats Summary Section */
        .stats-summary {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }
        .stat-card {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 20px;
            text-align: center;
        }
        .stat-card .icon {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        .stat-card .value {
            font-size: 2.2rem;
            font-weight: 700;
        }
        .stat-card .label {
            font-size: 0.9rem;
            font-weight: 500;
            color: #64748b;
        }
        .stat-card.correct { border-left: 5px solid var(--success-color); }
        .stat-card.correct .icon, .stat-card.correct .value { color: var(--success-color); }
        .stat-card.incorrect { border-left: 5px solid var(--danger-color); }
        .stat-card.incorrect .icon, .stat-card.incorrect .value { color: var(--danger-color); }
        .stat-card.skipped { border-left: 5px solid var(--warning-color); }
        .stat-card.skipped .icon, .stat-card.skipped .value { color: var(--warning-color); }
        
        /* Question Review Section */
        .question-review {
            margin-bottom: 20px;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 25px;
            background-color: white;
            transition: box-shadow 0.3s ease;
        }
        .question-review:hover {
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.07);
        }
        .question-review h5 { font-weight: 700; margin-bottom: 20px; }
        .option {
            padding: 12px 20px; border-radius: 12px; margin-bottom: 10px; border: 2px solid #f1f5f9;
            background-color: #f8fafc;
        }
        .option.correct {
            background-color: #f0fdf4; border-color: var(--success-color); font-weight: 600; color: #14532d;
        }
        .option.incorrect {
            background-color: #fef2f2; border-color: var(--danger-color); color: #7f1d1d; text-decoration: line-through;
        }
        .option.correct i { color: var(--success-color); }
        .option.incorrect i { color: var(--danger-color); }

        /* CTA Buttons */
        .cta-buttons { text-align: center; margin-top: 40px; }
        .cta-buttons .btn {
            font-weight: 600;
            padding: 12px 30px;
            border-radius: 12px;
            transition: all 0.3s ease;
        }
         .cta-buttons .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        /* Confetti Animation */
        .confetti {
            position: fixed;
            width: 10px;
            height: 10px;
            background-color: #f00;
            opacity: 0;
            animation: fall 5s linear infinite;
        }
        @keyframes fall {
            to { transform: translateY(100vh); opacity: 0; }
        }
    </style>
</head>
<body>
    
    <%-- Tính toán trước các giá trị cần thiết --%>
    <c:set var="scorePercentage" value="${score / totalQuestions * 100}" />
    <c:set var="incorrectCount" value="${totalQuestions - score - (fn:length(results) - fn:length(fn:split(pageContext.request.queryString, '=')) + 1)}" />
    <c:set var="skippedCount" value="${totalQuestions - score - incorrectCount}" />


    <div class="container">
        <div class="result-container">
            <div class="score-display">
                <div class="progress-circle" id="progressCircle">
                    <div class="score-value">
                        <span id="scoreValue">0</span><span class="score-total">/${totalQuestions}</span>
                    </div>
                </div>
                <div class="result-message">
                    <c:choose>
                        <c:when test="${scorePercentage >= 90}">
                            <h1>🎉 Xuất sắc!</h1>
                            <p>Bạn đã thể hiện kiến thức tuyệt vời.</p>
                        </c:when>
                        <c:when test="${scorePercentage >= 70}">
                            <h1>👍 Làm tốt lắm!</h1>
                            <p>Kết quả của bạn rất ấn tượng.</p>
                        </c:when>
                        <c:when test="${scorePercentage >= 50}">
                            <h1>🙂 Khá tốt!</h1>
                            <p>Bạn đã vượt qua bài thi. Cố gắng thêm nhé!</p>
                        </c:when>
                        <c:otherwise>
                            <h1>🤔 Cần cố gắng hơn!</h1>
                            <p>Đừng nản lòng, hãy xem lại và thử lại nhé.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="stats-summary">
                <div class="stat-card correct">
                    <div class="icon"><i class="fas fa-check-circle"></i></div>
                    <div class="value">${score}</div>
                    <div class="label">Đúng</div>
                </div>
                <div class="stat-card incorrect">
                    <div class="icon"><i class="fas fa-times-circle"></i></div>
                    <div class="value">${totalQuestions - score}</div>
                    <div class="label">Sai / Bỏ qua</div>
                </div>
                <div class="stat-card skipped">
                    <div class="icon"><i class="fas fa-star"></i></div>
                    <div class="value"><c:out value="${String.format('%.0f%%', scorePercentage)}"/></div>
                    <div class="label">Tỷ lệ đúng</div>
                </div>
            </div>

            <h3 class="mb-4 text-center">Xem Lại Chi Tiết</h3>

            <c:forEach items="${results}" var="res" varStatus="loop">
                 <div class="question-review">
                    <h5>Câu ${loop.count}: ${res.questionText}</h5>
                    
                    <c:forEach items="${res.choices}" var="choice" varStatus="choiceLoop">
                        <c:set var="choiceIndex" value="${choiceLoop.index}" />
                        <c:set var="isCorrect" value="${choiceIndex == res.correctAnswerIndex}" />
                        <c:set var="isUserAnswer" value="${choiceIndex == res.userAnswerIndex}" />

                        <div class="option 
                             <c:if test='${isCorrect}'>correct</c:if>
                             <c:if test='${isUserAnswer && !isCorrect}'>incorrect</c:if>
                        ">
                            <c:choose>
                                <c:when test="${isCorrect}"><i class="fas fa-check me-2"></i></c:when>
                                <c:when test="${isUserAnswer && !isCorrect}"><i class="fas fa-times me-2"></i></c:when>
                                <c:otherwise><i class="far fa-circle me-2" style="opacity: 0.5;"></i></c:otherwise>
                            </c:choose>
                            ${choice}
                        </div>
                    </c:forEach>

                    <c:if test="${res.userAnswerIndex == -1}">
                        <div class="alert alert-warning mt-3 py-2">Bạn đã bỏ qua câu hỏi này.</div>
                    </c:if>
                </div>
            </c:forEach>
            
            <div class="cta-buttons">
                <a href="<c:url value='/Pages/Quiz.jsp' />" class="btn btn-outline-primary"><i class="fas fa-redo-alt me-2"></i> Làm lại bài thi</a>
                <a href="${pageContext.request.contextPath}/index.html" class="btn btn-primary"><i class="fas fa-home me-2"></i> Về Trang Chủ</a>
            </div>
        </div>
    </div>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Lấy các giá trị điểm từ JSP
        const score = parseInt('${score}');
        const totalQuestions = parseInt('${totalQuestions}');
        const scorePercentage = totalQuestions > 0 ? (score / totalQuestions) * 100 : 0;

        // Lấy các element cần cập nhật
        const progressCircle = document.getElementById('progressCircle');
        const scoreValueEl = document.getElementById('scoreValue');
        
        // --- PHẦN SỬA LỖI ---
        
        // TRƯỜNG HỢP 1: Nếu điểm bằng 0, hiển thị ngay lập tức và không chạy hiệu ứng đếm
        if (score === 0) {
            scoreValueEl.textContent = 0;
            progressCircle.style.background = `conic-gradient(#e0e7ff 0deg, #e0e7ff 360deg)`;
            return; // Dừng hàm tại đây
        }

        // TRƯỜNG HỢP 2: Nếu điểm lớn hơn 0, mới bắt đầu hiệu ứng đếm
        let startValue = 0;
        const endValue = score;
        const duration = 1500; // Tổng thời gian hiệu ứng là 1.5 giây
        
        // Tính toán thời gian cho mỗi bước đếm để đảm bảo nó hoàn thành trong 'duration'
        const stepTime = Math.max(10, Math.floor(duration / endValue));

        const counter = setInterval(() => {
            startValue += 1;
            
            // Cập nhật số và vòng tròn
            scoreValueEl.textContent = startValue;
            const progressDegrees = (startValue / totalQuestions) * 360;
            progressCircle.style.background = `conic-gradient(var(--primary-color) ${progressDegrees}deg, #e0e7ff ${progressDegrees}deg)`;

            // SỬA LỖI: Dùng điều kiện ">=" để dừng bộ đếm một cách an toàn
            if (startValue >= endValue) {
                clearInterval(counter); // Dừng bộ đếm ngay lập tức
                
                // Đảm bảo con số cuối cùng hiển thị chính xác là điểm số
                scoreValueEl.textContent = endValue; 
                const finalDegrees = (endValue / totalQuestions) * 360;
                progressCircle.style.background = `conic-gradient(var(--primary-color) ${finalDegrees}deg, #e0e7ff ${finalDegrees}deg)`;

                // Nếu điểm cao, bắt đầu hiệu ứng pháo giấy
                if (scorePercentage >= 80) {
                    startConfetti();
                }
            }
        }, stepTime);

        // --- HẾT PHẦN SỬA LỖI ---

        // Hàm tạo hiệu ứng pháo giấy
        function startConfetti() {
            const colors = ['#2563eb', '#16a34a', '#f59e0b', '#ef4444', '#8b5cf6'];
            for (let i = 0; i < 100; i++) {
                const confetti = document.createElement('div');
                confetti.classList.add('confetti');
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.top = Math.random() * -100 + 'vh';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.animationDelay = Math.random() * 2 + 's';
                document.body.appendChild(confetti);

                setTimeout(() => {
                    confetti.remove();
                }, 5000); // Tự xóa pháo giấy sau 5 giây
            }
        }
    });
</script>
</body>
</html>