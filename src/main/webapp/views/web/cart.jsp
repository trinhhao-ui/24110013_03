<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Giỏ Hàng Của Bạn - WebVideo</title>
    <style>
        .cart-table th {
            background-color: #f1f2f6;
            color: #2f3542;
            font-weight: 600;
            vertical-align: middle;
        }
        .cart-table td {
            vertical-align: middle;
        }
        .cart-poster {
            width: 100px;
            height: 65px;
            object-fit: cover;
            border-radius: 6px;
        }
        .qty-input {
            width: 65px;
            text-align: center;
            font-weight: 600;
        }
        .summary-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.06);
            border: 1px solid #e2e8f0;
            padding: 24px;
        }
    </style>
</head>
<body>

<div class="container py-4">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
            <li class="breadcrumb-item active" aria-current="page">Giỏ hàng</li>
        </ol>
    </nav>

    <h3 class="fw-bold mb-3 text-dark">
        <i class="fa-solid fa-cart-shopping text-danger me-2"></i>Giỏ Hàng Của Bạn
        <c:if test="${not empty cart and not cart.isEmpty()}">
            <span class="badge bg-secondary fs-6 align-middle ms-2">${cart.totalQuantity} sản phẩm</span>
        </c:if>
    </h3>

    <!-- Thông báo thành công hoặc cảnh báo tồn kho -->
    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i>${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty warning}">
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>${warning}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty cart or cart.isEmpty()}">
            <!-- Giỏ hàng rỗng -->
            <div class="card border-0 shadow-sm py-5 text-center my-4" style="border-radius: 15px;">
                <div class="card-body">
                    <i class="fa-solid fa-cart-arrow-down text-muted" style="font-size: 5rem;"></i>
                    <h4 class="mt-4 fw-bold text-secondary">Giỏ hàng của bạn đang trống!</h4>
                    <p class="text-muted">Hãy khám phá thêm các sản phẩm video và khóa học hấp dẫn nhé.</p>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4 py-2 mt-2">
                        <i class="fa-solid fa-arrow-left me-2"></i>Tiếp Tục Mua Sắm
                    </a>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <!-- Giỏ hàng có sản phẩm -->
            <div class="row g-4">
                <!-- Cột danh sách sản phẩm trong giỏ -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
                        <div class="table-responsive">
                            <table class="table cart-table align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th scope="col" style="min-width: 250px;">Sản phẩm</th>
                                        <th scope="col" class="text-center">Đơn giá</th>
                                        <th scope="col" class="text-center" style="min-width: 170px;">Số lượng</th>
                                        <th scope="col" class="text-center">Thành tiền</th>
                                        <th scope="col" class="text-center">Xóa</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cart.items}">
                                        <tr>
                                            <!-- Thông tin sản phẩm -->
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <a href="${pageContext.request.contextPath}/video-detail?id=${item.video.videoId}">
                                                        <img src="${item.video.poster}" alt="${item.video.title}" class="cart-poster me-3" onerror="this.src='https://picsum.photos/100/65?random=1'">
                                                    </a>
                                                    <div>
                                                        <a href="${pageContext.request.contextPath}/video-detail?id=${item.video.videoId}" class="fw-semibold text-dark text-decoration-none">
                                                            ${item.video.title}
                                                        </a>
                                                        <div class="text-muted small">Mã: <code>${item.video.videoId}</code></div>
                                                        <div class="text-success small">
                                                            <i class="fa-solid fa-boxes-stacked me-1"></i>Tồn kho: <strong>${item.video.quantity}</strong>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>

                                            <!-- Đơn giá -->
                                            <td class="text-center fw-semibold text-danger">
                                                <fmt:formatNumber value="${item.price}" pattern="#,##0"/> ₫
                                            </td>

                                            <!-- Số lượng (thay đổi trong giới hạn tồn kho) -->
                                            <td class="text-center">
                                                <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-inline-flex align-items-center justify-content-center">
                                                    <input type="hidden" name="videoId" value="${item.video.videoId}">
                                                    
                                                    <!-- Nút giảm -->
                                                    <button type="submit" name="quantity" value="${item.quantity - 1}" class="btn btn-outline-secondary btn-sm" title="Giảm số lượng">
                                                        <i class="fa-solid fa-minus"></i>
                                                    </button>
                                                    
                                                    <!-- Ô hiển thị số lượng -->
                                                    <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.maxQuantity}" 
                                                           class="form-control form-control-sm qty-input mx-1" 
                                                           onchange="this.form.submit()" title="Nhập số lượng (Tối đa ${item.maxQuantity})">
                                                    
                                                    <!-- Nút tăng -->
                                                    <button type="submit" name="quantity" value="${item.quantity + 1}" class="btn btn-outline-secondary btn-sm" 
                                                            ${item.quantity >= item.maxQuantity ? 'disabled' : ''} title="Tăng số lượng">
                                                        <i class="fa-solid fa-plus"></i>
                                                    </button>
                                                </form>
                                                <div class="text-muted small mt-1">(Tối đa: ${item.maxQuantity})</div>
                                            </td>

                                            <!-- Thành tiền -->
                                            <td class="text-center fw-bold text-primary">
                                                <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> ₫
                                            </td>

                                            <!-- Nút xóa -->
                                            <td class="text-center">
                                                <form action="${pageContext.request.contextPath}/cart/delete" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?');">
                                                    <input type="hidden" name="videoId" value="${item.video.videoId}">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm" title="Xóa sản phẩm">
                                                        <i class="fa-solid fa-trash-can"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Các nút thao tác đáy bảng -->
                        <div class="card-footer bg-white d-flex justify-content-between align-items-center p-3">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary btn-sm">
                                <i class="fa-solid fa-arrow-left me-1"></i>Tiếp tục mua sắm
                            </a>
                            <form action="${pageContext.request.contextPath}/cart/clear" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc muốn xóa TOÀN BỘ giỏ hàng?');">
                                <button type="submit" class="btn btn-outline-danger btn-sm">
                                    <i class="fa-solid fa-trash-arrow-up me-1"></i>Xóa sạch giỏ hàng
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Cột Tóm tắt Đơn Hàng & Nút Thanh Toán COD -->
                <div class="col-lg-4">
                    <div class="summary-card">
                        <h5 class="fw-bold mb-3 text-dark border-bottom pb-2">
                            <i class="fa-solid fa-receipt me-2 text-primary"></i>Tóm Tắt Đơn Hàng
                        </h5>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Tổng số lượng:</span>
                            <span class="fw-semibold">${cart.totalQuantity} món</span>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Tạm tính:</span>
                            <span class="fw-semibold"><fmt:formatNumber value="${cart.subtotal}" pattern="#,##0"/> ₫</span>
                        </div>

                        <div class="d-flex justify-content-between mb-2 align-items-center">
                            <span class="text-muted">Phí ship COD:</span>
                            <c:choose>
                                <c:when test="${cart.shippingFee == 0}">
                                    <span class="badge bg-success">Miễn phí</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="fw-semibold text-dark"><fmt:formatNumber value="${cart.shippingFee}" pattern="#,##0"/> ₫</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${cart.shippingFee > 0}">
                            <div class="alert alert-info py-2 px-3 small mb-3">
                                <i class="fa-solid fa-circle-info me-1"></i>Mua thêm 
                                <strong><fmt:formatNumber value="${500000 - cart.subtotal}" pattern="#,##0"/> ₫</strong> 
                                để được <strong>Miễn phí vận chuyển COD</strong>!
                            </div>
                        </c:if>

                        <hr>

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="fs-5 fw-bold text-dark">Tổng cộng:</span>
                            <span class="fs-4 fw-bold text-danger">
                                <fmt:formatNumber value="${cart.totalAmount}" pattern="#,##0"/> ₫
                            </span>
                        </div>

                        <!-- Phương thức thanh toán COD -->
                        <div class="mb-3 p-3 bg-light rounded border">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethodRadio" id="codMethod" checked disabled>
                                <label class="form-check-label fw-bold text-dark" for="codMethod">
                                    <i class="fa-solid fa-truck-fast text-primary me-1"></i>Thanh toán khi nhận hàng (COD)
                                </label>
                            </div>
                            <small class="text-muted d-block mt-1 ps-4">
                                Bạn sẽ thanh toán bằng tiền mặt trực tiếp cho nhân viên giao hàng khi nhận kiện hàng.
                            </small>
                        </div>

                        <!-- Nút thanh toán -->
                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-danger w-100 py-3 fw-bold fs-6 shadow">
                            <i class="fa-solid fa-money-bill-wave me-2"></i>Tiến Hành Thanh Toán COD
                        </a>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
