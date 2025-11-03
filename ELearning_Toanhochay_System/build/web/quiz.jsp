<%-- 
    Document   : quiz
    Created on : Oct 18, 2025, 7:28:22 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đề thi giữa kỳ 1 - QuizMaster Pro</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-color: #2563eb; /* Strong Blue */
                --primary-dark: #1e40af; /* Darker Blue */
                --primary-light: #3b82f6; /* Lighter Blue */
                --secondary-color: #10b981; /* Green for 'answered' */
                --danger-color: #ef4444; /* Red */
                --warning-color: #f59e0b; /* Orange-Yellow for 'flagged' */
                --warning-light: #fbbf24;
                --dark-color: #1e293b; /* Dark Slate */
                --light-gray: #f8fafc;
                --border-color: #e2e8f0; /* Light Gray Border */
                --text-primary: #0f172a; /* Very Dark Blue-Gray */
                --text-secondary: #64748b; /* Medium Gray */
                --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                --card-shadow-lg: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
                --bg-gradient-start: #e0f2fe; /* Lightest Blue for body bg */
                --bg-gradient-end: #c1e4ff;   /* Slightly darker blue for body bg */
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, var(--bg-gradient-start) 0%, var(--bg-gradient-end) 100%);
                color: var(--text-primary);
                min-height: 100vh;
                padding: 30px 20px;
                position: relative;
                overflow-x: hidden; /* Prevent horizontal scroll */
            }

            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><defs><pattern id="grid" width="100" height="100" patternUnits="userSpaceOnUse"><path d="M 100 0 L 0 0 0 100" fill="none" stroke="rgba(0,0,0,0.02)" stroke-width="1"/></pattern></defs><rect width="100%" height="100%" fill="url(%23grid)"/></svg>');
                pointer-events: none;
                z-index: 0;
            }

            .quiz-layout {
                display: flex;
                width: 100%;
                max-width: 1400px;
                margin: 0 auto;
                gap: 25px;
                position: relative;
                z-index: 1;
            }

            /* Side Panel - Enhanced */
            .side-panel {
                width: 300px;
                flex-shrink: 0;
                background: rgba(255, 255, 255, 0.9); /* Slightly transparent white */
                backdrop-filter: blur(15px); /* Frosted glass effect */
                border-radius: 24px;
                box-shadow: var(--card-shadow-lg);
                padding: 30px;
                display: flex;
                flex-direction: column;
                border: 1px solid rgba(255, 255, 255, 0.8);
                animation: slideInLeft 0.6s ease-out;
            }

            @keyframes slideInLeft {
                from {
                    opacity: 0;
                    transform: translateX(-30px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            @keyframes slideInRight {
                from {
                    opacity: 0;
                    transform: translateX(30px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .side-panel-header {
                padding-bottom: 25px;
                margin-bottom: 25px;
                border-bottom: 2px solid var(--border-color);
            }

            .side-panel-header h5 {
                font-weight: 700;
                font-size: 1.1rem;
                color: var(--text-primary);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                margin: 0;
            }

            .side-panel-header i {
                color: var(--primary-color);
                font-size: 1.2rem;
            }

            .question-grid {
                display: grid;
                grid-template-columns: repeat(5, 1fr);
                gap: 10px;
                margin-bottom: 25px;
            }

            .q-nav-item {
                height: 50px;
                border-radius: 12px;
                background: linear-gradient(135deg, var(--light-gray) 0%, #eef2f6 100%);
                border: 2px solid var(--border-color);
                color: var(--text-secondary);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
                font-size: 1rem;
                cursor: pointer;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                overflow: hidden;
                z-index: 1;
            }

            .q-nav-item::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                border-radius: 50%;
                background: rgba(var(--primary-color-rgb), 0.1); /* Use primary color RGB */
                transform: translate(-50%, -50%);
                transition: width 0.6s, height 0.6s;
                z-index: -1;
            }

            .q-nav-item:hover::before {
                width: 100px;
                height: 100px;
            }

            .q-nav-item:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(var(--primary-color-rgb), 0.2);
                border-color: var(--primary-color);
            }

            .q-nav-item.answered {
                background: linear-gradient(135deg, var(--secondary-color) 0%, #059669 100%);
                color: white;
                border-color: var(--secondary-color);
                box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
            }

            .q-nav-item.answered::after {
                content: '\f00c';
                font-family: 'Font Awesome 6 Free';
                font-weight: 900;
                position: absolute;
                top: -5px;
                right: -5px;
                background: white;
                color: var(--secondary-color);
                width: 20px;
                height: 20px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.7rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.2);
                z-index: 2;
            }

            /* NEW: Style for flagged questions */
            .q-nav-item.flagged {
                background: linear-gradient(135deg, var(--warning-color) 0%, var(--warning-light) 100%);
                color: var(--dark-color);
                border-color: var(--warning-light);
                font-weight: 800;
                box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
            }

            .q-nav-item.current {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
                color: white;
                border-color: var(--primary-color);
                transform: scale(1.15);
                box-shadow: 0 8px 20px rgba(var(--primary-color-rgb), 0.4);
                z-index: 10;
            }

            .stats-panel {
                background: linear-gradient(135deg, #e0f7fa 0%, #b2ebf2 100%); /* Light blue gradient for stats */
                border-radius: 16px;
                padding: 20px;
                margin-bottom: 25px;
                border: 1px solid #80deea;
            }

            .stat-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 0;
                border-bottom: 1px solid rgba(128, 222, 234, 0.5);
            }

            .stat-item:last-child {
                border-bottom: none;
            }

            .stat-label {
                font-size: 0.9rem;
                color: var(--text-secondary);
                font-weight: 500;
            }

            .stat-value {
                font-size: 1.1rem;
                font-weight: 700;
                color: var(--primary-color);
            }

            .btn-submit-exam {
                margin-top: auto;
                background: linear-gradient(135deg, var(--danger-color) 0%, #dc2626 100%);
                border: none;
                font-weight: 700;
                font-size: 1rem;
                padding: 18px;
                border-radius: 14px;
                transition: all 0.3s ease;
                color: white;
                box-shadow: 0 8px 16px rgba(239, 68, 68, 0.3);
                position: relative;
                overflow: hidden;
                z-index: 1;
            }

            .btn-submit-exam::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.2);
                transform: translate(-50%, -50%);
                transition: width 0.6s, height 0.6s;
                z-index: -1;
            }

            .btn-submit-exam:hover::before {
                width: 300px;
                height: 300px;
            }

            .btn-submit-exam:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 24px rgba(239, 68, 68, 0.4);
            }

            .btn-submit-exam:active {
                transform: translateY(-1px);
            }

            /* Main Quiz Area - Enhanced */
            .main-quiz-content {
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                animation: slideInRight 0.6s ease-out;
            }

            .quiz-header {
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(15px);
                border-radius: 24px;
                box-shadow: var(--card-shadow-lg);
                padding: 25px 35px;
                margin-bottom: 25px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border: 1px solid rgba(255, 255, 255, 0.8);
            }

            .quiz-title {
                color: var(--text-primary);
                font-weight: 800;
                font-size: 1.6rem;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .quiz-title i {
                color: var(--primary-color);
                font-size: 1.8rem;
            }

            .timer {
                background: linear-gradient(135deg, var(--dark-color) 0%, #334155 100%);
                color: white;
                padding: 14px 28px;
                border-radius: 16px;
                font-weight: 700;
                font-size: 1.3rem;
                min-width: 140px;
                text-align: center;
                box-shadow: 0 8px 16px rgba(30, 41, 59, 0.3);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                animation: pulse 2s ease-in-out infinite;
            }

            @keyframes pulse {
                0%, 100% {
                    box-shadow: 0 8px 16px rgba(30, 41, 59, 0.3);
                }
                50% {
                    box-shadow: 0 8px 24px rgba(30, 41, 59, 0.5);
                }
            }

            .timer i {
                font-size: 1.4rem;
            }

            .quiz-body {
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(15px);
                border-radius: 24px;
                box-shadow: var(--card-shadow-lg);
                padding: 45px;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                border: 1px solid rgba(255, 255, 255, 0.8);
            }

            .progress {
                height: 12px;
                border-radius: 20px;
                background-color: #e2e8f0;
                box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                margin-bottom: 10px;
            }

            .progress-bar {
                background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
                transition: width 0.5s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                overflow: hidden;
            }

            .progress-bar::after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                bottom: 0;
                right: 0;
                background: linear-gradient(
                    90deg,
                    transparent,
                    rgba(255, 255, 255, 0.3),
                    transparent
                    );
                animation: shimmer 2s infinite;
            }

            @keyframes shimmer {
                0% {
                    transform: translateX(-100%);
                }
                100% {
                    transform: translateX(100%);
                }
            }

            .progress-text {
                text-align: right;
                font-size: 0.85rem;
                color: var(--text-secondary);
                font-weight: 600;
                margin-bottom: 25px;
            }

            /* NEW: Wrapper for question text and flag button */
            .question-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                gap: 20px;
                margin-top: 30px;
                margin-bottom: 40px;
            }

            .question-text {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--text-primary);
                line-height: 1.7;
                flex-grow: 1;
                margin: 0;
                animation: fadeInUp 0.6s ease-out;
            }

            .question-text::before {
                content: '';
                display: inline-block;
                width: 6px;
                height: 35px;
                background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
                border-radius: 3px;
                margin-right: 15px;
                vertical-align: middle;
            }

            /* NEW: Flag button style */
            .btn-flag-question {
                background: transparent;
                border: 3px solid var(--border-color);
                color: var(--text-secondary);
                border-radius: 50%;
                width: 50px;
                height: 50px;
                flex-shrink: 0;
                font-size: 1.2rem;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                z-index: 1;
            }
            .btn-flag-question:hover {
                border-color: var(--warning-color);
                color: var(--warning-color);
                transform: scale(1.1);
            }
            .btn-flag-question.flagged {
                background-color: var(--warning-color);
                border-color: var(--warning-light);
                color: var(--dark-color);
            }

            .answers {
                display: flex;
                flex-direction: column;
                gap: 18px;
            }

            .answer-option {
                display: block;
                background: white;
                border: 3px solid var(--border-color);
                border-radius: 16px;
                padding: 20px 25px;
                cursor: pointer;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                overflow: hidden;
                z-index: 1;
            }

            .answer-option::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 0;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(var(--primary-color-rgb), 0.05));
                transition: width 0.4s ease;
                z-index: -1;
            }

            .answer-option:hover::before {
                width: 100%;
            }

            .answer-option:hover {
                transform: translateX(8px);
                box-shadow: 0 8px 20px rgba(var(--primary-color-rgb), 0.15);
                border-color: var(--primary-color);
            }

            .answer-option input[type="radio"] {
                display: none;
            }

            .answer-option .option-content {
                display: flex;
                align-items: center;
                position: relative;
                z-index: 1;
            }

            .answer-option .option-letter {
                width: 48px;
                height: 48px;
                border-radius: 14px;
                border: 3px solid var(--border-color);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 800;
                font-size: 1.1rem;
                margin-right: 20px;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                color: var(--text-secondary);
                background: #f8fafc;
            }

            .answer-option .option-text {
                font-size: 1.05rem;
                color: var(--text-primary);
                font-weight: 500;
                line-height: 1.6;
            }

            .answer-option input:checked + .option-content .option-letter {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
                color: white;
                border-color: var(--primary-color);
                transform: scale(1.1);
                box-shadow: 0 6px 16px rgba(var(--primary-color-rgb), 0.4);
            }

            .answer-option input:checked + .option-content .option-text {
                font-weight: 700;
                color: var(--primary-color);
            }

            .answer-option:has(input:checked) {
                border-color: var(--primary-color);
                background: linear-gradient(90deg, rgba(var(--primary-color-rgb), 0.05), white);
                box-shadow: 0 8px 20px rgba(var(--primary-color-rgb), 0.15);
            }

            .quiz-navigation {
                margin-top: auto;
                padding-top: 35px;
                border-top: 2px solid var(--border-color);
                display: flex;
                justify-content: space-between;
                gap: 15px;
            }

            .btn-nav {
                font-weight: 700;
                padding: 16px 40px;
                border-radius: 14px;
                font-size: 1rem;
                transition: all 0.3s ease;
                border: none;
                position: relative;
                overflow: hidden;
                z-index: 1;
            }

            .btn-nav::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.3);
                transform: translate(-50%, -50%);
                transition: width 0.6s, height 0.6s;
                z-index: -1;
            }

            .btn-nav:hover::before {
                width: 300px;
                height: 300px;
            }

            .btn-nav:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
            }

            .btn-nav:disabled {
                opacity: 0.5;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }

            .btn-outline-secondary {
                border: 3px solid var(--border-color) !important;
                background: white;
                color: var(--text-secondary);
            }

            .btn-outline-secondary:hover:not(:disabled) {
                background: #f8fafc;
                border-color: var(--text-secondary) !important;
            }

            .btn-primary {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
                box-shadow: 0 6px 16px rgba(var(--primary-color-rgb), 0.3);
            }

            .btn-primary:hover:not(:disabled) {
                box-shadow: 0 10px 24px rgba(var(--primary-color-rgb), 0.4);
            }

            /* Responsive */
            @media (max-width: 1200px) {
                .quiz-layout {
                    flex-direction: column;
                }

                .side-panel {
                    width: 100%;
                }

                .question-grid {
                    grid-template-columns: repeat(6, 1fr); /* More columns for smaller screens */
                }
            }

            @media (max-width: 768px) {
                body {
                    padding: 15px;
                }

                .quiz-header {
                    flex-direction: column;
                    gap: 15px;
                    text-align: center;
                }

                .quiz-title {
                    font-size: 1.3rem;
                }

                .question-text {
                    font-size: 1.2rem;
                }

                .question-header {
                    flex-direction: column-reverse; /* Put flag button above question on mobile */
                    align-items: center;
                    gap: 15px;
                }

                .btn-flag-question {
                    width: 45px;
                    height: 45px;
                    font-size: 1rem;
                }

                .quiz-navigation {
                    flex-direction: column;
                }

                .btn-nav {
                    width: 100%;
                    padding: 14px 20px;
                }

                .quiz-body {
                    padding: 30px;
                }

                .answer-option {
                    padding: 15px 20px;
                }
                .answer-option .option-letter {
                    width: 40px;
                    height: 40px;
                    font-size: 1rem;
                    margin-right: 15px;
                }
                .answer-option .option-text {
                    font-size: 0.95rem;
                }

                .question-grid {
                    grid-template-columns: repeat(4, 1fr);
                }
            }
            @media (max-width: 480px) {
                .question-grid {
                    grid-template-columns: repeat(3, 1fr);
                }
            }

            /* Helper for dynamic RGB values */
            /* You might need to adjust these manually based on your --primary-color */
            /* For example, for #2563eb, RGB is 37, 99, 235 */
            :root {
                --primary-color-rgb: 37, 99, 235;
            }

        </style>
    </head>
    <body>
        <%-- GIẢ LẬP DỮ LIỆU TỪ SERVLET --%>
    <c:if test="${empty quiz}">
    <c:set var="quizTitle" value="Đề kiểm tra giữa học kỳ 1 môn Toán lớp 6"/>
    <c:set var="quizTime" value="30"/>
    <jsp:useBean id="questions" scope="page" class="java.util.ArrayList"/>

    <%-- Câu 1 --%>
    <jsp:useBean id="q1" scope="page" class="java.util.HashMap"/>
    <c:set target="${q1}" property="id" value="1"/>
    <c:set target="${q1}" property="text" value="Số đối của -7 là số nào?"/>
    <c:set target="${q1}" property="choices" value="${['-7', '0', '7', '1']}"/>
    <% questions.add(q1); %>

    <%-- Câu 2 --%>
    <jsp:useBean id="q2" scope="page" class="java.util.HashMap"/>
    <c:set target="${q2}" property="id" value="2"/>
    <c:set target="${q2}" property="text" value="Số nhỏ nhất có ba chữ số là số nào?"/>
    <c:set target="${q2}" property="choices" value="${['99', '100', '101', '110']}"/>
    <% questions.add(q2); %>

    <%-- Câu 3 --%>
    <jsp:useBean id="q3" scope="page" class="java.util.HashMap"/>
    <c:set target="${q3}" property="id" value="3"/>
    <c:set target="${q3}" property="text" value="Một hình vuông có cạnh 5 cm. Chu vi của hình vuông đó là bao nhiêu?"/>
    <c:set target="${q3}" property="choices" value="${['10 cm', '15 cm', '20 cm', '25 cm']}"/>
    <% questions.add(q3); %>

    <%-- Câu 4 --%>
    <jsp:useBean id="q4" scope="page" class="java.util.HashMap"/>
    <c:set target="${q4}" property="id" value="4"/>
    <c:set target="${q4}" property="text" value="Tổng của các góc trong một tam giác bằng bao nhiêu độ?"/>
    <c:set target="${q4}" property="choices" value="${['90°', '120°', '180°', '360°']}"/>
    <% questions.add(q4); %>

    <%-- Câu 5 --%>
    <jsp:useBean id="q5" scope="page" class="java.util.HashMap"/>
    <c:set target="${q5}" property="id" value="5"/>
    <c:set target="${q5}" property="text" value="Phân số nào bằng 1/2?"/>
    <c:set target="${q5}" property="choices" value="${['2/4', '3/4', '4/6', '1/3']}"/>
    <% questions.add(q5); %>
