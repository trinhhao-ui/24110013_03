<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${video.title} - Chi Tiết Video (Đề 03)</title>
    <style>
        .detail-box {
            background: #ffffff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        .poster-frame {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            background: #000;
        }
        .poster-frame img {
            width: 100%;
            height: auto;
            max-height: 400px;
            object-fit: cover;
            display: block;
        }
        .detail-meta-label {
            font-weight: 600;
            color: #4b6584;
            min-width: 140px;
            display: inline-block;
        }
        .detail-meta-value {
            font-size: 1.1rem;
            color: #2f3542;
            font-weight: 500;
        }
        .description-box {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            border-left: 4px solid #0d6efd;
            margin-top: 25px;
        }
        .stats-badge-like {
            background: #ffeaa7;
            color: #d63031;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
        }
        .stats-badge-share {
            background: #dff9fb;
            color: #0984e3;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
        }
    </style>
</head>
<body>

<div class="container">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home#cat-${video.category.categoryId}">${video.category.categoryname}</a></li>
            <li class="breadcrumb-item active" aria-current="page">${video.title}</li>
        </ol>
    </nav>

    <!-- Hộp chi tiết Video đúng theo khuôn mẫu Câu 3 -->
    <div class="detail-box">
        <div class="row g-4 align-items-center">
            <!-- Cột trái: [poster] -->
            <div class="col-md-5">
                <div class="poster-frame">
                    <img src="${video.poster}" alt="${video.title}" onerror="this.src='https://picsum.photos/500/350?random=100'">
                </div>
            </div>

            <!-- Cột phải: Thông tin theo mẫu -->
            <div class="col-md-7">
                <div class="mb-3">
                    <span class="detail-meta-label">Tiêu đề:</span>
                    <span class="detail-meta-value fw-bold text-dark fs-4">${video.title}</span>
                </div>

                <div class="mb-3">
                    <span class="detail-meta-label">Mã video:</span>
                    <span class="detail-meta-value"><code>${video.videoId}</code></span>
                </div>

                <div class="mb-3">
                    <span class="detail-meta-label">Category name:</span>
                    <span class="detail-meta-value text-primary">${video.category.categoryname}</span>
                </div>

                <div class="mb-3">
                    <span class="detail-meta-label">Giá bán:</span>
                    <span class="detail-meta-value text-danger fw-bold fs-4">
                        <fmt:formatNumber value="${video.price}" pattern="#,##0"/> ₫
                    </span>
                </div>

                <div class="mb-3">
                    <span class="detail-meta-label">Tồn kho:</span>
                    <span class="detail-meta-value">
                        <c:choose>
                            <c:when test="${video.quantity > 0}">
                                <span class="badge bg-success fs-6">${video.quantity} sản phẩm có sẵn</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger fs-6">Đã hết hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="mb-3">
                    <span class="detail-meta-label">Lượt xem:</span>
                    <span class="detail-meta-value badge bg-secondary fs-6">${video.views}</span>
                </div>

                <!-- Form Thêm Vào Giỏ Hàng & Mua Ngay COD -->
                <div class="card p-3 bg-light border-0 rounded-3 my-4">
                    <form action="${pageContext.request.contextPath}/cart/add" method="post">
                        <input type="hidden" name="videoId" value="${video.videoId}">
                        <div class="row align-items-center g-3">
                            <div class="col-auto">
                                <label for="quantityInput" class="fw-semibold text-secondary">Số lượng:</label>
                            </div>
                            <div class="col-auto">
                                <input type="number" id="quantityInput" name="quantity" value="1" min="1" max="${video.quantity}" 
                                       class="form-control" style="width: 90px; text-align: center; font-weight: bold;" 
                                       ${video.quantity <= 0 ? 'disabled' : ''}>
                            </div>
                            <div class="col-auto">
                                <span class="text-muted small">(Tối đa ${video.quantity} sản phẩm)</span>
                            </div>
                        </div>

                        <div class="d-flex gap-2 mt-3 flex-wrap">
                            <button type="submit" class="btn btn-outline-danger px-4 py-2 fw-semibold" ${video.quantity <= 0 ? 'disabled' : ''}>
                                <i class="fa-solid fa-cart-plus me-2"></i>Thêm Vào Giỏ Hàng
                            </button>
                            <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-primary px-3 py-2">
                                <i class="fa-solid fa-cart-shopping me-1"></i>Xem Giỏ Hàng
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Thống kê & Nút Share(10), Like(10) theo yêu cầu -->
                <div class="d-flex align-items-center gap-3 mt-4 flex-wrap">
                    <!-- Share(count) -->
                    <span class="stats-badge-share">
                        <i class="fa-solid fa-share-nodes me-2"></i> Share(${shareCount})
                    </span>

                    <!-- Like(count) -->
                    <span class="stats-badge-like">
                        <i class="fa-solid fa-heart me-2"></i> Like(${likeCount})
                    </span>

                    <!-- Tương tác Like -->
                    <form action="${pageContext.request.contextPath}/video-detail" method="post" class="d-inline">
                        <input type="hidden" name="action" value="like">
                        <input type="hidden" name="videoId" value="${video.videoId}">
                        <button type="submit" class="btn ${isLiked ? 'btn-danger' : 'btn-outline-danger'} btn-sm">
                            <i class="fa-solid fa-heart me-1"></i> ${isLiked ? 'Đã Thích' : 'Yêu Thích'}
                        </button>
                    </form>

                    <!-- Nút Mở Modal Chia Sẻ -->
                    <button type="button" class="btn btn-outline-primary btn-sm" data-bs-toggle="modal" data-bs-target="#shareModal">
                        <i class="fa-solid fa-paper-plane me-1"></i> Chia sẻ Video
                    </button>
                </div>
            </div>
        </div>

        <!-- Khối dưới: description -->
        <div class="description-box">
            <h5 class="fw-bold mb-2 text-dark"><i class="fa-solid fa-align-left me-2 text-primary"></i>Mô tả video:</h5>
            <p class="mb-0 text-secondary" style="font-size: 1.05rem; line-height: 1.6;">
                ${empty video.description ? 'Chưa có thông tin mô tả chi tiết cho video này.' : video.description}
            </p>
        </div>
    </div>
</div>

<!-- Modal Chia Sẻ Video -->
<div class="modal fade" id="shareModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/video-detail" method="post">
                <input type="hidden" name="action" value="share">
                <input type="hidden" name="videoId" value="${video.videoId}">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fa-solid fa-share-nodes text-primary me-2"></i>Chia Sẻ Video</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <c:choose>
                        <c:when test="${empty sessionScope.account}">
                            <div class="alert alert-warning">
                                <i class="fa-solid fa-triangle-exclamation me-1"></i> Vui lòng <a href="${pageContext.request.contextPath}/login" class="alert-link">Đăng nhập</a> để chia sẻ video này tới bạn bè!
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="small text-muted">Chia sẻ video <strong>${video.title}</strong> đến địa chỉ email:</p>
                            <div class="mb-3">
                                <label for="emailShare" class="form-label fw-semibold">Email người nhận</label>
                                <input type="email" class="form-control" id="emailShare" name="emailShare" placeholder="friend@example.com" required>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Đóng</button>
                    <c:if test="${not empty sessionScope.account}">
                        <button type="submit" class="btn btn-primary btn-sm">Gửi chia sẻ</button>
                    </c:if>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
