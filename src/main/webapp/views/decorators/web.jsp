<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'>WebVideo - Trịnh Văn Phú Hào</sitemesh:write></title>
    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,&lt;svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'&gt;&lt;circle cx='50' cy='50' r='50' fill='%23ff4757'/&gt;&lt;polygon points='40,30 40,70 75,50' fill='%23ffffff'/&gt;&lt;/svg&gt;">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Custom CSS -->
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            --accent-color: #ff4757;
        }
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f8f9fc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar-custom {
            background: var(--primary-gradient);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .navbar-brand {
            font-weight: 700;
            letter-spacing: 0.5px;
            font-size: 1.35rem;
        }
        .nav-link {
            font-weight: 500;
            color: rgba(255, 255, 255, 0.9) !important;
            transition: all 0.2s ease;
            margin: 0 4px;
            padding: 8px 14px !important;
            border-radius: 6px;
        }
        .nav-link:hover {
            color: #fff !important;
            background: rgba(255, 255, 255, 0.15);
        }
        .nav-link.active {
            background: rgba(255, 255, 255, 0.25);
            color: #fff !important;
        }
        .admin-badge {
            background-color: #ffd32a;
            color: #1e272e;
            font-weight: 600;
        }
        main {
            flex: 1;
            padding-top: 25px;
            padding-bottom: 40px;
        }
        .footer-custom {
            background: #1e272e;
            color: #d2dae2;
            padding: 24px 0;
            border-top: 3px solid #2a5298;
        }
        .footer-info {
            font-size: 1.05rem;
            font-weight: 600;
            color: #f1f2f6;
        }
        .badge-exam {
            background: #ff4757;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.9rem;
        }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>

    <!-- Header Navigation (Câu 1: Trang Chủ, Sản phẩm, Đăng nhập, Trang quản trị (admin)) -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
                <i class="fa-solid fa-play-circle text-danger me-2"></i>WebVideo
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarMain">
                <ul class="navbar-nav ms-auto align-items-center mb-2 mb-lg-0">
                    <!-- 1. Trang Chủ -->
                    <li class="nav-item">
                        <a class="nav-link px-3 ${empty pageContext.request.servletPath or pageContext.request.servletPath eq '/home' or pageContext.request.servletPath eq '/' ? 'active' : ''}" href="${pageContext.request.contextPath}/home">
                            <i class="fa-solid fa-house me-1"></i> Trang Chủ
                        </a>
                    </li>

                    <!-- 2. Sản phẩm -->
                    <li class="nav-item">
                        <a class="nav-link px-3 ${pageContext.request.servletPath eq '/home' ? 'active' : ''}" href="${pageContext.request.contextPath}/home">
                            <i class="fa-solid fa-film me-1"></i> Sản phẩm
                        </a>
                    </li>

                    <!-- Giỏ hàng -->
                    <li class="nav-item">
                        <a class="nav-link px-3 position-relative ${pageContext.request.servletPath eq '/cart' or pageContext.request.servletPath eq '/checkout' ? 'active' : ''}" href="${pageContext.request.contextPath}/cart">
                            <i class="fa-solid fa-cart-shopping me-1"></i> Giỏ hàng
                            <c:if test="${not empty sessionScope.cart and sessionScope.cart.totalQuantity > 0}">
                                <span class="badge rounded-pill bg-danger ms-1">
                                    ${sessionScope.cart.totalQuantity}
                                </span>
                            </c:if>
                        </a>
                    </li>

                    <!-- Tra cứu đơn hàng -->
                    <li class="nav-item">
                        <a class="nav-link px-3 ${pageContext.request.servletPath eq '/my-orders' or pageContext.request.servletPath eq '/order-detail' or pageContext.request.servletPath eq '/order-success' ? 'active' : ''}" href="${pageContext.request.contextPath}/my-orders">
                            <i class="fa-solid fa-truck-fast me-1"></i> Đơn hàng
                        </a>
                    </li>

                    <!-- 3. Đăng nhập / Đăng xuất -->
                    <c:choose>
                        <c:when test="${empty sessionScope.account}">
                            <li class="nav-item">
                                <a class="nav-link px-3" href="${pageContext.request.contextPath}/login">
                                    <i class="fa-solid fa-arrow-right-to-bracket me-1"></i> Đăng nhập
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle px-3 d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="fa-solid fa-circle-user me-1 text-warning"></i> ${sessionScope.account.fullname}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end shadow">
                                    <li class="dropdown-item-text text-muted small">@${sessionScope.account.username} (${sessionScope.account.admin ? 'Admin' : 'User'})</li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/my-orders">
                                            <i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i> Lịch sử đơn hàng
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/cart">
                                            <i class="fa-solid fa-cart-shopping me-2 text-success"></i> Xem giỏ hàng
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                            <i class="fa-solid fa-right-from-bracket me-2"></i> Đăng xuất
                                        </a>
                                    </li>
                                </ul>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <!-- 4. Trang quản trị (admin mới có chức năng này) -->
                    <li class="nav-item">
                        <c:choose>
                            <c:when test="${not empty sessionScope.account and sessionScope.account.admin}">
                                <a class="nav-link admin-badge rounded px-3 ms-lg-2" href="${pageContext.request.contextPath}/admin/videos">
                                    <i class="fa-solid fa-screwdriver-wrench me-1"></i> Trang quản trị
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a class="nav-link px-3 text-warning-emphasis" href="${pageContext.request.contextPath}/admin/videos" 
                                   title="Chỉ Admin mới có chức năng này">
                                    <i class="fa-solid fa-shield-halved me-1"></i> Trang quản trị <small class="text-warning">(Admin)</small>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main>
        <sitemesh:write property='body'/>
    </main>

    <!-- Footer cố định theo Câu 1: Họ tên, MSSV, Mã đề -->
    <footer class="footer-custom">
        <div class="container text-center">
            <div class="row align-items-center">
                <div class="col-md-6 text-md-start mb-2 mb-md-0">
                    <p class="footer-info mb-1">
                        <i class="fa-solid fa-user-graduate me-2 text-warning"></i>
                        Họ tên: <strong>Trịnh Văn Phú Hào</strong> | MSSV: <strong>24110013</strong> | Mã đề: <strong>03</strong>
                    </p>
                    <small class="text-secondary">Đề thi Quá trình – HK1 – 2026-2027 | Môn Lập Trình Web (Jakarta EE + JPA + Tomcat 10)</small>
                </div>
                <div class="col-md-6 text-md-end">
                    <span class="badge-exam">
                        <i class="fa-solid fa-code me-1"></i> Mã đề: <strong>03</strong>
                    </span>
                    <span class="badge bg-secondary ms-2">Servlet + JPA + JSP</span>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
