package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.Video_24110013;
import vn.iotstar.model.CartModel_24110013;
import vn.iotstar.service.IVideoService_24110013;
import vn.iotstar.service.VideoService_24110013;

import java.io.IOException;

@WebServlet(urlPatterns = {"/cart", "/cart/add", "/cart/update", "/cart/delete", "/cart/clear"})
public class CartController_24110013 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IVideoService_24110013 videoService = new VideoService_24110013();

    private CartModel_24110013 getCart(HttpServletRequest req) {
        HttpSession session = req.getSession(true);
        CartModel_24110013 cart = (CartModel_24110013) session.getAttribute("cart");
        if (cart == null) {
            cart = new CartModel_24110013();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        CartModel_24110013 cart = getCart(req);

        if ("/cart/delete".equals(path)) {
            String id = req.getParameter("id");
            if (id != null) {
                cart.removeItem(id);
                req.getSession().setAttribute("cartMessage", "Đã xóa sản phẩm khỏi giỏ hàng!");
            }
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        } else if ("/cart/clear".equals(path)) {
            cart.clear();
            req.getSession().setAttribute("cartMessage", "Đã xóa toàn bộ giỏ hàng!");
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Chuyển thông báo từ session sang request nếu có
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("cartMessage") != null) {
            req.setAttribute("message", session.getAttribute("cartMessage"));
            session.removeAttribute("cartMessage");
        }
        if (session != null && session.getAttribute("cartWarning") != null) {
            req.setAttribute("warning", session.getAttribute("cartWarning"));
            session.removeAttribute("cartWarning");
        }

        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/views/web/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String path = req.getServletPath();
        CartModel_24110013 cart = getCart(req);

        if ("/cart/add".equals(path)) {
            String videoId = req.getParameter("videoId");
            int quantity = 1;
            try {
                String qtyStr = req.getParameter("quantity");
                if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                    quantity = Integer.parseInt(qtyStr.trim());
                    if (quantity < 1) quantity = 1;
                }
            } catch (Exception e) {
                quantity = 1;
            }

            Video_24110013 video = videoService.findById(videoId);
            if (video != null) {
                boolean added = cart.addItem(video, quantity);
                if (added) {
                    req.getSession().setAttribute("cartMessage", cart.getLastNotice());
                } else {
                    req.getSession().setAttribute("cartWarning", cart.getLastNotice());
                }
            } else {
                req.getSession().setAttribute("cartWarning", "Không tìm thấy sản phẩm yêu cầu!");
            }

            String redirect = req.getParameter("redirect");
            if ("back".equalsIgnoreCase(redirect)) {
                String referer = req.getHeader("Referer");
                if (referer != null) {
                    resp.sendRedirect(referer);
                    return;
                }
            }
            resp.sendRedirect(req.getContextPath() + "/cart");

        } else if ("/cart/update".equals(path)) {
            String videoId = req.getParameter("videoId");
            int quantity = 1;
            try {
                quantity = Integer.parseInt(req.getParameter("quantity"));
            } catch (Exception e) {
                quantity = 1;
            }

            boolean ok = cart.updateQuantity(videoId, quantity);
            if (ok) {
                req.getSession().setAttribute("cartMessage", cart.getLastNotice());
            } else {
                req.getSession().setAttribute("cartWarning", cart.getLastNotice());
            }
            resp.sendRedirect(req.getContextPath() + "/cart");

        } else if ("/cart/delete".equals(path)) {
            String videoId = req.getParameter("videoId");
            cart.removeItem(videoId);
            req.getSession().setAttribute("cartMessage", "Đã xóa sản phẩm khỏi giỏ hàng!");
            resp.sendRedirect(req.getContextPath() + "/cart");

        } else if ("/cart/clear".equals(path)) {
            cart.clear();
            req.getSession().setAttribute("cartMessage", "Đã xóa sạch giỏ hàng!");
            resp.sendRedirect(req.getContextPath() + "/cart");

        } else {
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }
}
