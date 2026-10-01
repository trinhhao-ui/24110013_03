<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đặt Hàng Thành Công - WebVideo</title>
    <style>
        .success-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
            padding: 40px;
        }
        .icon-circle {
            width: 80px;
            height: 80px;
            background-color: #e8f5e9;
            color: #2e7d32;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin-bottom: 20px;
        }
        .info-row {
            padding: 8px 0;
            border-bottom: 1px dashed #e2e8f0;
        }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="success-card text-center">
                <div class="icon-circle">
                    <i class="fa-solid fa-check"></i>
                </div>
                <h2 class="fw-bold text-success mb-2">Đặt Hàng Thành Công!</h2>
                <p class="text-muted mb-4">Cảm ơn bạn đã tin tưởng và mua hàng tại WebVideo. Đơn hàng COD của bạn đang được chuẩn bị để giao đến tận nơi.</p>

                <!-- Thẻ thông tin tóm tắt -->
                <div class="card bg-light border-0 text-start p-4 mb-4 rounded-3">
                    <div class="row g-3">
                        <div class="col-sm-6 info-row">
                            <span class="text-muted">Mã đơn hàng:</span>
                            <div class="fw-bold text-primary fs-5">${order.orderId}</div>
                        </div>
                        <div class="col-sm-6 info-row">
                            <span class="text-muted">Ngày đặt:</span>
                            <div class="fw-semibold text-dark">
                                <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </div>
                        </div>
                        <div class="col-sm-6 info-row">
                            <span class="text-muted">Phương thức thanh toán:</span>
                            <div class="fw-bold text-success">
                                <i class="fa-solid fa-money-bill-wave me-1"></i>Thanh toán khi nhận hàng (COD)
                            </div>
                        </div>
                        <div class="col-sm-6 info-row">
                            <span class="text-muted">Trạng thái:</span>
                            <div>
                                <span class="badge ${order.statusBadgeClass} fs-6">${order.statusVietnamese}</span>
                            </div>
                        </div>
                        <div class="col-sm-6 info-row">
                            <span class="text-muted">Người nhận:</span>
                            <div class="fw-semibold text-dark">${order.recipientName} (${order.phone})</div>
                        </div>
                        <div class="col-sm-6 info-row">
                            <span class="text-muted">Địa chỉ nhận hàng:</span>
                            <div class="fw-semibold text-dark">${order.address}</div>
                        </div>
                        <c:if test="${not empty order.note}">
                            <div class="col-12 info-row">
                                <span class="text-muted">Ghi chú:</span>
                                <div class="text-dark fst-italic">${order.note}</div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Danh sách sản phẩm đã đặt -->
                <div class="card border mb-4 text-start rounded-3">
                    <div class="card-header bg-white fw-bold">
                        <i class="fa-solid fa-box-open me-2 text-primary"></i>Danh sách sản phẩm trong đơn
                    </div>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr class="table-light">
                                    <th>Sản phẩm</th>
                                    <th class="text-center">Số lượng</th>
                                    <th class="text-end">Đơn giá</th>
                                    <th class="text-end">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${order.orderDetails}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="${d.video.poster}" alt="${d.video.title}" width="50" height="35" class="rounded me-2 object-fit-cover" onerror="this.src='https://picsum.photos/50/35?random=1'">
                                                <span class="fw-semibold text-dark">${d.video.title}</span>
                                            </div>
                                        </td>
                                        <td class="text-center fw-bold">${d.quantity}</td>
                                        <td class="text-end text-muted"><fmt:formatNumber value="${d.price}" pattern="#,##0"/> ₫</td>
                                        <td class="text-end fw-bold text-dark"><fmt:formatNumber value="${d.subtotal}" pattern="#,##0"/> ₫</td>
                                    </tr>
                                </c:forEach>
                                <tr class="table-light">
                                    <td colspan="3" class="text-end fw-semibold">Phí vận chuyển COD:</td>
                                    <td class="text-end fw-semibold">
                                        <c:choose>
                                            <c:when test="${order.shippingFee == 0}">Miễn phí</c:when>
                                            <c:otherwise><fmt:formatNumber value="${order.shippingFee}" pattern="#,##0"/> ₫</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr class="table-light border-top">
                                    <td colspan="3" class="text-end fw-bold fs-5 text-dark">Tổng tiền COD thu khi nhận:</td>
                                    <td class="text-end fw-bold fs-5 text-danger">
                                        <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> ₫
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Quy tắc nghiệp vụ về Hóa đơn COD -->
                <div class="alert alert-info border-info text-start d-flex align-items-center mb-4 rounded-3 p-3">
                    <i class="fa-solid fa-circle-info fs-3 text-info me-3"></i>
                    <div>
                        <div class="fw-bold mb-1">Quy định phát hành Hóa đơn bán hàng:</div>
                        <small class="text-secondary">
                            Đơn hàng của bạn áp dụng phương thức <strong>Thanh toán khi nhận hàng (COD)</strong>. Theo đúng quy trình nghiệp vụ:
                            <strong>Hóa đơn bán hàng chính thức (#HD-${order.orderId})</strong> chỉ được phát hành sau khi Shipper giao hàng thành công và thu tiền mặt hoàn tất. Hiện tại, bạn có thể xem và in <strong>Phiếu đặt hàng &amp; giao nhận</strong>.
                        </small>
                    </div>
                </div>

                <!-- Điều hướng & Xem phiếu đơn hàng -->
                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <a href="${pageContext.request.contextPath}/order-detail?id=${order.orderId}" class="btn btn-primary px-4 py-2 fw-semibold">
                        <i class="fa-solid fa-truck-ramp-box me-2"></i>Xem Phiếu Giao Hàng (COD)
                    </a>
                    <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-secondary px-4 py-2 fw-semibold">
                        <i class="fa-solid fa-clock-rotate-left me-2"></i>Lịch Sử Đơn Hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary px-4 py-2">
                        <i class="fa-solid fa-house me-2"></i>Về Trang Chủ Mua Sắm
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
