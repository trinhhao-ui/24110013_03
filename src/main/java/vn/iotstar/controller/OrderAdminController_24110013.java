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
import java.util.List;

@WebServlet(urlPatterns = {
        "/admin/orders",
        "/admin/order-detail",
        "/admin/order-update-status"
})
public class OrderAdminController_24110013 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IOrderService_24110013 orderService = new OrderService_24110013();

    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=not_logged_in");
            return false;
        }
        User_24110013 user = (User_24110013) session.getAttribute("account");
        if (!Boolean.TRUE.equals(user.getAdmin())) {
            resp.sendRedirect(req.getContextPath() + "/login?error=access_denied");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        String path = req.getServletPath();

        if ("/admin/order-detail".equals(path)) {
            String orderId = req.getParameter("id");
            if (orderId == null || orderId.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
                return;
            }
            Order_24110013 order = orderService.findById(orderId);
            if (order == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
                return;
            }
            req.setAttribute("order", order);
            req.getRequestDispatcher("/views/admin/order-detail.jsp").forward(req, resp);
            return;
        }

        // /admin/orders
        String statusFilter = req.getParameter("status");
        List<Order_24110013> orders;
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            orders = orderService.findByStatus(statusFilter.trim());
        } else {
            orders = orderService.findAll();
        }

        // Lấy thông báo nếu có
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("adminOrderMsg") != null) {
            req.setAttribute("message", session.getAttribute("adminOrderMsg"));
            session.removeAttribute("adminOrderMsg");
        }

        req.setAttribute("orders", orders);
        req.setAttribute("currentStatus", statusFilter);
        req.getRequestDispatcher("/views/admin/order-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String path = req.getServletPath();

        if ("/admin/order-update-status".equals(path)) {
            String orderId = req.getParameter("orderId");
            String newStatus = req.getParameter("status");

            if (orderId != null && newStatus != null) {
                orderService.updateStatus(orderId, newStatus);
                req.getSession().setAttribute("adminOrderMsg", "Đã cập nhật trạng thái đơn hàng #" + orderId + " thành công!");
            }
            String redirectUrl = req.getParameter("redirectUrl");
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + redirectUrl);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
        }
    }
}
