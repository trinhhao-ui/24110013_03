package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.Favorite_24110013;
import vn.iotstar.entity.Share_24110013;
import vn.iotstar.entity.User_24110013;
import vn.iotstar.entity.Video_24110013;
import vn.iotstar.service.*;

import java.io.IOException;
import java.util.Date;

@WebServlet(urlPatterns = {"/video-detail"})
public class VideoDetailController_24110013 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IVideoService_24110013 videoService = new VideoService_24110013();
    private IFavoriteService_24110013 favoriteService = new FavoriteService_24110013();
    private IShareService_24110013 shareService = new ShareService_24110013();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String videoId = req.getParameter("id");
        if (videoId == null || videoId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Tự động tăng lượt xem
        videoService.increaseViews(videoId);

        Video_24110013 video = videoService.findById(videoId);
        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        long likeCount = favoriteService.countByVideoId(videoId);
        long shareCount = shareService.countByVideoId(videoId);

        // Kiểm tra xem user hiện tại đã like chưa (nếu đã đăng nhập)
        HttpSession session = req.getSession(false);
        boolean isLiked = false;
        if (session != null && session.getAttribute("account") != null) {
            User_24110013 user = (User_24110013) session.getAttribute("account");
            isLiked = favoriteService.isLiked(user.getUsername(), videoId);
        }

        req.setAttribute("video", video);
        req.setAttribute("likeCount", likeCount);
        req.setAttribute("shareCount", shareCount);
        req.setAttribute("isLiked", isLiked);

        req.getRequestDispatcher("/views/web/video-detail.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        String videoId = req.getParameter("videoId");

        HttpSession session = req.getSession(false);
        User_24110013 user = (session != null) ? (User_24110013) session.getAttribute("account") : null;

        if ("like".equalsIgnoreCase(action) && videoId != null) {
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            if (favoriteService.isLiked(user.getUsername(), videoId)) {
                favoriteService.delete(user.getUsername(), videoId);
            } else {
                Video_24110013 video = videoService.findById(videoId);
                Favorite_24110013 fav = new Favorite_24110013(video, user, new Date());
                favoriteService.insert(fav);
            }
            resp.sendRedirect(req.getContextPath() + "/video-detail?id=" + videoId);
            return;
        }

        if ("share".equalsIgnoreCase(action) && videoId != null) {
            String emailShare = req.getParameter("emailShare");
            if (emailShare != null && !emailShare.trim().isEmpty() && user != null) {
                Video_24110013 video = videoService.findById(videoId);
                Share_24110013 share = new Share_24110013(emailShare, user, video, new Date());
                shareService.insert(share);
            }
            resp.sendRedirect(req.getContextPath() + "/video-detail?id=" + videoId);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/home");
    }
}
