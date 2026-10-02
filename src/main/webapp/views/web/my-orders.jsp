<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Lịch Sử Đặt Hàng - WebVideo</title>
    <style>
        .order-tabs {
            scrollbar-width: thin;
            scrollbar-color: #cbd5e1 transparent;
        }
        .order-tabs::-webkit-scrollbar {
            height: 5px;
        }
        .order-tabs::-webkit-scrollbar-thumb {
            background-color: #cbd5e1;
            border-radius: 10px;
        }
        .order-tabs::-webkit-scrollbar-track {
            background: transparent;
        }
        .order-tabs .nav-link {
            border-radius: 20px;
            font-size: 0.93rem;
            font-weight: 600;
            padding: 8px 16px;
            color: #1e293b !important; /* Đậm nét, cực kỳ rõ chữ */
            background-color: #f1f5f9;
            transition: all 0.2s ease-in-out;
            border: 1px solid #cbd5e1;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .order-tabs .nav-link:hover {
            background-color: #e2e8f0;
            color: #0d6efd !important;
            border-color: #0d6efd;
            transform: translateY(-1px);
        }
        .order-tabs .nav-link.active {
            background-color: #0d6efd !important;
            color: #ffffff !important;
            font-weight: 700;
            border-color: #0d6efd !important;
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.35);
        }
        .order-tabs .nav-link.active .badge {
            background-color: #ffffff !important;
            color: #0d6efd !important;
            font-weight: 700;
        }
        .order-tabs .nav-link .badge {
            font-size: 0.82rem;
            font-weight: 600;
        }
        .status-badge-lg {
            font-size: 0.88rem;
            padding: 6px 12px;
            border-radius: 12px;
        }
    </style>
</head>
<body>

