<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Thực Mã OTP - WebVideo - Trịnh Văn Phú Hào (24110013)</title>
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
        .otp-card {
            max-width: 460px;
            width: 100%;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.25);
            overflow: hidden;
        }
        .otp-header {
            background: #1e272e;
            color: #ffffff;
            padding: 25px 20px;
            text-align: center;
        }
        .otp-body {
            padding: 30px;
        }
        .otp-input {
            letter-spacing: 8px;
            font-size: 24px;
            text-align: center;
            font-weight: 700;
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

<div class="otp-card">
    <div class="otp-header">
        <h4 class="mb-1"><i class="fa-solid fa-key text-warning me-2"></i>XÁC THỰC MÃ OTP</h4>
        <small class="text-secondary">Kích hoạt tài khoản mới đăng ký</small>
    </div>

    <div class="otp-body">
        <div class="alert alert-info text-center" role="alert">
            <i class="fa-solid fa-envelope-circle-check fa-2x mb-2 d-block text-primary"></i>
            <div>Mã OTP gồm 6 chữ số đã được gửi đến email:</div>
            <strong class="text-dark">${sessionScope.pending_user.email}</strong>
            <div class="small text-muted mt-1">(Vui lòng kiểm tra hòm thư đến hoặc mục Spam)</div>
        </div>

        <c:if test="${not empty sessionScope.otpOfflineNotice}">
            <div class="alert alert-warning text-center" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-1"></i> ${sessionScope.otpOfflineNotice}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-exclamation me-1"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/verify-otp" method="post">
            <div class="mb-4">
                <label for="otp" class="form-label fw-semibold text-center w-100">Nhập mã OTP 6 chữ số</label>
                <input type="text" class="form-control otp-input" id="otp" name="otp" 
                       maxlength="6" placeholder="000000" pattern="[0-9]{6}" required autofocus>
                <div class="form-text text-center text-muted mt-2">
                    Mã có hiệu lực trong vòng 5 phút
                </div>
            </div>

            <button type="submit" class="btn btn-success w-100 py-2 fw-semibold mb-3">
                <i class="fa-solid fa-check-circle me-1"></i> Kích Hoạt Tài Khoản
            </button>

            <div class="text-center">
                <a href="${pageContext.request.contextPath}/register" class="text-muted small">
                    <i class="fa-solid fa-arrow-rotate-left me-1"></i> Đăng ký lại bằng thông tin khác
                </a>
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
