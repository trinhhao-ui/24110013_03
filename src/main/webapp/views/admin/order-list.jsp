<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Lý Đơn Hàng COD - Admin</title>
</head>
<body>

<div class="container-fluid py-4">

    <!-- Header & Bộ lọc -->
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
        <div>
            <h3 class="fw-bold mb-1 text-dark">
                <i class="fa-solid fa-boxes-packing text-primary me-2"></i>Quản Lý Đơn Hàng COD
            </h3>
            <span class="text-muted">Xem, xác nhận và cập nhật trạng thái giao hàng COD</span>
        </div>
        <div class="badge bg-primary fs-6 p-2">
            Tổng cộng: ${orders.size()} đơn
        </div>
    </div>

    <!-- Thông báo nếu có -->
    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i>${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Filter Bar -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body p-2 d-flex flex-wrap gap-2 align-items-center">
            <span class="fw-semibold text-secondary me-2 ms-2"><i class="fa-solid fa-filter me-1"></i>Lọc trạng thái:</span>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm ${empty currentStatus or currentStatus eq 'ALL' ? 'btn-dark' : 'btn-outline-secondary'}">
                Tất cả
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=PENDING" class="btn btn-sm ${currentStatus eq 'PENDING' ? 'btn-warning text-dark' : 'btn-outline-warning text-dark'}">
                Chờ xác nhận
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=PROCESSING" class="btn btn-sm ${currentStatus eq 'PROCESSING' ? 'btn-info text-dark' : 'btn-outline-info text-dark'}">
                Đang chuẩn bị
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=SHIPPING" class="btn btn-sm ${currentStatus eq 'SHIPPING' ? 'btn-primary' : 'btn-outline-primary'}">
                Đang giao hàng
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=DELIVERED" class="btn btn-sm ${currentStatus eq 'DELIVERED' ? 'btn-success' : 'btn-outline-success'}">
                Giao thành công (Thu COD)
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=CANCELLED" class="btn btn-sm ${currentStatus eq 'CANCELLED' ? 'btn-danger' : 'btn-outline-danger'}">
                Đã hủy
            </a>
        </div>
    </div>

    <!-- Bảng danh sách đơn hàng -->
    <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>Mã đơn hàng</th>
                        <th>Ngày đặt</th>
                        <th>Khách hàng</th>
                        <th>Địa chỉ giao hàng</th>
                        <th>Tổng tiền COD</th>
                        <th>Trạng thái &amp; Hóa đơn</th>
                        <th style="min-width: 220px;">Cập nhật trạng thái</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty orders}">
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">
                                    <i class="fa-regular fa-folder-open mb-2" style="font-size: 2.5rem;"></i>
                                    <div>Không tìm thấy đơn hàng nào phù hợp với bộ lọc!</div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/order-detail?id=${o.orderId}" class="fw-bold text-primary text-decoration-none">
                                            #${o.orderId}
                                        </a>
                                    </td>
                                    <td>
                                        <small><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></small>
                                    </td>
                                    <td>
                                        <div class="fw-semibold text-dark">${o.recipientName}</div>
                                        <div class="small text-muted"><i class="fa-solid fa-phone me-1"></i>${o.phone}</div>
                                        <c:if test="${not empty o.user}">
                                            <small class="badge bg-light text-secondary border">@${o.user.username}</small>
                                        </c:if>
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
                                                <div class="small mt-1 text-success fw-bold">
                                                    <i class="fa-solid fa-file-invoice-dollar me-1"></i>Đã có Hóa đơn
                                                </div>
                                            </c:when>
                                            <c:when test="${o.status eq 'CANCELLED'}">
                                                <div class="small mt-1 text-muted">
                                                    <i class="fa-solid fa-ban me-1"></i>Không có HĐ
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="small mt-1 text-warning fw-semibold">
                                                    <i class="fa-solid fa-hourglass-half me-1"></i>Chờ giao để xuất HĐ
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/order-update-status" method="post" class="d-flex gap-1 align-items-center">
                                            <input type="hidden" name="orderId" value="${o.orderId}">
                                            <input type="hidden" name="redirectUrl" value="/admin/orders<c:if test='${not empty currentStatus}'>?status=${currentStatus}</c:if>">
                                            <select name="status" class="form-select form-select-sm" style="width: auto;">
                                                <option value="PENDING" ${o.status eq 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                                                <option value="PROCESSING" ${o.status eq 'PROCESSING' ? 'selected' : ''}>Đang chuẩn bị</option>
                                                <option value="SHIPPING" ${o.status eq 'SHIPPING' ? 'selected' : ''}>Đang giao (COD)</option>
                                                <option value="DELIVERED" ${o.status eq 'DELIVERED' ? 'selected' : ''}>Giao thành công (Thu COD)</option>
                                                <option value="CANCELLED" ${o.status eq 'CANCELLED' ? 'selected' : ''}>Hủy đơn</option>
                                            </select>
                                            <button type="submit" class="btn btn-sm btn-outline-primary" title="Lưu trạng thái">
                                                <i class="fa-solid fa-floppy-disk"></i>
                                            </button>
                                        </form>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${o.status eq 'DELIVERED'}">
                                                <a href="${pageContext.request.contextPath}/admin/order-detail?id=${o.orderId}" class="btn btn-sm btn-success fw-semibold" title="Xem Hóa Đơn Bán Hàng">
                                                    <i class="fa-solid fa-file-invoice-dollar me-1"></i>Hóa đơn
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/admin/order-detail?id=${o.orderId}" class="btn btn-sm btn-outline-primary" title="Xem Phiếu Giao / Chi Tiết">
                                                    <i class="fa-solid fa-eye me-1"></i>Chi tiết
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

</div>

</body>
</html>
