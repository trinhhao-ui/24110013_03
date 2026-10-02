<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - WebVideo - Trịnh Văn Phú Hào (24110013)</title>
    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,&lt;svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'&gt;&lt;circle cx='50' cy='50' r='50' fill='%23ff4757'/&gt;&lt;polygon points='40,30 40,70 75,50' fill='%23ffffff'/&gt;&lt;/svg&gt;">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }
        .login-card {
            max-width: 450px;
            width: 100%;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.25);
            overflow: hidden;
        }
        .login-header {
            background: #1e272e;
            color: #ffffff;
            padding: 25px 20px;
            text-align: center;
        }
        .login-body {
            padding: 30px;
        }
        .student-tag {
            background: #f1f2f6;
            border-top: 1px solid #e1e2e6;
            padding: 12px;
            font-size: 0.85rem;
            text-align: center;
            color: #57606f;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="login-header">
        <h4 class="mb-1"><i class="fa-solid fa-play-circle text-danger me-2"></i>WebVideo</h4>
        <small class="text-secondary">ĐĂNG NHẬP HỆ THỐNG</small>
    </div>

    <div class="login-body">
        <!-- Thông báo thành công -->
        <c:if test="${param.msg == 'activated'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-check-circle me-1"></i> Tài khoản của bạn đã được kích hoạt thành công! Hãy đăng nhập.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'logged_out'}">
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-info-circle me-1"></i> Bạn đã đăng xuất thành công.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>


        <!-- Thông báo lỗi -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-exclamation me-1"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.error == 'access_denied'}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-ban me-1"></i> Bạn không có quyền truy cập trang quản trị Admin!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.error == 'not_logged_in'}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-lock me-1"></i> Vui lòng đăng nhập để tiếp tục!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <c:if test="${not empty param.redirect}">
                <input type="hidden" name="redirect" value="${param.redirect}">
            </c:if>
            <div class="mb-3">
                <label for="username" class="form-label fw-semibold">Tên đăng nhập</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Nhập username" required autofocus>
                </div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label fw-semibold">Mật khẩu</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold mb-3">
                <i class="fa-solid fa-arrow-right-to-bracket me-1"></i> Đăng Nhập
            </button>

            <div class="text-center">
                <span class="text-muted">Chưa có tài khoản?</span>
                <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-decoration-none">Đăng ký ngay</a>
                <div class="mt-2">
                    <a href="${pageContext.request.contextPath}/home" class="text-muted small">
                        <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Trang Chủ
                    </a>
                </div>
            </div>
        </form>
    </div>

    <div class="student-tag">
        Họ tên: <strong>Trịnh Văn Phú Hào</strong> | MSSV: <strong>24110013</strong> | Mã đề: <strong>03</strong>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
