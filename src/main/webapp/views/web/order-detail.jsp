<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title><c:choose><c:when test="${order.status eq 'DELIVERED'}">Hóa Đơn Bán Hàng #${order.orderId}</c:when><c:otherwise>Phiếu Đơn Hàng #${order.orderId}</c:otherwise></c:choose> - WebVideo (Đề 03)</title>
    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,&lt;svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'&gt;&lt;circle cx='50' cy='50' r='50' fill='%23ff4757'/&gt;&lt;polygon points='40,30 40,70 75,50' fill='%23ffffff'/&gt;&lt;/svg&gt;">
    <style>
        .invoice-wrapper {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
            padding: 40px;
            margin-bottom: 40px;
            position: relative;
        }
        .invoice-header-title {
            letter-spacing: 1px;
            font-weight: 800;
            color: #1e272e;
        }
        .stamp-paid {
            display: inline-block;
            padding: 5px 14px;
            text-transform: uppercase;
            font-weight: 800;
            font-size: 0.9rem;
            color: #16a34a;
            border: 2px dashed #16a34a;
            border-radius: 6px;
            letter-spacing: 1px;
            transform: rotate(-3deg);
            background-color: #f0fdf4;
        }
        .stamp-not-delivered {
            display: inline-block;
            padding: 5px 14px;
            text-transform: uppercase;
            font-weight: 700;
            font-size: 0.85rem;
            color: #d97706;
            border: 2px dashed #d97706;
            border-radius: 6px;
            background-color: #fffbeb;
        }
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
        .table-invoice th {
            background-color: #f1f5f9;
            color: #334155;
            font-weight: 700;
            vertical-align: middle;
            border-top: 1px solid #cbd5e1;
            border-bottom: 2px solid #cbd5e1;
        }
        .table-invoice td {
            vertical-align: middle;
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
            height: 80px;
        }
        .cod-notice-banner {
            background-color: #f0fdf4;
            border: 1px dashed #22c55e;
            border-radius: 8px;
            padding: 12px 16px;
        }
        @media print {
            .no-print { display: none !important; }
            body { background-color: #ffffff !important; padding: 0 !important; }
            .invoice-wrapper {
                box-shadow: none !important;
                border: 1px solid #000000 !important;
                padding: 20px !important;
                margin: 0 !important;
                border-radius: 0 !important;
            }
            .party-card {
                background: #ffffff !important;
                border: 1px solid #000000 !important;
            }
            .table-invoice th {
                background-color: #f0f0f0 !important;
                color: #000000 !important;
                border: 1px solid #000000 !important;
            }
            .table-invoice td {
                border: 1px solid #000000 !important;
            }
            .badge {
                border: 1px solid #000000 !important;
                color: #000000 !important;
                background: transparent !important;
            }
        }
    </style>
</head>
<body>

<div class="container py-4">

    <!-- Breadcrumb điều hướng -->
    <nav aria-label="breadcrumb" class="mb-4 no-print">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/my-orders">Lịch sử đơn hàng</a></li>
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
                    <h6 class="fw-bold mb-1">ĐƠN HÀNG ĐÃ GIAO THÀNH CÔNG &amp; THU TIỀN COD HOÀN TẤT</h6>
                    <small>Hóa đơn bán hàng chính thức đã được phát hành hợp lệ. Quý khách có thể xem hoặc in lưu trữ hóa đơn bên dưới.</small>
                </div>
            </div>
        </c:when>
        <c:when test="${order.status eq 'CANCELLED'}">
            <div class="alert alert-danger border-danger d-flex align-items-center mb-4 no-print" role="alert">
                <i class="fa-solid fa-ban fs-2 text-danger me-3"></i>
                <div>
                    <h6 class="fw-bold mb-1">ĐƠN HÀNG ĐÃ HỦY - KHÔNG PHÁT HÀNH HÓA ĐƠN</h6>
                    <small>Đơn hàng này đã bị hủy, toàn bộ số lượng video đã được hoàn trả lại kho hàng. Hệ thống không xuất hóa đơn cho các đơn đã hủy.</small>
                </div>
            </div>
        </c:when>
        <c:when test="${order.status eq 'RETURNED'}">
            <div class="alert alert-dark border-dark d-flex align-items-center mb-4 no-print" role="alert">
                <i class="fa-solid fa-arrow-rotate-left fs-2 text-dark me-3"></i>
                <div>
                    <h6 class="fw-bold mb-1">ĐƠN HÀNG HOÀN TRẢ VỀ KHO - KHÔNG PHÁT HÀNH HÓA ĐƠN</h6>
                    <small>Đơn hàng giao không thành công hoặc đã hoàn trả về kho. Hệ thống không xuất hóa đơn cho các đơn hàng hoàn.</small>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-warning border-warning d-flex align-items-center mb-4 no-print" role="alert">
                <i class="fa-solid fa-clock-rotate-left fs-2 text-warning me-3"></i>
                <div>
                    <h6 class="fw-bold mb-1">ĐƠN HÀNG ĐANG TRONG QUÁ TRÌNH XỬ LÝ / VẬN CHUYỂN (${order.statusVietnamese})</h6>
                    <small>Theo đúng logic nghiệp vụ bán hàng COD: <strong>Hóa đơn bán hàng chính thức chỉ được phát hành sau khi đơn hàng được giao thành công và thanh toán tiền mặt hoàn tất</strong>. Dưới đây là <em>Phiếu xác nhận giao nhận hàng</em>.</small>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Khung Hóa Đơn / Phiếu Giao Hàng -->
    <div class="invoice-wrapper">

        <!-- Tiêu đề & Thông tin đầu phiếu -->
        <div class="row align-items-center border-bottom pb-4 mb-4">
            <div class="col-md-7">
                <div class="d-flex align-items-center mb-2">
                    <span class="fs-2 text-danger me-2"><i class="fa-solid fa-play-circle"></i></span>
                    <div>
                        <h4 class="fw-bold mb-0 text-dark">HỆ THỐNG PHÂN PHỐI VIDEO - WEBVIDEO</h4>
                        <small class="text-secondary">Trường ĐH Sư Phạm Kỹ Thuật TP.HCM - Môn Lập Trình Web</small>
                    </div>
                </div>
                <div class="small text-muted">
                    <div><i class="fa-solid fa-location-dot me-2 text-danger"></i>Địa chỉ kho: Số 1 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức, TP.HCM</div>
                    <div><i class="fa-solid fa-phone me-2 text-primary"></i>Hotline CSKH: <strong>0373.703.896</strong> | Email: <strong>hotro.webvideo24110013@gmail.com</strong></div>
                </div>
            </div>

            <div class="col-md-5 text-md-end mt-3 mt-md-0">
                <c:choose>
                    <c:when test="${order.status eq 'DELIVERED'}">
                        <h3 class="invoice-header-title mb-1 text-success">HÓA ĐƠN BÁN HÀNG</h3>
                        <div class="text-muted fw-semibold mb-2">KIÊM PHIẾU THU TIỀN COD ĐÃ HOÀN TẤT</div>
                        <div>Mã hóa đơn: <strong class="text-danger fs-5">#HD-${order.orderId}</strong></div>
                    </c:when>
                    <c:when test="${order.status eq 'CANCELLED'}">
                        <h3 class="invoice-header-title mb-1 text-secondary">PHIẾU HỦY ĐƠN HÀNG</h3>
                        <div class="text-muted fw-semibold mb-2">ĐÃ HỦY - KHÔNG XUẤT HÓA ĐƠN</div>
                        <div>Mã đơn: <strong class="text-secondary fs-5">#${order.orderId}</strong></div>
                    </c:when>
                    <c:when test="${order.status eq 'RETURNED'}">
                        <h3 class="invoice-header-title mb-1 text-dark">PHIẾU ĐƠN HÀNG HOÀN TRẢ</h3>
                        <div class="text-muted fw-semibold mb-2">ĐÃ HOÀN VỀ KHO - KHÔNG XUẤT HÓA ĐƠN</div>
                        <div>Mã đơn: <strong class="text-secondary fs-5">#${order.orderId}</strong></div>
                    </c:when>
                    <c:otherwise>
                        <h3 class="invoice-header-title mb-1 text-primary">PHIẾU GIAO HÀNG (COD)</h3>
                        <div class="text-muted fw-semibold mb-2">XÁC NHẬN GIAO HÀNG &amp; THU TIỀN TẬN NƠI</div>
                        <div>Mã phiếu: <strong class="text-danger fs-5">#${order.orderId}</strong></div>
                    </c:otherwise>
                </c:choose>

                <div class="small text-muted">
                    Ngày lập: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                </div>
                <div class="mt-2 d-flex align-items-center justify-content-md-end gap-2 flex-wrap">
                    <span class="badge ${order.statusBadgeClass} fs-6 px-3 py-2">
                        ${order.statusVietnamese}
                    </span>
                    <c:choose>
                        <c:when test="${order.status eq 'DELIVERED'}">
                            <span class="stamp-paid"><i class="fa-solid fa-stamp me-1"></i>ĐÃ THU COD</span>
                        </c:when>
                        <c:when test="${order.status eq 'CANCELLED'}">
                            <span class="badge bg-danger fs-6 px-3 py-2">HỦY</span>
                        </c:when>
                        <c:when test="${order.status eq 'RETURNED'}">
                            <span class="badge bg-dark fs-6 px-3 py-2">HOÀN TRẢ</span>
                        </c:when>
                        <c:otherwise>
                            <span class="stamp-not-delivered"><i class="fa-solid fa-hourglass-half me-1"></i>CHƯA THU TIỀN</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Khối Thông Tin: BÊN GỬI & BÊN NHẬN -->
        <div class="row g-4 mb-4">
            <!-- BÊN GỬI (Đơn vị bán hàng) -->
            <div class="col-md-6">
                <div class="party-card party-sender">
                    <div class="party-title d-flex justify-content-between align-items-center">
                        <span><i class="fa-solid fa-warehouse me-2"></i>BÊN GỬI (Đơn Vị Bán Hàng)</span>
                        <span class="badge bg-primary">Người Bán</span>
                    </div>
                    <div class="mb-2">
                        <strong class="text-dark fs-6">TRUNG TÂM PHÁT HÀNH VIDEO &amp; KHÓA HỌC WEBVIDEO</strong>
                    </div>
                    <div class="mb-1 text-secondary">
                        <strong>Người đại diện:</strong> Trịnh Văn Phú Hào (MSSV: <strong>24110013</strong>)
                    </div>
                    <div class="mb-1 text-secondary">
                        <strong>Mã đề thi:</strong> Đề số <strong>03</strong> (Học kỳ 1 - Năm học 2026-2027)
                    </div>
                    <div class="mb-1 text-secondary">
                        <strong>Kho xuất hàng:</strong> Số 1 Võ Văn Ngân, Phường Linh Chiểu, TP. Thủ Đức, TP. Hồ Chí Minh
                    </div>
                    <div class="mb-0 text-secondary">
                        <strong>Điện thoại:</strong> 0373 703 896 | <strong>Website:</strong> localhost:8080/WebVideo_24110013
                    </div>
                </div>
            </div>

            <!-- BÊN NHẬN (Khách hàng) -->
            <div class="col-md-6">
                <div class="party-card party-receiver">
                    <div class="party-title d-flex justify-content-between align-items-center">
                        <span><i class="fa-solid fa-user-check me-2"></i>BÊN NHẬN (Khách Hàng)</span>
                        <span class="badge bg-success">Người Nhận</span>
                    </div>
                    <div class="mb-2">
                        <strong class="text-dark fs-6">${order.recipientName}</strong>
                        <c:if test="${not empty order.user}">
                            <span class="badge bg-light text-dark border ms-2">@${order.user.username}</span>
                        </c:if>
                    </div>
                    <div class="mb-1 text-secondary">
                        <strong>Số điện thoại:</strong> <span class="text-dark fw-bold">${order.phone}</span>
                    </div>
                    <div class="mb-1 text-secondary">
                        <strong>Địa chỉ giao hàng:</strong> ${order.address}
                    </div>
                    <div class="mb-1 text-secondary">
                        <strong>Phương thức thanh toán:</strong> 
                        <span class="badge bg-success-subtle text-success border border-success px-2 py-1">
                            <i class="fa-solid fa-money-bill-wave me-1"></i>Thanh toán tiền mặt khi nhận hàng (COD)
                        </span>
                    </div>
                    <div class="mb-0 text-secondary">
                        <strong>Ghi chú giao hàng:</strong> 
                        <span class="fst-italic text-dark">${empty order.note ? 'Cho kiểm tra hàng trước khi thanh toán' : order.note}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bảng danh sách hàng hóa chi tiết -->
        <div class="mb-4">
            <h5 class="fw-bold mb-3 text-dark">
                <i class="fa-solid fa-boxes-packing me-2 text-primary"></i>CHI TIẾT HÀNG HÓA &amp; DỊCH VỤ
            </h5>
            <div class="table-responsive">
                <table class="table table-invoice table-bordered align-middle mb-0">
                    <thead>
                        <tr class="text-center">
                            <th style="width: 50px;">STT</th>
                            <th style="width: 100px;" class="no-print">Hình ảnh</th>
                            <th style="width: 120px;">Mã Video</th>
                            <th class="text-start">Tên Sản Phẩm / Video Khóa Học</th>
                            <th style="width: 110px;">Số Lượng</th>
                            <th style="width: 140px;" class="text-end">Đơn Giá</th>
                            <th style="width: 150px;" class="text-end">Thành Tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${order.orderDetails}" varStatus="loop">
                            <tr>
                                <td class="text-center fw-semibold text-secondary">${loop.index + 1}</td>
                                <td class="text-center no-print">
                                    <img src="${item.video.poster}" alt="${item.video.title}" width="70" height="45" 
                                         class="rounded object-fit-cover border" onerror="this.src='https://picsum.photos/70/45?random=1'">
                                </td>
                                <td class="text-center"><code>${item.video.videoId}</code></td>
                                <td>
                                    <div class="fw-bold text-dark">${item.video.title}</div>
                                    <small class="text-muted">Chuyên mục: ${item.video.category.categoryname}</small>
                                </td>
                                <td class="text-center fw-bold fs-6">${item.quantity}</td>
                                <td class="text-end text-muted">
                                    <fmt:formatNumber value="${item.price}" pattern="#,##0"/> ₫
                                </td>
                                <td class="text-end fw-bold text-dark fs-6">
                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> ₫
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="5" class="text-end fw-semibold text-secondary">
                                Tổng cộng tiền hàng (Tạm tính):
                            </td>
                            <td colspan="2" class="text-end fw-bold text-dark">
                                <fmt:formatNumber value="${order.totalAmount - order.shippingFee}" pattern="#,##0"/> ₫
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5" class="text-end fw-semibold text-secondary">
                                Phí vận chuyển giao hàng tận nơi (COD):
                            </td>
                            <td colspan="2" class="text-end fw-semibold text-dark">
                                <c:choose>
                                    <c:when test="${order.shippingFee == 0}">
                                        <span class="text-success fw-bold">Miễn phí giao hàng</span>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${order.shippingFee}" pattern="#,##0"/> ₫
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr class="table-light">
                            <td colspan="5" class="text-end fw-bold fs-5 text-dark">
                                TỔNG CỘNG TIỀN COD PHẢI THU KHI GIAO:
                            </td>
                            <td colspan="2" class="text-end fw-bold fs-4 text-danger">
                                <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> ₫
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>

        <!-- Banner quy định đồng kiểm COD -->
        <div class="cod-notice-banner mb-4">
            <div class="d-flex align-items-start">
                <i class="fa-solid fa-circle-check text-success fs-4 me-3 mt-1"></i>
                <div class="small">
                    <strong>Quy định nhận hàng &amp; Thanh toán COD:</strong>
                    Khách hàng được quyền kiểm tra sản phẩm trước khi thanh toán tiền mặt cho nhân viên giao hàng (Shipper). 
                    Nhân viên giao nhận chỉ thu đúng số tiền COD ghi trên phiếu giao hàng. 
                    Mọi vấn đề khiếu nại xin vui lòng gọi ngay hotline <strong>0373.703.896</strong> để được giải quyết tức thì.
                </div>
            </div>
        </div>

        <!-- Khu vực Chữ Ký Xác Nhận (3 Bên: Người gửi, Giao hàng, Người nhận) -->
        <div class="row pt-3 pb-2 text-center">
            <div class="col-4">
                <div class="signature-box">
                    <div class="signature-title">ĐẠI DIỆN BÊN GỬI</div>
                    <div class="signature-note">(Ký, đóng dấu &amp; ghi rõ họ tên)</div>
                    <div class="signature-space d-flex align-items-center justify-content-center">
                        <span class="text-danger fw-bold fst-italic fs-6">Trịnh Văn Phú Hào</span>
                    </div>
                    <div class="fw-bold text-dark">Trịnh Văn Phú Hào</div>
                    <div class="small text-muted">MSSV: 24110013</div>
                </div>
            </div>

            <div class="col-4">
                <div class="signature-box">
                    <div class="signature-title">NHÂN VIÊN GIAO HÀNG</div>
                    <div class="signature-note">(Ký nhận tiền &amp; bàn giao hàng)</div>
                    <div class="signature-space"></div>
                    <div class="fw-semibold text-secondary">Họ tên: .................................</div>
                    <div class="small text-muted">Ngày giao: ...../...../2026</div>
                </div>
            </div>

            <div class="col-4">
                <div class="signature-box">
                    <div class="signature-title">ĐẠI DIỆN BÊN NHẬN</div>
                    <div class="signature-note">(Xác nhận đã nhận đủ hàng &amp; trả tiền)</div>
                    <div class="signature-space"></div>
                    <div class="fw-semibold text-dark">${order.recipientName}</div>
                    <div class="small text-muted">Ngày nhận: ...../...../2026</div>
                </div>
            </div>
        </div>

        <!-- Các nút thao tác phía dưới (Không in) -->
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 pt-4 mt-3 border-top no-print">
            <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-secondary px-3 py-2">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách đơn hàng
            </a>

            <div class="d-flex gap-2">
                <c:choose>
                    <c:when test="${order.status eq 'DELIVERED'}">
                        <button type="button" onclick="window.print()" class="btn btn-success px-4 py-2 fw-semibold">
                            <i class="fa-solid fa-print me-2"></i> In Hóa Đơn Bán Hàng
                        </button>
                    </c:when>
                    <c:when test="${order.status eq 'CANCELLED'}">
                        <button type="button" class="btn btn-secondary px-4 py-2" disabled title="Đơn hàng đã hủy, không xuất hóa đơn">
                            <i class="fa-solid fa-ban me-2"></i> Không Có Hóa Đơn (Đã Hủy)
                        </button>
                    </c:when>
                    <c:when test="${order.status eq 'RETURNED'}">
                        <button type="button" class="btn btn-dark px-4 py-2" disabled title="Đơn hàng đã hoàn trả, không xuất hóa đơn">
                            <i class="fa-solid fa-arrow-rotate-left me-2"></i> Không Có Hóa Đơn (Đã Hoàn)
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" onclick="window.print()" class="btn btn-outline-primary px-4 py-2 fw-semibold">
                            <i class="fa-solid fa-print me-2"></i> In Phiếu Giao Hàng (COD)
                        </button>
                    </c:otherwise>
                </c:choose>

                <!-- Hủy đơn nếu còn NEW hoặc PENDING -->
                <c:if test="${order.isCancellable()}">
                    <a href="${pageContext.request.contextPath}/order-cancel?id=${order.orderId}" 
                       class="btn btn-outline-danger px-3 py-2"
                       onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng #${order.orderId}? Số lượng sẽ được hoàn lại kho.');">
                        <i class="fa-solid fa-ban me-1"></i> Hủy đơn hàng này
                    </a>
                </c:if>
            </div>
        </div>

    </div>

</div>

</body>
</html>
