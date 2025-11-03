<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- This file contains only the header part --%>

<header class="header">
    <div class="header_wrapper">
        <div class="header-container">
            <div class="logo-column">
                <div class="logo">
                    <a href="<c:url value='/' />"> <%-- Link logo to home --%>
                        <img src="<c:url value='/assets/images/logo_header.png' />" alt="ToanHocHay Logo">
                    </a>
                </div>
            </div>

            <div class="content-column">
                <div class="header-top-row">
                    <div class="header-search">
                        <input type="text" placeholder="Tìm kiếm khóa học, bài giảng..." class="search-input">
                        <button class="btn-search"><i class="fa-solid fa-magnifying-glass"></i></button>
                    </div>
                    <div class="header-actions">
                        <%-- Dynamic Login/Logout Display --%>
                        <c:choose>
                            <c:when test="${sessionScope.user != null}">
                                <span class="welcome-message">Xin chào, <strong>${sessionScope.user.username}</strong>!</span>
                                <a href="#" class="btn btn-login">Đăng Xuất</a>
                            </c:when>
                            <c:otherwise>
                                <a href="#" class="btn btn-register">Đăng Ký</a>
                                <a href="#" class="btn btn-login">Đăng Nhập</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>  

                <nav class="navbar">
                    <a href="#" class="nav-item active">
                        <i class="fa-solid fa-house"></i> Trang chủ
                    </a>
                     <a href="#" class="nav-item"> <%-- Added About link --%>
                        <i class="fa-solid fa-circle-info"></i> Giới thiệu
                    </a>

                    <%-- Dynamic Lecture Menu --%>
                    <div class="dropdown nav-item">
                        <span><i class="fa-solid fa-book-open-reader"></i> Bài giảng</span>
                        <div class="dropdown-menu">
                            <c:forEach var="grade" items="${lectureMenu}">
                                <div class="dropdown-item has-submenu">
                                    ${grade.key} <%-- e.g., "Lớp 6" --%>
                                    <div class="submenu">
                                        <c:forEach var="subject" items="${grade.value}">
                                            <a href="#" class="submenu-item">${subject}</a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <%-- Example: Dynamic Review Menu (if you add data in servlet) --%>
                    <%--
                    <div class="dropdown nav-item">
                        <span><i class="fa-solid fa-list-check"></i> Ôn tập</span>
                        <div class="dropdown-menu">
                             <c:forEach var="grade" items="${reviewMenu}"> ... </c:forEach>
                        </div>
                    </div>
                     --%>

                    <div class="dropdown nav-item">
                        <span><i class="fa-solid fa-pen-to-square"></i> Kiểm tra</span>
                        <div class="dropdown-menu">
                            <div class="dropdown-item has-submenu">
                                Lớp 6
                                <div class="submenu">
                                    <a href="<c:url value='/quiz?grade=6&type=midterm1' />" class="submenu-item">Giữa kỳ 1</a>
                                    <a href="<c:url value='/quiz?grade=6&type=final1' />" class="submenu-item">Cuối kỳ 1</a>
                                    <%-- Add links for other terms/grades --%>
                                </div>
                            </div>
                             <div class="dropdown-item has-submenu">
                                Lớp 7
                                <div class="submenu">
                                    <a href="<c:url value='/quiz?grade=7&type=midterm1' />" class="submenu-item">Giữa kỳ 1</a>
                                     <%-- Add more --%>
                                </div>
                            </div>
                             <%-- Add more grades --%>
                        </div>
                    </div>

                    <a href="#" class="nav-item"> <%-- Added Contact link --%>
                        <i class="fa-solid fa-phone-volume"></i> Liên hệ
                    </a>
                </nav>
            </div>
        </div>
    </div>
</header>