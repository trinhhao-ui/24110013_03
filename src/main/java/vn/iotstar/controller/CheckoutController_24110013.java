package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.*;
import vn.iotstar.model.*;
import vn.iotstar.service.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(urlPatterns = {"/checkout", "/order-success"})
public class CheckoutController_24110013 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IOrderService_24110013 orderService = new OrderService_24110013();
    private IVideoService_24110013 videoService = new VideoService_24110013();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/order-success".equals(path)) {
            String orderId = req.getParameter("id");
            if (orderId == null || orderId.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
            Order_24110013 order = orderService.findById(orderId);
            if (order == null) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
            req.setAttribute("order", order);
            req.getRequestDispatcher("/views/web/order-success.jsp").forward(req, resp);
            return;
        }

        // /checkout
        HttpSession session = req.getSession(false);
        CartModel_24110013 cart = (session != null) ? (CartModel_24110013) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Tự động điền dữ liệu nếu khách đã đăng nhập
        if (session != null && session.getAttribute("account") != null) {
            User_24110013 user = (User_24110013) session.getAttribute("account");
            req.setAttribute("defaultName", user.getFullname());
            req.setAttribute("defaultPhone", user.getPhone());
        }

        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/views/web/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        CartModel_24110013 cart = (session != null) ? (CartModel_24110013) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String recipientName = req.getParameter("recipientName");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String note = req.getParameter("note");
        String paymentMethod = req.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "COD";
        }

        // Validate
        if (recipientName == null || recipientName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            address == null || address.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ Họ tên, Số điện thoại và Địa chỉ giao hàng!");
            req.setAttribute("cart", cart);
            req.getRequestDispatcher("/views/web/checkout.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra tồn kho trước khi đặt hàng
        for (CartItemModel_24110013 item : cart.getItems()) {
            Video_24110013 currentVideo = videoService.findById(item.getVideo().getVideoId());
            int stock = (currentVideo != null && currentVideo.getQuantity() != null) ? currentVideo.getQuantity() : 0;
            if (item.getQuantity() > stock) {
                req.setAttribute("error", "Sản phẩm \"" + item.getVideo().getTitle() + "\" hiện chỉ còn " + stock + " trong kho, không đủ số lượng đặt (" + item.getQuantity() + ")!");
                req.setAttribute("cart", cart);
                req.getRequestDispatcher("/views/web/checkout.jsp").forward(req, resp);
                return;
            }
        }

        // Sinh mã đơn hàng duy nhất: ORD + NămThángNgàyGiờPhútGiây + 3 số ngẫu nhiên
        String timeStamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String randomSuffix = String.format("%03d", (int)(Math.random() * 1000));
        String orderId = "ORD-" + timeStamp + "-" + randomSuffix;

        User_24110013 user = null;
        if (session != null && session.getAttribute("account") != null) {
            user = (User_24110013) session.getAttribute("account");
        }

        // Tự động liên kết tài khoản nếu SĐT hoặc Họ tên trùng với tài khoản trong CSDL
        if (user == null) {
            jakarta.persistence.EntityManager emCheck = vn.iotstar.config.JpaConfig_24110013.getEntityManager();
            try {
                if (phone != null && !phone.trim().isEmpty()) {
                    List<User_24110013> usersByPhone = emCheck.createQuery(
                            "SELECT u FROM User_24110013 u WHERE u.phone = :p", User_24110013.class)
                            .setParameter("p", phone.trim())
                            .getResultList();
                    if (!usersByPhone.isEmpty()) {
                        user = usersByPhone.get(0);
                    }
                }
                if (user == null && recipientName != null && !recipientName.trim().isEmpty()) {
                    List<User_24110013> usersByName = emCheck.createQuery(
                            "SELECT u FROM User_24110013 u WHERE u.fullname = :fn OR u.username = :un", User_24110013.class)
                            .setParameter("fn", recipientName.trim())
                            .setParameter("un", recipientName.trim())
                            .getResultList();
                    if (!usersByName.isEmpty()) {
                        user = usersByName.get(0);
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                emCheck.close();
            }
        }

        Order_24110013 order = new Order_24110013(
                orderId,
                recipientName.trim(),
                phone.trim(),
                address.trim(),
                note != null ? note.trim() : "",
                cart.getTotalAmount(),
                cart.getShippingFee(),
                paymentMethod,
                "PENDING",
                user
        );

        List<OrderDetail_24110013> details = new ArrayList<>();
        for (CartItemModel_24110013 item : cart.getItems()) {
            OrderDetail_24110013 detail = new OrderDetail_24110013(
                    order,
                    item.getVideo(),
                    item.getQuantity(),
                    item.getPrice()
            );
            details.add(detail);
        }

        boolean success = orderService.createOrder(order, details);
        if (success) {
            // Lưu orderId vào Session
            @SuppressWarnings("unchecked")
            List<String> sessionOrders = (List<String>) session.getAttribute("session_orders");
            if (sessionOrders == null) {
                sessionOrders = new ArrayList<>();
            }
            sessionOrders.add(orderId);
            session.setAttribute("session_orders", sessionOrders);

            // Lưu orderId vào Cookie (30 ngày)
            String cookieVal = orderId;
            jakarta.servlet.http.Cookie[] cookies = req.getCookies();
            if (cookies != null) {
                for (jakarta.servlet.http.Cookie c : cookies) {
                    if ("client_orders".equals(c.getName()) && c.getValue() != null) {
                        cookieVal = c.getValue() + "," + orderId;
                        break;
                    }
                }
            }
            jakarta.servlet.http.Cookie orderCookie = new jakarta.servlet.http.Cookie("client_orders", cookieVal);
            orderCookie.setMaxAge(30 * 24 * 3600);
            orderCookie.setPath("/");
            resp.addCookie(orderCookie);

            // Xóa giỏ hàng sau khi đặt thành công
            cart.clear();
            resp.sendRedirect(req.getContextPath() + "/order-success?id=" + orderId);
        } else {
            req.setAttribute("error", "Có lỗi xảy ra trong quá trình tạo đơn hàng. Vui lòng thử lại!");
            req.setAttribute("cart", cart);
            req.getRequestDispatcher("/views/web/checkout.jsp").forward(req, resp);
        }
    }
}
