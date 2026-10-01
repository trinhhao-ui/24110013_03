<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thanh Toán Đơn Hàng (COD) - WebVideo</title>
    <style>
        .checkout-box {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.06);
            border: 1px solid #e2e8f0;
            padding: 24px;
        }
        .cod-badge {
            background-color: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #c8e6c9;
            padding: 12px;
            border-radius: 8px;
        }
        .order-item-img {
            width: 50px;
            height: 35px;
            object-fit: cover;
            border-radius: 4px;
        }
    </style>
</head>
<body>

<div class="container py-4">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a></li>
            <li class="breadcrumb-item active" aria-current="page">Thanh toán COD</li>
        </ol>
    </nav>

    <h3 class="fw-bold mb-4 text-dark">
        <i class="fa-solid fa-money-bill-transfer text-success me-2"></i>Thanh Toán Đơn Hàng COD (Cash On Delivery)
    </h3>

    <!-- Báo lỗi nếu có -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Gợi ý đăng nhập nếu chưa đăng nhập -->
    <c:if test="${empty sessionScope.account}">
        <div class="alert alert-info border-info d-flex align-items-center mb-4 rounded-3 p-3">
            <i class="fa-solid fa-circle-info fs-3 text-info me-3"></i>
            <div>
                <strong class="d-block mb-1">Gợi ý dành cho bạn:</strong>
                <small class="text-secondary">
                    Bạn chưa đăng nhập tài khoản. Bạn có thể <a href="${pageContext.request.contextPath}/login" class="fw-bold text-primary">Đăng nhập tại đây</a> để đơn hàng tự động lưu vào tài khoản cá nhân, hoặc tiếp tục điền thông tin bên dưới để mua hàng nhanh (hệ thống sẽ tự động liên kết đơn hàng vào tài khoản nếu Số điện thoại trùng khớp).
                </small>
            </div>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/checkout" method="post">
        <div class="row g-4">

            <!-- Cột trái: Thông tin nhận hàng & Phương thức thanh toán -->
            <div class="col-lg-7">
                <!-- Thông tin nhận hàng -->
                <div class="checkout-box mb-4">
                    <h5 class="fw-bold text-dark border-bottom pb-2 mb-3">
                        <i class="fa-solid fa-location-dot text-danger me-2"></i>1. Thông Tin Nhận Hàng
                    </h5>

                    <div class="mb-3">
                        <label for="recipientName" class="form-label fw-semibold">Họ và tên người nhận <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="recipientName" name="recipientName" 
                               value="${not empty param.recipientName ? param.recipientName : defaultName}" 
                               placeholder="Ví dụ: Nguyễn Văn A" required>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label fw-semibold">Số điện thoại nhận hàng <span class="text-danger">*</span></label>
                        <input type="tel" class="form-control" id="phone" name="phone" 
                               value="${not empty param.phone ? param.phone : defaultPhone}" 
                               placeholder="Ví dụ: 0901234567" pattern="[0-9]{10,11}" required>
                        <small class="text-muted">Nhân viên shipper sẽ liên hệ số này để giao hàng và thu tiền COD.</small>
                    </div>

                    <div class="mb-3">
                        <label for="address" class="form-label fw-semibold">Địa chỉ giao hàng chi tiết <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="address" name="address" rows="3" 
                                  placeholder="Số nhà, Tên đường, Phường/Xã, Quận/Huyện, Tỉnh/Thành phố..." required>${param.address}</textarea>
                    </div>

                    <div class="mb-3">
                        <label for="note" class="form-label fw-semibold">Ghi chú đơn hàng (tùy chọn)</label>
                        <input type="text" class="form-control" id="note" name="note" 
                               value="${param.note}" placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi đến...">
                    </div>
                </div>

                <!-- Phương thức thanh toán COD -->
                <div class="checkout-box">
                    <h5 class="fw-bold text-dark border-bottom pb-2 mb-3">
                        <i class="fa-solid fa-credit-card text-primary me-2"></i>2. Phương Thức Thanh Toán
                    </h5>

                    <div class="cod-badge mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="paymentCOD" value="COD" checked>
                            <label class="form-check-label fw-bold" for="paymentCOD">
                                <i class="fa-solid fa-truck-ramp-box text-success me-2"></i>Thanh toán tiền mặt khi nhận hàng (COD)
                            </label>
                        </div>
                        <p class="mb-0 mt-2 small text-secondary ps-4">
                            ✅ Kiểm tra hàng trước khi thanh toán.<br>
                            ✅ Thanh toán đúng số tiền đơn hàng cho shipper khi nhận được bưu kiện tận nơi.<br>
                            ✅ <strong>Hóa đơn bán hàng hợp lệ</strong> sẽ được tự động phát hành ngay sau khi giao hàng thành công &amp; thu tiền COD hoàn tất.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Cột phải: Tóm tắt đơn hàng & Xác nhận đặt hàng -->
            <div class="col-lg-5">
                <div class="checkout-box sticky-top" style="top: 85px;">
                    <h5 class="fw-bold text-dark border-bottom pb-2 mb-3">
                        <i class="fa-solid fa-clipboard-check text-primary me-2"></i>Tóm Tắt Đơn Hàng (${cart.totalQuantity} món)
                    </h5>

                    <!-- Danh sách món -->
                    <div class="order-items-list mb-3" style="max-height: 260px; overflow-y: auto;">
                        <c:forEach var="item" items="${cart.items}">
                            <div class="d-flex align-items-center justify-content-between mb-3 border-bottom pb-2">
                                <div class="d-flex align-items-center">
                                    <img src="${item.video.poster}" alt="${item.video.title}" class="order-item-img me-2" onerror="this.src='https://picsum.photos/50/35?random=1'">
                                    <div>
                                        <div class="fw-semibold text-dark small" style="max-width: 190px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                            ${item.video.title}
                                        </div>
                                        <small class="text-muted">SL: <strong>${item.quantity}</strong> x <fmt:formatNumber value="${item.price}" pattern="#,##0"/> ₫</small>
                                    </div>
                                </div>
                                <div class="fw-bold text-dark small">
                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> ₫
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Bảng tính tiền -->
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Tiền hàng:</span>
                        <span class="fw-semibold"><fmt:formatNumber value="${cart.subtotal}" pattern="#,##0"/> ₫</span>
                    </div>

                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Phí ship COD:</span>
                        <c:choose>
                            <c:when test="${cart.shippingFee == 0}">
                                <span class="badge bg-success">Miễn phí ship</span>
                            </c:when>
                            <c:otherwise>
                                <span class="fw-semibold"><fmt:formatNumber value="${cart.shippingFee}" pattern="#,##0"/> ₫</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="fs-5 fw-bold text-dark">Tổng cần trả (COD):</span>
                        <span class="fs-4 fw-bold text-danger">
                            <fmt:formatNumber value="${cart.totalAmount}" pattern="#,##0"/> ₫
                        </span>
                    </div>

                    <!-- Nút Đặt hàng -->
                    <button type="submit" class="btn btn-success w-100 py-3 fw-bold fs-6 shadow">
                        <i class="fa-solid fa-check-circle me-2"></i>Xác Nhận Đặt Hàng (COD)
                    </button>

                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/cart" class="text-decoration-none small text-muted">
                            <i class="fa-solid fa-arrow-left me-1"></i>Quay lại giỏ hàng
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </form>

</div>

</body>
</html>
