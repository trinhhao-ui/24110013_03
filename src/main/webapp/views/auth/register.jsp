<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản - WebVideo (Đề 03)</title>
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
            padding: 30px 15px;
        }
        .register-card {
            max-width: 520px;
            width: 100%;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.25);
            overflow: hidden;
        }
        .register-header {
            background: #1e272e;
            color: #ffffff;
            padding: 25px 20px;
            text-align: center;
        }
        .register-body {
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

<div class="register-card">
    <div class="register-header">
        <h4 class="mb-1"><i class="fa-solid fa-user-plus text-danger me-2"></i>ĐĂNG KÝ TÀI KHOẢN</h4>
        <small class="text-secondary">Hệ thống kích hoạt bằng mã OTP qua Email</small>
    </div>

    <div class="register-body">
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-exclamation me-1"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="mb-3">
                <label for="username" class="form-label fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="fullname" class="form-label fw-semibold">Họ và tên</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-id-card"></i></span>
                    <input type="text" class="form-control" id="fullname" name="fullname" placeholder="Ví dụ: Nguyễn Văn A">
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label fw-semibold">Email nhận OTP <span class="text-danger">*</span></label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                    <input type="email" class="form-control" id="email" name="email" placeholder="example@domain.com" required>
                </div>
                <div class="form-text text-muted">
                    <i class="fa-solid fa-info-circle me-1"></i> Mã OTP 6 chữ số sẽ được gửi tới địa chỉ này để kích hoạt.
                </div>
            </div>

            <div class="mb-3">
                <label for="phone" class="form-label fw-semibold">Số điện thoại</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                    <input type="text" class="form-control" id="phone" name="phone" placeholder="0901234567">
                </div>
            </div>

            <div class="mb-4">
                <label for="images" class="form-label fw-semibold">URL Ảnh đại diện</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-image"></i></span>
                    <input type="url" class="form-control" id="images" name="images" placeholder="https://picsum.photos/200">
                </div>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold mb-3">
                <i class="fa-solid fa-paper-plane me-1"></i> Tiếp tục & Nhận mã OTP
            </button>

            <div class="text-center">
                <span class="text-muted">Đã có tài khoản?</span>
                <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-decoration-none">Đăng nhập</a>
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
