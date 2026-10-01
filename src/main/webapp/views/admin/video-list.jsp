<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Lý Videos - Admin (Đề 03)</title>
    <style>
        .admin-card {
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
            padding: 25px;
        }
        .poster-thumb {
            width: 80px;
            height: 48px;
            object-fit: cover;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

<div class="admin-card">
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
        <div>
            <h4 class="fw-bold mb-1 text-dark">
                <i class="fa-solid fa-list-check text-danger me-2"></i>QUẢN LÝ DANH SÁCH VIDEOS
            </h4>
            <span class="text-muted small">
                Yêu cầu Câu 2: Phân trang <strong>6 video trên 01 trang</strong> (Tổng số: <strong>${totalVideos}</strong> videos)
            </span>
        </div>
        <a href="${pageContext.request.contextPath}/admin/video/add" class="btn btn-danger btn-sm px-3">
            <i class="fa-solid fa-plus-circle me-1"></i> Thêm Video Mới
        </a>
    </div>

    <!-- Thông báo kết quả thao tác CRUD -->
    <c:if test="${param.msg == 'added'}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-check-circle me-1"></i> Thêm video mới thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.msg == 'updated'}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-info-circle me-1"></i> Cập nhật thông tin video thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.msg == 'deleted'}">
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-trash-can me-1"></i> Xóa video thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Bảng dữ liệu Videos -->
    <div class="table-responsive">
        <table class="table table-hover table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th scope="col" style="width: 100px;">Mã Video</th>
                    <th scope="col" style="width: 100px;">Poster</th>
                    <th scope="col">Tiêu đề</th>
                    <th scope="col" style="width: 150px;">Chuyên mục</th>
                    <th scope="col" style="width: 110px;" class="text-end">Giá bán</th>
                    <th scope="col" style="width: 90px;" class="text-center">Tồn kho</th>
                    <th scope="col" style="width: 90px;" class="text-center">Lượt xem</th>
                    <th scope="col" style="width: 100px;" class="text-center">Trạng thái</th>
                    <th scope="col" style="width: 140px;" class="text-center">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty videos}">
                        <tr>
                            <td colspan="9" class="text-center text-muted py-4">Chưa có video nào.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="v" items="${videos}">
                            <tr>
                                <td><code>${v.videoId}</code></td>
                                <td class="text-center">
                                    <img src="${v.poster}" alt="${v.title}" class="poster-thumb" onerror="this.src='https://picsum.photos/80/48'">
                                </td>
                                <td>
                                    <strong>${v.title}</strong>
                                    <div class="text-muted small text-truncate" style="max-width: 300px;">
                                        ${v.description}
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border">
                                        ${v.category.categoryname}
                                    </span>
                                </td>
                                <td class="text-end fw-bold text-danger">
                                    <fmt:formatNumber value="${v.price}" pattern="#,##0"/> ₫
                                </td>
                                <td class="text-center">
                                    <span class="badge ${v.quantity > 0 ? 'bg-success' : 'bg-danger'}">
                                        ${v.quantity}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-secondary">${v.views}</span>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${v.active}">
                                            <span class="badge bg-success">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Khóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/admin/video/edit?id=${v.videoId}" 
                                       class="btn btn-outline-primary btn-sm me-1" title="Chỉnh sửa">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/video/delete?id=${v.videoId}" 
                                       class="btn btn-outline-danger btn-sm" 
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa video này? (Dữ liệu liên quan như Like, Share sẽ tự động xóa theo)');" 
                                       title="Xóa">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Phân trang 6 video / 01 trang theo Câu 2 -->
    <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap">
            <span class="text-muted small">
                Hiển thị trang <strong>${currentPage}</strong> trên tổng số <strong>${totalPages}</strong> trang (Mỗi trang 6 video)
            </span>
            <nav aria-label="Admin Page navigation">
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/videos?page=${currentPage - 1}">
                            &laquo; Trước
                        </a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/videos?page=${i}">
                                ${i}
                            </a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/videos?page=${currentPage + 1}">
                            Sau &raquo;
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

</body>
</html>
