package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.Order_24110013;
import vn.iotstar.entity.User_24110013;
import vn.iotstar.service.IOrderService_24110013;
import vn.iotstar.service.OrderService_24110013;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/my-orders", "/order-detail", "/order-cancel"})
public class OrderController_24110013 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IOrderService_24110013 orderService = new OrderService_24110013();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        User_24110013 user = (session != null) ? (User_24110013) session.getAttribute("account") : null;

        if ("/order-cancel".equals(path)) {
            String orderId = req.getParameter("id");
            if (orderId != null) {
                Order_24110013 order = orderService.findById(orderId);
                // Bảo mật: Nếu đã đăng nhập thì chỉ hủy đơn của mình hoặc admin
                if (order != null) {
                    if (user != null && order.getUser() != null && !user.getUsername().equals(order.getUser().getUsername()) && !Boolean.TRUE.equals(user.getAdmin())) {
                        req.getSession().setAttribute("orderError", "Bạn không có quyền hủy đơn hàng này!");
                    } else if (!order.isCancellable()) {
                        req.getSession().setAttribute("orderError", "Đơn hàng đang ở trạng thái \"" + order.getStatusVietnamese() + "\" nên không thể tự hủy!");
                    } else {
                        boolean ok = orderService.cancelOrder(orderId);
                        if (ok) {
                            req.getSession().setAttribute("orderSuccess", "Đã hủy đơn hàng #" + orderId + " thành công và hoàn trả số lượng vào kho!");
                        } else {
                            req.getSession().setAttribute("orderError", "Hủy đơn hàng thất bại, vui lòng thử lại!");
                        }
                    }
                }
            }
            resp.sendRedirect(req.getContextPath() + "/my-orders");
            return;
        }

        if ("/order-detail".equals(path)) {
            String orderId = req.getParameter("id");
            if (orderId == null || orderId.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/my-orders");
                return;
            }
            Order_24110013 order = orderService.findById(orderId);
            if (order == null) {
                resp.sendRedirect(req.getContextPath() + "/my-orders");
                return;
            }
            req.setAttribute("order", order);
            req.getRequestDispatcher("/views/web/order-detail.jsp").forward(req, resp);
            return;
        }

        // /my-orders: Lọc theo 8 trạng thái
        String statusFilter = req.getParameter("status");
        if (statusFilter != null) {
            statusFilter = statusFilter.trim();
            if (statusFilter.isEmpty() || "ALL".equalsIgnoreCase(statusFilter)) {
                statusFilter = null;
            }
        }

        List<Order_24110013> orders = new ArrayList<>();
        java.util.Map<String, Long> statusCounts = new java.util.LinkedHashMap<>();

        if (user != null) {
            statusCounts = orderService.countOrdersByStatusForUser(user.getUsername());
            if (statusFilter != null) {
                orders = orderService.findByUsernameAndStatus(user.getUsername(), statusFilter);
            } else {
                orders = orderService.findByUsername(user.getUsername());
            }
        }

        // Xóa sạch cookie client_orders cũ (nếu có trong trình duyệt) để bảo mật thông tin, không rò rỉ đơn hàng khi chưa đăng nhập
        jakarta.servlet.http.Cookie cleanCookie = new jakarta.servlet.http.Cookie("client_orders", "");
        cleanCookie.setMaxAge(0);
        cleanCookie.setPath("/");
        resp.addCookie(cleanCookie);

        // Sắp xếp đơn mới nhất lên đầu
        orders.sort((o1, o2) -> {
            if (o1.getOrderDate() == null || o2.getOrderDate() == null) return 0;
            return o2.getOrderDate().compareTo(o1.getOrderDate());
        });

        // Lấy thông báo từ session nếu có
        if (session != null && session.getAttribute("orderSuccess") != null) {
            req.setAttribute("successMessage", session.getAttribute("orderSuccess"));
            session.removeAttribute("orderSuccess");
        }
        if (session != null && session.getAttribute("orderError") != null) {
            req.setAttribute("errorMessage", session.getAttribute("orderError"));
            session.removeAttribute("orderError");
        }

        req.setAttribute("orders", orders);
        req.setAttribute("currentStatus", statusFilter != null ? statusFilter.toUpperCase() : "ALL");
        req.setAttribute("statusCounts", statusCounts);
        req.getRequestDispatcher("/views/web/my-orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Tra cứu đơn hàng theo mã đơn, SĐT hoặc Tên người nhận
        String searchOrderId = req.getParameter("searchOrderId");
        if (searchOrderId != null && !searchOrderId.trim().isEmpty()) {
            String queryStr = searchOrderId.trim();
            // 1. Tìm chính xác theo mã đơn
            Order_24110013 order = orderService.findById(queryStr);
            if (order != null) {
                resp.sendRedirect(req.getContextPath() + "/order-detail?id=" + order.getOrderId());
                return;
            }

            // 2. Tìm theo số điện thoại hoặc tên người nhận
            jakarta.persistence.EntityManager em = vn.iotstar.config.JpaConfig_24110013.getEntityManager();
            try {
                List<Order_24110013> searchResults = em.createQuery(
                        "SELECT o FROM Order_24110013 o WHERE o.phone = :q OR o.recipientName LIKE :name ORDER BY o.orderDate DESC", Order_24110013.class)
                        .setParameter("q", queryStr)
                        .setParameter("name", "%" + queryStr + "%")
                        .getResultList();
                if (!searchResults.isEmpty()) {
                    if (searchResults.size() == 1) {
                        resp.sendRedirect(req.getContextPath() + "/order-detail?id=" + searchResults.get(0).getOrderId());
                        return;
                    }
                    req.setAttribute("orders", searchResults);
                    req.setAttribute("successMessage", "Tìm thấy " + searchResults.size() + " đơn hàng phù hợp với: \"" + queryStr + "\"");
                    req.getRequestDispatcher("/views/web/my-orders.jsp").forward(req, resp);
                    return;
                }
            } finally {
                em.close();
            }

            req.setAttribute("errorMessage", "Không tìm thấy đơn hàng nào có mã đơn, số điện thoại hoặc tên: \"" + queryStr + "\"");
        }
        doGet(req, resp);
    }
}