<div class="container py-4">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
            <li class="breadcrumb-item active" aria-current="page">Lịch sử đặt hàng</li>
        </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
        <div>
            <h3 class="fw-bold mb-1 text-dark">
                <i class="fa-solid fa-clock-rotate-left text-primary me-2"></i>Lịch Sử Đặt Hàng
            </h3>
            <span class="text-muted">Theo dõi và quản lý trạng thái các đơn hàng của bạn</span>
        </div>

        <!-- Form tra cứu đơn hàng theo mã đơn, SĐT hoặc Họ tên -->
        <form action="${pageContext.request.contextPath}/my-orders" method="post" class="d-flex">
            <div class="input-group">
                <input type="text" name="searchOrderId" class="form-control" placeholder="Mã đơn (ORD-...), SĐT hoặc Tên..." required style="min-width: 260px;">
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

    <!-- THANH TAB LỌC THEO 8 TRẠNG THÁI -->
    <div class="card border-0 shadow-sm mb-4" style="border-radius: 14px;">
        <div class="card-body p-3">
            <ul class="nav nav-pills flex-nowrap overflow-auto order-tabs pb-1" style="gap: 8px;">
                <!-- 0. Tất cả -->
                <li class="nav-item">
                    <a class="nav-link text-nowrap ${empty currentStatus or currentStatus eq 'ALL' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/my-orders">
                        <i class="fa-solid fa-list-ul me-1"></i> Tất cả
                        <c:if test="${not empty statusCounts['ALL']}">
                            <span class="badge ${empty currentStatus or currentStatus eq 'ALL' ? 'bg-light text-dark' : 'bg-secondary'} ms-1">${statusCounts['ALL']}</span>
                        </c:if>
                    </a>
                </li>

                <!-- 1. Đơn hàng mới -->
                <li class="nav-item">
                    <a class="nav-link text-nowrap ${currentStatus eq 'NEW' or currentStatus eq 'PENDING' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/my-orders?status=NEW">
                        <i class="fa-solid fa-clock text-warning me-1"></i> Đơn hàng mới
                        <c:if test="${not empty statusCounts['NEW'] && statusCounts['NEW'] > 0}">
                            <span class="badge ${currentStatus eq 'NEW' or currentStatus eq 'PENDING' ? 'bg-light text-dark' : 'bg-warning text-dark'} ms-1">${statusCounts['NEW']}</span>
                        </c:if>
                    </a>
                </li>

                <!-- 2. Đã xác nhận -->
                <li class="nav-item">
                    <a class="nav-link text-nowrap ${currentStatus eq 'CONFIRMED' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/my-orders?status=CONFIRMED">
                        <i class="fa-solid fa-clipboard-check text-primary me-1"></i> Đã xác nhận
                        <c:if test="${not empty statusCounts['CONFIRMED'] && statusCounts['CONFIRMED'] > 0}">
                            <span class="badge ${currentStatus eq 'CONFIRMED' ? 'bg-light text-dark' : 'bg-primary'} ms-1">${statusCounts['CONFIRMED']}</span>
                        </c:if>
                    </a>
                </li>

                <!-- 3. Chuẩn bị hàng -->
                <li class="nav-item">
                    <a class="nav-link text-nowrap ${currentStatus eq 'PREPARING' or currentStatus eq 'PROCESSING' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/my-orders?status=PREPARING">
                        <i class="fa-solid fa-boxes-packing text-info me-1"></i> Chuẩn bị hàng
                        <c:if test="${not empty statusCounts['PREPARING'] && statusCounts['PREPARING'] > 0}">
                            <span class="badge ${currentStatus eq 'PREPARING' or currentStatus eq 'PROCESSING' ? 'bg-light text-dark' : 'bg-info text-dark'} ms-1">${statusCounts['PREPARING']}</span>
                        </c:if>
                    </a>
                </li>

                <!-- 4. Vận chuyển -->
                <li class="nav-item">
                    <a class="nav-link text-nowrap ${currentStatus eq 'SHIPPING' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/my-orders?status=SHIPPING">
                        <i class="fa-solid fa-truck text-secondary me-1"></i> Vận chuyển
                        <c:if test="${not empty statusCounts['SHIPPING'] && statusCounts['SHIPPING'] > 0}">
                            <span class="badge ${currentStatus eq 'SHIPPING' ? 'bg-light text-dark' : 'bg-secondary'} ms-1">${statusCounts['SHIPPING']}</span>
                        </c:if>
                    </a>
                </li>

                <!-- 5. Giao hàng -->
                <li class="nav-item">
                    <a class="nav-link text-nowrap ${currentStatus eq 'DELIVERING' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/my-orders?status=DELIVERING">
                        <i class="fa-solid fa-motorcycle text-primary me-1"></i> Giao hàng
                        <c:if test="${not empty statusCounts['DELIVERING'] && statusCounts['DELIVERING'] > 0}">
                            <span class="badge ${currentStatus eq 'DELIVERING' ? 'bg-light text-dark' : 'bg-primary'} ms-1">${statusCounts['DELIVERING']}</span>
                        </c:if>
                    </a>
                </li>

                <!-- 6. Đã giao -->
                <li class="nav-item">
                    <a class="nav-link text-nowrap ${currentStatus eq 'DELIVERED' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/my-orders?status=DELIVERED">
                        <i class="fa-solid fa-circle-check text-success me-1"></i> Đã giao
                        <c:if test="${not empty statusCounts['DELIVERED'] && statusCounts['DELIVERED'] > 0}">
                            <span class="badge ${currentStatus eq 'DELIVERED' ? 'bg-light text-dark' : 'bg-success'} ms-1">${statusCounts['DELIVERED']}</span>
                        </c:if>
                    </a>
                </li>

                <!-- 7. Đơn hàng hủy -->
                <li class="nav-item">
                    <a class="nav-link text-nowrap ${currentStatus eq 'CANCELLED' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/my-orders?status=CANCELLED">
                        <i class="fa-solid fa-ban text-danger me-1"></i> Đơn hàng hủy
                        <c:if test="${not empty statusCounts['CANCELLED'] && statusCounts['CANCELLED'] > 0}">
                            <span class="badge ${currentStatus eq 'CANCELLED' ? 'bg-light text-dark' : 'bg-danger'} ms-1">${statusCounts['CANCELLED']}</span>
                        </c:if>
                    </a>
                </li>

                <!-- 8. Đơn hàng hoàn -->
                <li class="nav-item">
                    <a class="nav-link text-nowrap ${currentStatus eq 'RETURNED' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/my-orders?status=RETURNED">
                        <i class="fa-solid fa-arrow-rotate-left text-dark me-1"></i> Đơn hàng hoàn
                        <c:if test="${not empty statusCounts['RETURNED'] && statusCounts['RETURNED'] > 0}">
                            <span class="badge ${currentStatus eq 'RETURNED' ? 'bg-light text-dark' : 'bg-dark'} ms-1">${statusCounts['RETURNED']}</span>
                        </c:if>
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <!-- DANH SÁCH ĐƠN HÀNG -->
    <c:choose>
        <c:when test="${empty orders}">
            <div class="card border-0 shadow-sm py-5 text-center my-4" style="border-radius: 15px;">
                <div class="card-body">
                    <i class="fa-solid fa-box-open text-muted" style="font-size: 4rem;"></i>
                    <h5 class="mt-4 fw-bold text-secondary">
                        <c:choose>
                            <c:when test="${not empty currentStatus and currentStatus ne 'ALL'}">
                                Chưa có đơn hàng nào ở trạng thái này!
                            </c:when>
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
                            <c:when test="${not empty currentStatus and currentStatus ne 'ALL'}">
                                Bạn có thể chuyển sang tab <a href="${pageContext.request.contextPath}/my-orders" class="text-primary fw-bold">Tất cả</a> để xem toàn bộ đơn hàng.
                            </c:when>
                            <c:when test="${empty sessionScope.account}">
                                Vui lòng <a href="${pageContext.request.contextPath}/login" class="text-primary fw-bold">Đăng nhập</a> để xem toàn bộ đơn hàng của bạn, hoặc nhập mã đơn hàng / số điện thoại ở ô phía trên để tra cứu.
                            </c:when>
                            <c:otherwise>
                                Bạn có thể nhập mã đơn hàng (VD: <code>ORD-...</code>), Số điện thoại hoặc Họ tên người nhận vào ô tìm kiếm phía trên để tra cứu nhanh!
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <div class="d-flex justify-content-center gap-2 mt-2">
                        <c:choose>
                            <c:when test="${empty sessionScope.account}">
                                <a href="${pageContext.request.contextPath}/login?redirect=/my-orders" class="btn btn-primary px-4 py-2">
                                    <i class="fa-solid fa-right-to-bracket me-2"></i>Đăng nhập ngay
                                </a>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-3 py-2">
                                    <i class="fa-solid fa-house me-1"></i>Về Trang Chủ
                                </a>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${not empty currentStatus and currentStatus ne 'ALL'}">
                                    <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-primary px-3 py-2">
                                        <i class="fa-solid fa-list-ul me-1"></i>Xem tất cả đơn
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4 py-2">
                                    <i class="fa-solid fa-shopping-bag me-2"></i>Mua sắm ngay
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
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
                                    <td style="max-width: 220px;" class="text-truncate" title="${o.address}">
                                        ${o.address}
                                    </td>
                                    <td class="fw-bold text-danger">
                                        <fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> ₫
                                    </td>
                                    <td>
                                        <span class="badge ${o.statusBadgeClass} status-badge-lg">
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
                                                    Đã hủy
                                                </span>
                                            </c:when>
                                            <c:when test="${o.status eq 'RETURNED'}">
                                                <span class="badge bg-dark-subtle text-dark border mt-1 d-block">
                                                    Đã hoàn về kho
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm">
                                            <c:choose>
                                                <c:when test="${o.status eq 'DELIVERED'}">
                                                    <a href="${pageContext.request.contextPath}/order-detail?id=${o.orderId}" class="btn btn-success" title="Xem &amp; In Hóa đơn bán hàng">
                                                        <i class="fa-solid fa-file-invoice-dollar me-1"></i>Hóa đơn
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/order-detail?id=${o.orderId}" class="btn btn-outline-primary" title="Xem chi tiết đơn hàng COD">
                                                        <i class="fa-solid fa-receipt me-1"></i>Chi tiết
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            <!-- Nút hủy đơn nếu trạng thái là NEW hoặc PENDING -->
                                            <c:if test="${o.isCancellable()}">
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
