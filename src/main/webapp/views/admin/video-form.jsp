<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${isEdit ? 'Chỉnh Sửa Video' : 'Thêm Video Mới'} - Admin (Đề 03)</title>
    <style>
        .form-card {
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
            padding: 30px;
            max-width: 800px;
            margin: auto;
        }
    </style>
</head>
<body>

<div class="form-card">
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
        <h4 class="fw-bold mb-0 text-dark">
            <i class="fa-solid ${isEdit ? 'fa-pen-to-square text-primary' : 'fa-plus-circle text-danger'} me-2"></i>
            ${isEdit ? 'CHỈNH SỬA THÔNG TIN VIDEO' : 'THÊM MỚI VIDEO'}
        </h4>
        <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-outline-secondary btn-sm">
            <i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-exclamation me-1"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/video/${isEdit ? 'edit' : 'add'}" method="post">
        <div class="row g-3">
            <div class="col-md-6">
                <label for="videoId" class="form-label fw-semibold">Mã Video <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="videoId" name="videoId" 
                       value="${video.videoId}" ${isEdit ? 'readonly' : 'required'} 
                       placeholder="Ví dụ: V012">
                <c:if test="${isEdit}">
                    <div class="form-text text-muted">Mã video là khóa chính không thể thay đổi.</div>
                </c:if>
            </div>

            <div class="col-md-6">
                <label for="categoryId" class="form-label fw-semibold">Chuyên Mục <span class="text-danger">*</span></label>
                <select class="form-select" id="categoryId" name="categoryId" required>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.categoryId}" ${video.category.categoryId == c.categoryId ? 'selected' : ''}>
                            ${c.categoryname} (${c.categorycode})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-12">
                <label for="title" class="form-label fw-semibold">Tiêu đề Video <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="title" name="title" 
                       value="${video.title}" placeholder="Nhập tiêu đề video" required>
            </div>

            <div class="col-md-8">
                <label for="poster" class="form-label fw-semibold">URL Poster (Hình ảnh)</label>
                <input type="text" class="form-control" id="poster" name="poster" 
                       value="${video.poster}" placeholder="https://picsum.photos/400/250?random=123">
            </div>

            <div class="col-md-4">
                <label for="views" class="form-label fw-semibold">Lượt xem ban đầu</label>
                <input type="number" class="form-control" id="views" name="views" 
                       value="${video.views != null ? video.views : 0}" min="0">
            </div>

            <div class="col-12">
                <label for="description" class="form-label fw-semibold">Mô tả video</label>
                <textarea class="form-control" id="description" name="description" rows="4" 
                          placeholder="Nhập thông tin mô tả chi tiết cho video...">${video.description}</textarea>
            </div>

            <div class="col-12">
                <div class="form-check form-switch mt-2">
                    <input class="form-check-input" type="checkbox" id="active" name="active" 
                           ${video.active || !isEdit ? 'checked' : ''}>
                    <label class="form-check-label fw-semibold" for="active">Kích hoạt hiển thị (Active)</label>
                </div>
            </div>

            <div class="col-12 mt-4 pt-3 border-top d-flex gap-2">
                <button type="submit" class="btn btn-primary px-4">
                    <i class="fa-solid fa-floppy-disk me-1"></i> Lưu thông tin
                </button>
                <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-secondary px-4">
                    Hủy bỏ
                </a>
            </div>
        </div>
    </form>
</div>

</body>
</html>
