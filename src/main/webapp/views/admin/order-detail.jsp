<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Lý Đơn Hàng #${order.orderId} - Admin</title>
    <style>
        .party-card {
            border: 1px solid #e1e8ed;
            border-radius: 8px;
            padding: 18px 20px;
            height: 100%;
            background-color: #fcfdfe;
        }
        .party-title {
            font-size: 0.95rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding-bottom: 8px;
            margin-bottom: 12px;
            border-bottom: 2px solid #e2e8f0;
        }
        .party-sender .party-title {
            color: #0d6efd;
            border-bottom-color: #0d6efd;
        }
        .party-receiver .party-title {
            color: #198754;
            border-bottom-color: #198754;
        }
        .signature-box {
            text-align: center;
            padding-top: 10px;
        }
        .signature-title {
            font-weight: 700;
            font-size: 0.95rem;
            text-transform: uppercase;
            color: #1e293b;
        }
        .signature-note {
            font-size: 0.85rem;
            font-style: italic;
            color: #64748b;
        }
        .signature-space {
            height: 70px;
        }
        @media print {
            .no-print, .sidebar, .admin-navbar, .footer-custom { display: none !important; }
            body { background: #ffffff !important; }
            .admin-content { padding: 0 !important; width: 100% !important; margin: 0 !important; }
            .card { box-shadow: none !important; border: 1px solid #000000 !important; }
        }
    </style>
</head>
<body>

<div class="container-fluid py-4">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4 no-print">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/videos">Admin</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a></li>
            <li class="breadcrumb-item active" aria-current="page">
                <c:choose>
                    <c:when test="${order.status eq 'DELIVERED'}">Hóa đơn #${order.orderId}</c:when>
                    <c:otherwise>Chi tiết đơn #${order.orderId}</c:otherwise>
                </c:choose>
            </li>
        </ol>
    </nav>

    <!-- Thông báo logic nghiệp vụ về Hóa đơn -->
    <c:choose>
        <c:when test="${order.status eq 'DELIVERED'}">
            <div class="alert alert-success border-success d-flex align-items-center mb-4 no-print" role="alert">
                <i class="fa-solid fa-circle-check fs-2 text-success me-3"></i>
                <div>
                    <h6 class="fw-bold mb-1">ĐƠN HÀNG ĐÃ GIAO THÀNH CÔNG &amp; ĐÃ THU TIỀN COD HOÀN TẤT</h6>
                    <small>Theo quy định: Đơn hàng đã hoàn tất giao hàng và thu tiền COD nên <strong>Hóa đơn bán hàng chính thức (#HD-${order.orderId})</strong> có đầy đủ giá trị pháp lý và tài chính.</small>
                </div>
            </div>
        </c:when>
        <c:when test="${order.status eq 'CANCELLED'}">
            <div class="alert alert-danger border-danger d-flex align-items-center mb-4 no-print" role="alert">
                <i class="fa-solid fa-ban fs-2 text-danger me-3"></i>
                <div>
                    <h6 class="fw-bold mb-1">ĐƠN HÀNG ĐÃ BỊ HỦY - KHÔNG PHÁT HÀNH HÓA ĐƠN</h6>
                    <small>Đơn hàng này đã bị hủy, toàn bộ video đã được hệ thống tự động hoàn lại kho. Hệ thống không xuất hóa đơn bán hàng cho đơn đã hủy.</small>
                </div>
            </div>
        </c:when>
        <c:when test="${order.status eq 'RETURNED'}">
            <div class="alert alert-dark border-dark d-flex align-items-center mb-4 no-print" role="alert">
                <i class="fa-solid fa-arrow-rotate-left fs-2 text-dark me-3"></i>
                <div>
                    <h6 class="fw-bold mb-1">ĐƠN HÀNG HOÀN TRẢ VỀ KHO - KHÔNG PHÁT HÀNH HÓA ĐƠN</h6>
                    <small>Đơn hàng giao không thành công hoặc khách trả hàng đã hoàn về kho. Hệ thống đã tự động hoàn trả số lượng hàng vào kho.</small>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-warning border-warning d-flex align-items-center mb-4 no-print" role="alert">
                <i class="fa-solid fa-hourglass-half fs-2 text-warning me-3"></i>
                <div>
                    <h6 class="fw-bold mb-1">ĐƠN HÀNG ĐANG XỬ LÝ / VẬN CHUYỂN (${order.statusVietnamese})</h6>
                    <small>Quy tắc nghiệp vụ: <strong>Chỉ đơn hàng giao thành công mới được phát hành Hóa đơn bán hàng</strong>. Văn bản này đóng vai trò là <em>Phiếu giao hàng &amp; bàn giao COD</em> cho Shipper và Khách hàng.</small>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Top Card: Quản lý trạng thái & In phiếu -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body p-4">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <c:choose>
                        <c:when test="${order.status eq 'DELIVERED'}">
                            <h3 class="fw-bold text-success mb-1">
                                <i class="fa-solid fa-file-invoice-dollar text-success me-2"></i>HÓA ĐƠN BÁN HÀNG #${order.orderId}
                            </h3>
                            <div class="text-success fw-semibold">
                                <i class="fa-solid fa-circle-check me-1"></i>Mã hóa đơn: #HD-${order.orderId} (ĐÃ THU TIỀN COD)
                            </div>
                        </c:when>
                        <c:when test="${order.status eq 'CANCELLED'}">
                            <h3 class="fw-bold text-secondary mb-1">
                                <i class="fa-solid fa-ban text-danger me-2"></i>PHIẾU HỦY ĐƠN HÀNG #${order.orderId}
                            </h3>
                            <div class="text-danger fw-semibold">
                                <i class="fa-solid fa-ban me-1"></i>ĐÃ HỦY - KHÔNG XUẤT HÓA ĐƠN
                            </div>
                        </c:when>
                        <c:when test="${order.status eq 'RETURNED'}">
                            <h3 class="fw-bold text-dark mb-1">
                                <i class="fa-solid fa-arrow-rotate-left text-dark me-2"></i>PHIẾU ĐƠN HÀNG HOÀN TRẢ #${order.orderId}
                            </h3>
                            <div class="text-dark fw-semibold">
                                <i class="fa-solid fa-boxes-stacked me-1"></i>ĐÃ HOÀN TRẢ KHO - KHÔNG XUẤT HÓA ĐƠN
                            </div>
                        </c:when>
                        <c:otherwise>
                            <h3 class="fw-bold text-primary mb-1">
                                <i class="fa-solid fa-truck-ramp-box text-primary me-2"></i>PHIẾU GIAO HÀNG (COD) #${order.orderId}
                            </h3>
                            <div class="text-warning fw-semibold">
                                <i class="fa-solid fa-clock me-1"></i>CHƯA THU TIỀN - CHỜ GIAO HÀNG ĐỂ XUẤT HÓA ĐƠN
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="text-muted small mt-1">
                        Ngày tạo đơn: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                    </div>
                </div>

                <!-- Form cập nhật trạng thái & Nút in -->
                <div class="d-flex align-items-center gap-2 flex-wrap no-print">
                    <form action="${pageContext.request.contextPath}/admin/order-update-status" method="post" class="d-flex align-items-center gap-2">
                        <input type="hidden" name="orderId" value="${order.orderId}">
                        <input type="hidden" name="redirectUrl" value="/admin/order-detail?id=${order.orderId}">
                        <label class="fw-bold text-secondary mb-0">Trạng thái:</label>
                        <select name="status" class="form-select form-select-sm" style="min-width: 190px;">
                            <option value="NEW" ${order.status eq 'NEW' or order.status eq 'PENDING' ? 'selected' : ''}>Đơn hàng mới</option>
                            <option value="CONFIRMED" ${order.status eq 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="PREPARING" ${order.status eq 'PREPARING' or order.status eq 'PROCESSING' ? 'selected' : ''}>Chuẩn bị hàng</option>
                            <option value="SHIPPING" ${order.status eq 'SHIPPING' ? 'selected' : ''}>Vận chuyển</option>
                            <option value="DELIVERING" ${order.status eq 'DELIVERING' ? 'selected' : ''}>Giao hàng</option>
                            <option value="DELIVERED" ${order.status eq 'DELIVERED' ? 'selected' : ''}>Đã giao</option>
                            <option value="CANCELLED" ${order.status eq 'CANCELLED' ? 'selected' : ''}>Đơn hàng hủy</option>
                            <option value="RETURNED" ${order.status eq 'RETURNED' ? 'selected' : ''}>Đơn hàng hoàn</option>
                        </select>
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="fa-solid fa-floppy-disk me-1"></i>Cập Nhật
                        </button>
                    </form>

                    <c:choose>
                        <c:when test="${order.status eq 'DELIVERED'}">
                            <button type="button" onclick="window.print()" class="btn btn-success btn-sm fw-semibold">
                                <i class="fa-solid fa-print me-1"></i>In Hóa Đơn Bán Hàng
                            </button>
                        </c:when>
                        <c:when test="${order.status eq 'CANCELLED'}">
                            <button type="button" class="btn btn-secondary btn-sm" disabled title="Đơn hàng đã hủy, không xuất hóa đơn">
                                <i class="fa-solid fa-ban me-1"></i>Không Có Hóa Đơn (Đã Hủy)
                            </button>
                        </c:when>
                        <c:when test="${order.status eq 'RETURNED'}">
                            <button type="button" class="btn btn-dark btn-sm" disabled title="Đơn hàng đã hoàn trả, không xuất hóa đơn">
                                <i class="fa-solid fa-arrow-rotate-left me-1"></i>Không Có Hóa Đơn (Đã Hoàn)
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" onclick="window.print()" class="btn btn-outline-primary btn-sm fw-semibold">
                                <i class="fa-solid fa-print me-1"></i>In Phiếu Giao Hàng
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Thông tin: BÊN GỬI & BÊN NHẬN -->
    <div class="row g-4 mb-4">
        <!-- BÊN GỬI -->
        <div class="col-md-6">
            <div class="party-card party-sender">
                <div class="party-title d-flex justify-content-between align-items-center">
                    <span><i class="fa-solid fa-warehouse me-2"></i>BÊN GỬI (Đơn Vị Xuất Kho)</span>
                    <span class="badge bg-primary">Người Bán</span>
                </div>
                <div class="mb-2">
                    <strong class="text-dark fs-6">TRUNG TÂM PHÁT HÀNH VIDEO &amp; KHÓA HỌC WEBVIDEO</strong>
                </div>
                <div class="mb-1 text-secondary">
                    <strong>Đại diện / Quản lý:</strong> Trịnh Văn Phú Hào (MSSV: <strong>24110013</strong>)
                </div>
                <div class="mb-1 text-secondary">
                    <strong>Kho xuất:</strong> Số 1 Võ Văn Ngân, Phường Linh Chiểu, TP. Thủ Đức, TP. Hồ Chí Minh
                </div>
                <div class="mb-0 text-secondary">
                    <strong>Hotline CSKH:</strong> 0373 703 896 | <strong>Mã đề:</strong> 03
                </div>
            </div>
        </div>

        <!-- BÊN NHẬN -->
        <div class="col-md-6">
            <div class="party-card party-receiver">
                <div class="party-title d-flex justify-content-between align-items-center">
                    <span><i class="fa-solid fa-user-check me-2"></i>BÊN NHẬN (Khách Hàng)</span>
                    <span class="badge bg-success">Người Nhận</span>
                </div>
                <div class="mb-2">
                    <strong class="text-dark fs-6">${order.recipientName}</strong>
                    <c:if test="${not empty order.user}">
                        <span class="badge bg-secondary ms-2">@${order.user.username} (${order.user.email})</span>
                    </c:if>
                </div>
                <div class="mb-1 text-secondary">
                    <strong>Số điện thoại:</strong> <span class="text-dark fw-bold">${order.phone}</span>
                </div>
                <div class="mb-1 text-secondary">
                    <strong>Địa chỉ giao:</strong> ${order.address}
                </div>
                <div class="mb-0 text-secondary">
                    <strong>Ghi chú:</strong> <span class="fst-italic text-dark">${empty order.note ? 'Không có ghi chú' : order.note}</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Bảng sản phẩm trong đơn -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-header bg-white fw-bold">
            <i class="fa-solid fa-table-list me-2 text-primary"></i>Danh Sách Sản Phẩm Trong Đơn
        </div>
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width: 50px;">#</th>
                        <th>Sản phẩm</th>
                        <th>Mã Video</th>
                        <th class="text-center">Số lượng đặt</th>
                        <th class="text-end">Đơn giá</th>
                        <th class="text-end">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="detail" items="${order.orderDetails}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="${detail.video.poster}" alt="${detail.video.title}" width="60" height="40" class="rounded me-2 object-fit-cover" onerror="this.src='https://picsum.photos/60/40?random=1'">
                                    <div class="fw-semibold text-dark">${detail.video.title}</div>
                                </div>
                            </td>
                            <td><code>${detail.video.videoId}</code></td>
                            <td class="text-center fw-bold fs-6">${detail.quantity}</td>
                            <td class="text-end text-muted"><fmt:formatNumber value="${detail.price}" pattern="#,##0"/> ₫</td>
                            <td class="text-end fw-bold text-dark"><fmt:formatNumber value="${detail.subtotal}" pattern="#,##0"/> ₫</td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="5" class="text-end fw-semibold">Phí vận chuyển COD:</td>
                        <td class="text-end fw-semibold">
                            <c:choose>
                                <c:when test="${order.shippingFee == 0}">Miễn phí</c:when>
                                <c:otherwise><fmt:formatNumber value="${order.shippingFee}" pattern="#,##0"/> ₫</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr class="table-light">
                        <td colspan="5" class="text-end fw-bold fs-5 text-dark">Tổng tiền COD thu của khách:</td>
                        <td class="text-end fw-bold fs-5 text-danger">
                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> ₫
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>

    <!-- Khu vực Chữ Ký Xác Nhận (3 Bên: Đại diện bên gửi, Giao hàng, Người nhận) -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body p-4">
            <div class="row text-center">
                <div class="col-4">
                    <div class="signature-box">
                        <div class="signature-title">NGƯỜI LẬP / THỦ KHO</div>
                        <div class="signature-note">(Ký &amp; ghi rõ họ tên)</div>
                        <div class="signature-space d-flex align-items-center justify-content-center">
                            <span class="text-danger fw-bold fst-italic">Trịnh Văn Phú Hào</span>
                        </div>
                        <div class="fw-bold text-dark">Trịnh Văn Phú Hào</div>
                        <div class="small text-muted">MSSV: 24110013</div>
                    </div>
                </div>

                <div class="col-4">
                    <div class="signature-box">
                        <div class="signature-title">NHÂN VIÊN GIAO HÀNG</div>
                        <div class="signature-note">(Ký nhận tiền &amp; bàn giao)</div>
                        <div class="signature-space"></div>
                        <div class="fw-semibold text-secondary">Họ tên: .........................</div>
                    </div>
                </div>

                <div class="col-4">
                    <div class="signature-box">
                        <div class="signature-title">KHÁCH HÀNG NHẬN</div>
                        <div class="signature-note">(Đã nhận đủ hàng &amp; trả tiền)</div>
                        <div class="signature-space"></div>
                        <div class="fw-semibold text-dark">${order.recipientName}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quay lại -->
    <div class="no-print">
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary">
            <i class="fa-solid fa-arrow-left me-1"></i>Quay lại danh sách đơn hàng
        </a>
    </div>

</div>

</body>
</html>
