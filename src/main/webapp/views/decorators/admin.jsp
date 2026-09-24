<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'>Quản Trị Hệ Thống - WebVideo</sitemesh:write></title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Admin Custom CSS -->
    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f1f2f6;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .admin-navbar {
            background: #2f3542;
            box-shadow: 0 2px 10px rgba(0,0,0,0.15);
        }
        .sidebar {
            background: #2f3542;
            min-height: calc(100vh - 140px);
            color: #dfe4ea;
        }
        .sidebar .nav-link {
            color: #ced6e0;
            padding: 12px 18px;
            font-weight: 500;
            border-radius: 6px;
            margin: 4px 10px;
            transition: all 0.2s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: #ff4757;
            color: #ffffff;
        }
        .admin-content {
            flex: 1;
            padding: 25px;
        }
        .footer-custom {
            background: #1e272e;
            color: #d2dae2;
            padding: 20px 0;
            border-top: 3px solid #ff4757;
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

    <!-- Admin Header -->
    <nav class="navbar navbar-expand-lg navbar-dark admin-navbar sticky-top">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/videos">
                <i class="fa-solid fa-shield-halved text-danger me-2"></i>TRANG QUẢN TRỊ ADMIN
            </a>
            <div class="ms-auto d-flex align-items-center">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light btn-sm me-3">
                    <i class="fa-solid fa-house me-1"></i> Xem Trang Chủ
                </a>
                <span class="text-light me-3 d-none d-md-inline">
                    Xin chào, <strong>${sessionScope.account.fullname}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm">
                    <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
                </a>
            </div>
        </div>
    </nav>

    <!-- Admin Layout with Sidebar -->
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block sidebar py-3 collapse show" id="sidebarMenu">
                <div class="position-sticky">
                    <div class="text-center mb-4 px-2">
                        <img src="${empty sessionScope.account.images ? 'https://picsum.photos/100' : sessionScope.account.images}" 
                             class="rounded-circle border border-2 border-danger mb-2" width="64" height="64" alt="admin">
                        <h6 class="mb-0 text-white">${sessionScope.account.fullname}</h6>
                        <span class="badge bg-danger mt-1">Administrator</span>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link ${pageContext.request.requestURI.endsWith('/videos') ? 'active' : ''}" 
                               href="${pageContext.request.contextPath}/admin/videos">
                                <i class="fa-solid fa-video me-2"></i> Quản lý Videos
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${pageContext.request.requestURI.endsWith('/add') ? 'active' : ''}" 
                               href="${pageContext.request.contextPath}/admin/video/add">
                                <i class="fa-solid fa-plus-circle me-2"></i> Thêm Video Mới
                            </a>
                        </li>
                        <hr class="text-secondary mx-3">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/home">
                                <i class="fa-solid fa-globe me-2"></i> Về Giao Diện Web
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content Area -->
            <main class="col-md-9 ms-sm-auto col-lg-10 admin-content">
                <sitemesh:write property='body'/>
            </main>
        </div>
    </div>

    <!-- Footer cố định theo Câu 1: Họ tên, MSSV, Mã đề -->
    <footer class="footer-custom mt-auto">
        <div class="container text-center">
            <div class="row align-items-center">
                <div class="col-md-6 text-md-start mb-2 mb-md-0">
                    <p class="footer-info mb-1">
                        <i class="fa-solid fa-user-gear me-2 text-danger"></i>
                        Họ tên: <strong>Trịnh Văn Phú Hào</strong> | MSSV: <strong>24110013</strong>
                    </p>
                    <small class="text-secondary">Trang Quản Trị Hệ Thống | Môn Lập Trình Web</small>
                </div>
                <div class="col-md-6 text-md-end">
                    <span class="badge-exam">
                        <i class="fa-solid fa-code me-1"></i> Mã đề: <strong>03</strong>
                    </span>
                    <span class="badge bg-secondary ms-2">Admin Dashboard</span>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
