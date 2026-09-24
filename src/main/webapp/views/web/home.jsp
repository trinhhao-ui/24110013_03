<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Trang Chủ - Danh Sách Video Theo Chuyên Mục (Đề 03)</title>
    <style>
        .table-exam {
            width: 100%;
            table-layout: fixed; /* Bắt buộc để 3 cột luôn cố định đúng 33.33%, không bị nhảy/giật */
            border-collapse: collapse;
            border: 1px solid #000000;
            margin-bottom: 35px;
            background-color: #ffffff;
        }
        .table-exam th, .table-exam td {
            border: 1px solid #000000;
        }
        .cat-title-cell {
            padding: 8px 12px;
            font-size: 1.15rem;
            font-weight: 600;
            color: #000000;
            background-color: #ffffff;
            text-align: left;
        }
        .poster-td {
            width: 33.333%;
            padding: 6px;
            text-align: center;
            vertical-align: middle;
            background-color: #ffffff;
        }
        .poster-td a {
            display: block;
            width: 100%;
            height: 180px;
            overflow: hidden;
            background-color: #2c3e50;
        }
        .poster-td img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            display: block;
        }
        .info-td {
            width: 33.333%;
            padding: 8px 12px;
            vertical-align: top;
            font-size: 0.95rem;
            line-height: 1.65;
            color: #000000;
            background-color: #ffffff;
        }
        .info-td strong {
            color: #000000;
        }
        .video-title-link {
            color: #000000;
            text-decoration: none;
            font-weight: 500;
        }
        .video-title-link:hover {
            color: #0d6efd;
            text-decoration: underline;
        }
        .action-link {
            color: #0000ee;
            text-decoration: underline;
        }
        .action-link:hover {
            color: #ff0000;
        }
        .pagination-td {
            text-align: center;
            padding: 8px;
            font-size: 1.1rem;
            letter-spacing: 2px;
            background-color: #ffffff;
        }
        .pagination-td a {
            color: #0000ee;
            text-decoration: none;
            padding: 0 4px;
        }
        .pagination-td a:hover {
            text-decoration: underline;
        }
        .page-current {
            font-weight: bold;
            color: #000000;
            padding: 0 4px;
            text-decoration: underline;
        }
        .page-disabled {
            color: #888888;
            padding: 0 4px;
        }
    </style>
</head>
<body>

<div class="container py-3">

    <!-- Danh sách theo từng Category theo đúng 100% mẫu bảng Word của Đề thi (Câu 4 & Câu 5) -->
    <c:forEach var="catItem" items="${categoryList}">
        <div id="cat-${catItem.category.categoryId}">
            <table class="table-exam">
                <!-- Hàng 1: Category Name (Count) -->
                <thead>
                    <tr>
                        <th colspan="3" class="cat-title-cell">
                            ${catItem.category.categoryname} (${catItem.totalVideos})
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Hàng 2: [poster] của 3 video -->
                    <tr>
                        <c:forEach var="vItem" items="${catItem.videoItems}">
                            <td class="poster-td">
                                <a href="${pageContext.request.contextPath}/video-detail?id=${vItem.video.videoId}">
                                    <img src="${vItem.video.poster}" 
                                         alt="${vItem.video.title}"
                                         width="300"
                                         height="180"
                                         onerror="this.onerror=null; this.src='data:image/svg+xml;charset=UTF-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22300%22%20height%3D%22180%22%20viewBox%3D%220%200%20300%20180%22%3E%3Crect%20width%3D%22300%22%20height%3D%22180%22%20fill%3D%22%232c3e50%22%2F%3E%3Cpolygon%20points%3D%22135%2C75%20135%2C105%20170%2C90%22%20fill%3D%22%23ffffff%22%2F%3E%3Ctext%20x%3D%2250%25%22%20y%3D%22135%22%20font-size%3D%2213%22%20fill%3D%22%23ffffff%22%20text-anchor%3D%22middle%22%20font-family%3D%22sans-serif%22%3E${vItem.video.videoId}%3C%2Ftext%3E%3C%2Fsvg%3E';">
                                </a>
                            </td>
                        </c:forEach>
                        <!-- Nếu danh mục có ít hơn 3 video thì thêm ô trống để luôn giữ đúng 3 cột -->
                        <c:if test="${catItem.videoItems.size() < 3}">
                            <c:forEach begin="1" end="${3 - catItem.videoItems.size()}">
                                <td class="poster-td"></td>
                            </c:forEach>
                        </c:if>
                    </tr>

                    <!-- Hàng 3: Thông tin chi tiết của 3 video -->
                    <tr>
                        <c:forEach var="vItem" items="${catItem.videoItems}">
                            <td class="info-td">
                                <div>
                                    <strong>Tiêu đề:</strong>
                                    <a href="${pageContext.request.contextPath}/video-detail?id=${vItem.video.videoId}" class="video-title-link">
                                        ${vItem.video.title}
                                    </a>
                                </div>
                                <div>
                                    <strong>Mã video:</strong> ${vItem.video.videoId}
                                </div>
                                <div>
                                    <strong>Category name:</strong> ${catItem.category.categoryname}
                                </div>
                                <div>
                                    <strong>View:</strong> ${vItem.video.views}
                                </div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/video-detail?id=${vItem.video.videoId}" class="action-link">
                                        Share(${vItem.shareCount})
                                    </a>
                                </div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/video-detail?id=${vItem.video.videoId}" class="action-link">
                                        Like(${vItem.likeCount})
                                    </a>
                                </div>
                            </td>
                        </c:forEach>
                        <!-- Bù ô trống nếu ít hơn 3 video -->
                        <c:if test="${catItem.videoItems.size() < 3}">
                            <c:forEach begin="1" end="${3 - catItem.videoItems.size()}">
                                <td class="info-td"></td>
                            </c:forEach>
                        </c:if>
                    </tr>

                    <!-- Hàng 4: Phân trang << 1 2 3 4 5 >> -->
                    <tr>
                        <td colspan="3" class="pagination-td">
                            <c:choose>
                                <c:when test="${catItem.currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/home?p_${catItem.category.categoryId}=${catItem.currentPage - 1}#cat-${catItem.category.categoryId}">&lt;&lt;</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-disabled">&lt;&lt;</span>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach var="p" begin="1" end="${catItem.totalPages}">
                                <c:choose>
                                    <c:when test="${catItem.currentPage == p}">
                                        <span class="page-current">${p}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/home?p_${catItem.category.categoryId}=${p}#cat-${catItem.category.categoryId}">${p}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${catItem.currentPage < catItem.totalPages}">
                                    <a href="${pageContext.request.contextPath}/home?p_${catItem.category.categoryId}=${catItem.currentPage + 1}#cat-${catItem.category.categoryId}">&gt;&gt;</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-disabled">&gt;&gt;</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </c:forEach>

</div>

</body>
</html>
