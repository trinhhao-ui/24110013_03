package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User_24110013;
import vn.iotstar.service.IUserService_24110013;
import vn.iotstar.service.UserService_24110013;
import vn.iotstar.util.EmailUtils_24110013;

import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/logout", "/register", "/verify-otp"})
public class AuthController_24110013 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService_24110013 userService = new UserService_24110013();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        switch (path) {
            case "/login":
                req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
                break;
            case "/register":
                req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
                break;
            case "/verify-otp":
                req.getRequestDispatcher("/views/auth/verify-otp.jsp").forward(req, resp);
                break;
            case "/logout":
                HttpSession session = req.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                resp.sendRedirect(req.getContextPath() + "/login?msg=logged_out");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/home");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String path = req.getServletPath();

        if ("/register".equals(path)) {
            handleRegister(req, resp);
        } else if ("/verify-otp".equals(path)) {
            handleVerifyOtp(req, resp);
        } else if ("/login".equals(path)) {
            handleLogin(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String images = req.getParameter("images");

        if (images == null || images.trim().isEmpty()) {
            images = "https://picsum.photos/200?random=" + System.currentTimeMillis() % 100;
        }

        // Validate
        if (userService.checkExistUsername(username)) {
            req.setAttribute("error", "Tên đăng nhập đã tồn tại, vui lòng chọn tên khác!");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (userService.checkExistEmail(email)) {
            req.setAttribute("error", "Email đã được sử dụng bởi tài khoản khác!");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

        // Tạo mã OTP 6 số
        String otp = EmailUtils_24110013.generateOtp(6);

        // Gửi mail OTP
        boolean emailSent = EmailUtils_24110013.sendOtp(email, otp);

        // Tạo user tạm thời (chưa active)
        User_24110013 pendingUser = new User_24110013(username, password, phone, fullname, email, false, false, images);

        HttpSession session = req.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("otp_time", System.currentTimeMillis());
        session.setAttribute("pending_user", pendingUser);

        if (!emailSent) {
            session.setAttribute("otpOfflineNotice", "Không thể gửi email qua internet (chế độ Offline). Vui lòng kiểm tra Console Server hoặc nhập mã test: " + otp);
        } else {
            session.removeAttribute("otpOfflineNotice");
        }

        resp.sendRedirect(req.getContextPath() + "/verify-otp");
    }

    private void handleVerifyOtp(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("otp") == null || session.getAttribute("pending_user") == null) {
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        String inputOtp = req.getParameter("otp");
        String sessionOtp = (String) session.getAttribute("otp");
        Long otpTime = (Long) session.getAttribute("otp_time");
        User_24110013 pendingUser = (User_24110013) session.getAttribute("pending_user");

        // Kiểm tra thời hạn 5 phút (300.000 ms)
        if (otpTime == null || (System.currentTimeMillis() - otpTime) > 300000) {
            req.setAttribute("error", "Mã OTP đã hết hiệu lực. Vui lòng thực hiện đăng ký lại!");
            req.getRequestDispatcher("/views/auth/verify-otp.jsp").forward(req, resp);
            return;
        }

        if (sessionOtp != null && sessionOtp.equals(inputOtp != null ? inputOtp.trim() : "")) {
            // Kích hoạt tài khoản và lưu vào CSDL
            pendingUser.setActive(true);
            userService.register(pendingUser);

            // Dọn dẹp session
            session.removeAttribute("otp");
            session.removeAttribute("otp_time");
            session.removeAttribute("pending_user");
            session.removeAttribute("otpOfflineNotice");

            resp.sendRedirect(req.getContextPath() + "/login?msg=activated");
        } else {
            req.setAttribute("error", "Mã OTP không chính xác. Vui lòng thử lại!");
            req.getRequestDispatcher("/views/auth/verify-otp.jsp").forward(req, resp);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User_24110013 user = userService.login(username, password);

        if (user == null) {
            // Kiểm tra xem do sai mật khẩu hay chưa kích hoạt
            User_24110013 existing = userService.findById(username);
            if (existing != null && !Boolean.TRUE.equals(existing.getActive())) {
                req.setAttribute("error", "Tài khoản của bạn chưa được kích hoạt bằng mã OTP!");
            } else {
                req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            }
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
            return;
        }

        // Lưu thông tin đăng nhập vào Session
        HttpSession session = req.getSession();
        session.setAttribute("account", user);

        // Theo yêu cầu Câu 2:
        // "Đăng nhập với vai trò admin thành công thì vào trang chủ của Admin, ngược lại thì quay lại trang đăng nhập."
        if (Boolean.TRUE.equals(user.getAdmin())) {
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        } else {
            // Không phải admin: quay lại trang đăng nhập theo đúng yêu cầu đề bài
            req.setAttribute("info", "Đăng nhập thành công với vai trò User thường (không có quyền Admin). Bạn có thể truy cập Trang Chủ.");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }
    }
}