</c:if>


    <div class="quiz-layout">
        <aside class="side-panel">
            <div class="side-panel-header">
                <h5><i class="fas fa-grip"></i>Bảng Câu Hỏi</h5>
            </div>

            <div class="stats-panel">
                <div class="stat-item">
                    <span class="stat-label"><i class="fas fa-list-check me-2"></i>Tổng câu hỏi</span>
                    <span class="stat-value">${fn:length(questions)}</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label"><i class="fas fa-check-circle me-2"></i>Đã trả lời</span>
                    <span class="stat-value" id="answeredCount">0</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label"><i class="fas fa-circle-dot me-2"></i>Chưa trả lời</span>
                    <span class="stat-value" id="unansweredCount">${fn:length(questions)}</span>
                </div>
            </div>

            <div class="question-grid">
                <c:forEach var="i" begin="1" end="${fn:length(questions)}">
                    <div class="q-nav-item" data-q-index="${i-1}">${i}</div>
                </c:forEach>
            </div>
            <button class="btn btn-danger w-100 btn-submit-exam" id="submitBtn">
                <i class="fas fa-paper-plane me-2"></i>NỘP BÀI THI
            </button>
        </aside>

        <main class="main-quiz-content">
            <header class="quiz-header">
                <h4 class="quiz-title">
                    <i class="fas fa-graduation-cap"></i>
                    ${quizTitle}
                </h4>
                <div class="timer">
                    <i class="far fa-clock"></i>
                    <span id="time">${quizTime}:00</span>
                </div>
            </header>

            <section class="quiz-body">
                <div class="progress">
                    <div id="progressBar" class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                </div>


                <form id="quizForm" action="<c:url value='/SubmitExam' />" method="post">                        <c:forEach items="${questions}" var="q" varStatus="loop">
                        <div class="question-container" id="question-block-${loop.index}" style="display: ${loop.index == 0 ? 'block' : 'none'};">
                            <div class="question-header">
                                <p class="question-text">
                                    <strong>Câu ${loop.count}:</strong> ${q.text}
                                </p>
                                <button type="button" class="btn-flag-question" data-q-index="${loop.index}" title="Ghim câu hỏi này">
                                    <i class="far fa-bookmark"></i>
                                </button>
                            </div>
                            <div class="answers">
                                <c:forEach items="${q.choices}" var="choice" varStatus="choiceLoop">
                                    <label class="answer-option">
                                        <input type="radio" name="question_${q.id}" value="${choiceLoop.index}">
                                        <div class="option-content">
                                            <span class="option-letter">${(choiceLoop.index == 0) ? 'A' : (choiceLoop.index == 1) ? 'B' : (choiceLoop.index == 2) ? 'C' : 'D'}</span>
                                            <span class="option-text">${choice}</span>
                                        </div>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>

                    <div class="quiz-navigation">
                        <button type="button" class="btn btn-outline-secondary btn-nav" id="prevBtn">
                            <i class="fas fa-arrow-left me-2"></i>Câu Trước
                        </button>
                        <button type="button" class="btn btn-primary btn-nav" id="nextBtn">
                            Câu Tiếp Theo<i class="fas fa-arrow-right ms-2"></i>
                        </button>
                    </div>
                </form>
            </section>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const questions = document.querySelectorAll('.question-container');
            const navItems = document.querySelectorAll('.q-nav-item');
            const flagButtons = document.querySelectorAll('.btn-flag-question'); // NEW
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            const submitBtn = document.getElementById('submitBtn');
            const progressBar = document.getElementById('progressBar');
            const progressText = document.getElementById('progressText');
            const answeredCountEl = document.getElementById('answeredCount');
            const unansweredCountEl = document.getElementById('unansweredCount');
            const totalQuestions = questions.length;
            let currentQuestionIndex = 0;

            function updateStats() {
                const answeredCount = document.querySelectorAll('.q-nav-item.answered').length;
                answeredCountEl.textContent = answeredCount;
                unansweredCountEl.textContent = totalQuestions - answeredCount;
            }

            function showQuestion(index) {
                questions.forEach(q => q.style.display = 'none');
                if (questions[index]) {
                    questions[index].style.display = 'block';
                }

                navItems.forEach(item => item.classList.remove('current'));
                if (navItems[index]) {
                    navItems[index].classList.add('current');
                }

                const progressPercentage = totalQuestions > 0 ? ((index + 1) / totalQuestions) * 100 : 0;
                progressBar.style.width = progressPercentage + '%';
                progressBar.setAttribute('aria-valuenow', progressPercentage);

                progressText.innerHTML = `Câu hỏi <strong>${index + 1}</strong> / <strong>${totalQuestions}</strong>`;

                prevBtn.disabled = index === 0;
                nextBtn.disabled = index === totalQuestions - 1;
            }

            nextBtn.addEventListener('click', () => {
                if (currentQuestionIndex < totalQuestions - 1) {
                    currentQuestionIndex++;
                    showQuestion(currentQuestionIndex);
                }
            });

            prevBtn.addEventListener('click', () => {
                if (currentQuestionIndex > 0) {
                    currentQuestionIndex--;
                    showQuestion(currentQuestionIndex);
                }
            });

            navItems.forEach(item => {
                item.addEventListener('click', () => {
                    const index = parseInt(item.getAttribute('data-q-index'));
                    currentQuestionIndex = index;
                    showQuestion(currentQuestionIndex);
                });
            });

            // NEW: Event listener for flag buttons
            flagButtons.forEach(button => {
                button.addEventListener('click', () => {
                    const index = parseInt(button.getAttribute('data-q-index'));
                    const navItem = navItems[index];
                    const icon = button.querySelector('i');

                    // Toggle flagged state for both nav item and button
                    button.classList.toggle('flagged');
                    navItem.classList.toggle('flagged');

                    // Toggle icon style
                    if (button.classList.contains('flagged')) {
                        icon.classList.remove('far');
                        icon.classList.add('fas');
                    } else {
                        icon.classList.remove('fas');
                        icon.classList.add('far');
                    }
                });
            });

            document.querySelectorAll('input[type="radio"]').forEach(radio => {
                radio.addEventListener('change', (event) => {
                    const questionContainer = event.target.closest('.question-container');
                    const questionIndex = Array.from(questions).indexOf(questionContainer);
                    if (questionIndex !== -1) {
                        navItems[questionIndex].classList.add('answered');
                        // Ensure 'flagged' state is not removed if already flagged
                        // navItems[questionIndex].classList.remove('flagged'); 
                        updateStats();
                    }
                });
            });

            submitBtn.addEventListener('click', () => {
                const answeredCount = document.querySelectorAll('.q-nav-item.answered').length;
                const unanswered = totalQuestions - answeredCount;

                let message = 'Bạn có chắc chắn muốn nộp bài thi không?';
                if (unanswered > 0) {
                    message = `Bạn còn ${unanswered} câu chưa trả lời. Bạn có chắc chắn muốn nộp bài không?`;
                }

                if (confirm(message)) {
                    document.getElementById('quizForm').submit();
                }
            });

            function startTimer(durationInMinutes, display) {
                let timer = durationInMinutes * 60, minutes, seconds;
                let interval = setInterval(function () {
                    minutes = parseInt(timer / 60, 10);
                    seconds = parseInt(timer % 60, 10);

                    minutes = minutes < 10 ? "0" + minutes : minutes;
                    seconds = seconds < 10 ? "0" + seconds : seconds;

                    display.textContent = minutes + ":" + seconds;

                    if (timer <= 60 && !display.parentElement.style.background.includes('rgb(239, 68, 68)')) { // Check for initial red gradient
                        display.parentElement.style.background = 'linear-gradient(135deg, var(--danger-color) 0%, #dc2626 100%)';
                    }

                    if (--timer < 0) {
                        clearInterval(interval);
                        alert("Hết giờ làm bài! Bài thi sẽ được tự động nộp.");
                        document.getElementById('quizForm').submit();
                    }
                }, 1000);
            }

            const quizTimeText = "${quizTime}";
            if (quizTimeText && !isNaN(quizTimeText)) {
                const quizTime = parseInt(quizTimeText);
                startTimer(quizTime, document.querySelector('#time'));
            }

            // Initial setup
            showQuestion(0);
            updateStats();
        });
    </script>
</body>
</html>
