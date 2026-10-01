<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Lịch Sử Đơn Hàng - WebVideo</title>
</head>
<body>

<div class="container py-4">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
            <li class="breadcrumb-item active" aria-current="page">Lịch sử đơn hàng</li>
        </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
        <h3 class="fw-bold mb-0 text-dark">
            <i class="fa-solid fa-clock-rotate-left text-primary me-2"></i>Lịch Sử Đơn Hàng Của Bạn
        </h3>

        <!-- Form tra cứu đơn hàng theo mã đơn, SĐT hoặc Họ tên -->
        <form action="${pageContext.request.contextPath}/my-orders" method="post" class="d-flex">
            <div class="input-group">
                <input type="text" name="searchOrderId" class="form-control" placeholder="Mã đơn (ORD-...), SĐT hoặc Họ tên..." required style="min-width: 280px;">
                <button class="btn btn-primary" type="submit">
                    <i class="fa-solid fa-magnifying-glass me-1"></i>Tra Cứu
                </button>
            </div>
        </form>
    </div>

    <!-- Thông báo Quản trị viên nếu đang login admin -->
    <c:if test="${sessionScope.account.admin}">
        <div class="alert alert-info border-info d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2 shadow-sm">
            <div>
                <i class="fa-solid fa-user-shield me-2 fs-5 text-primary"></i>
                Bạn đang đăng nhập bằng tài khoản <strong>Quản trị viên (Admin)</strong>.
            </div>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-primary">
                <i class="fa-solid fa-boxes-packing me-1"></i>Xem tất cả đơn tại Trang Quản Lý Admin
            </a>
        </div>
    </c:if>

    <!-- Thông báo -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i>${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="card border-0 shadow-sm py-5 text-center my-4" style="border-radius: 15px;">
                <div class="card-body">
                    <i class="fa-solid fa-box-open text-muted" style="font-size: 4rem;"></i>
                    <h5 class="mt-4 fw-bold text-secondary">
                        <c:choose>
                            <c:when test="${empty sessionScope.account}">
                                Bạn chưa đăng nhập hoặc chưa có đơn hàng nào!
                            </c:when>
                            <c:otherwise>
                                Không tìm thấy đơn hàng nào thuộc tài khoản @${sessionScope.account.username}!
                            </c:otherwise>
                        </c:choose>
                    </h5>
                    <p class="text-muted">
                        <c:choose>
                            <c:when test="${empty sessionScope.account}">
                                Vui lòng <a href="${pageContext.request.contextPath}/login" class="text-primary fw-bold">Đăng nhập</a> để xem toàn bộ đơn hàng của bạn, hoặc nhập mã đơn hàng / số điện thoại ở ô phía trên để tra cứu.
                            </c:when>
                            <c:otherwise>
                                Bạn có thể nhập mã đơn hàng (VD: <code>ORD-...</code>), Số điện thoại hoặc Họ tên người nhận vào ô tìm kiếm phía trên để tra cứu nhanh!
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4 py-2 mt-2">
                        <i class="fa-solid fa-shopping-bag me-2"></i>Mua sắm ngay
                    </a>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
                <div class="table-responsive">
                    <table class="table align-middle table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Mã đơn</th>
                                <th>Ngày đặt</th>
                                <th>Người nhận</th>
                                <th>Địa chỉ giao</th>
                                <th>Tổng tiền (COD)</th>
                                <th>Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/order-detail?id=${o.orderId}" class="fw-bold text-primary text-decoration-none">
                                            #${o.orderId}
                                        </a>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <div class="fw-semibold text-dark">${o.recipientName}</div>
                                        <small class="text-muted">${o.phone}</small>
                                    </td>
                                    <td style="max-width: 200px;" class="text-truncate" title="${o.address}">
                                        ${o.address}
                                    </td>
                                    <td class="fw-bold text-danger">
                                        <fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> ₫
                                    </td>
                                    <td>
                                        <span class="badge ${o.statusBadgeClass} fs-6">
                                            ${o.statusVietnamese}
                                        </span>
                                        <c:choose>
                                            <c:when test="${o.status eq 'DELIVERED'}">
                                                <span class="badge bg-success-subtle text-success border border-success mt-1 d-block">
                                                    <i class="fa-solid fa-file-invoice me-1"></i>Đã có Hóa đơn
                                                </span>
                                            </c:when>
                                            <c:when test="${o.status eq 'CANCELLED'}">
                                                <span class="badge bg-secondary-subtle text-secondary border mt-1 d-block">
                                                    Không có HĐ
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning-subtle text-warning-emphasis border border-warning mt-1 d-block">
                                                    <i class="fa-solid fa-hourglass-half me-1"></i>Chờ giao để xuất HĐ
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm">
                                            <c:choose>
                                                <c:when test="${o.status eq 'DELIVERED'}">
                                                    <a href="${pageContext.request.contextPath}/order-detail?id=${o.orderId}" class="btn btn-success" title="Đã giao thành công - Xem &amp; In Hóa đơn bán hàng">
                                                        <i class="fa-solid fa-file-invoice-dollar me-1"></i>Hóa đơn
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/order-detail?id=${o.orderId}" class="btn btn-outline-primary" title="Xem chi tiết đơn hàng COD">
                                                        <i class="fa-solid fa-receipt me-1"></i>Chi tiết đơn
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            <!-- Nút hủy đơn nếu trạng thái là PENDING -->
                                            <c:if test="${o.status eq 'PENDING'}">
                                                <a href="${pageContext.request.contextPath}/order-cancel?id=${o.orderId}" 
                                                   class="btn btn-outline-danger" 
                                                   onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng #${o.orderId}? Số lượng sẽ được hoàn lại kho.');"
                                                   title="Hủy đơn hàng">
                                                    <i class="fa-solid fa-ban me-1"></i>Hủy đơn
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
