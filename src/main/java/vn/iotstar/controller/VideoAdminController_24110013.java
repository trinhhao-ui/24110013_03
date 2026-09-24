package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.Category_24110013;
import vn.iotstar.entity.User_24110013;
import vn.iotstar.entity.Video_24110013;
import vn.iotstar.service.CategoryService_24110013;
import vn.iotstar.service.ICategoryService_24110013;
import vn.iotstar.service.IVideoService_24110013;
import vn.iotstar.service.VideoService_24110013;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
        "/admin/videos",
        "/admin/video/add",
        "/admin/video/edit",
        "/admin/video/delete"
})
public class VideoAdminController_24110013 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IVideoService_24110013 videoService = new VideoService_24110013();
    private ICategoryService_24110013 categoryService = new CategoryService_24110013();

    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=not_logged_in");
            return false;
        }
        User_24110013 user = (User_24110013) session.getAttribute("account");
        if (!user.getAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login?error=access_denied");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        if (!checkAdmin(req, resp)) return;

        String path = req.getServletPath();

        switch (path) {
            case "/admin/videos":
                handleList(req, resp);
                break;
            case "/admin/video/add":
                showAddForm(req, resp);
                break;
            case "/admin/video/edit":
                showEditForm(req, resp);
                break;
            case "/admin/video/delete":
                handleDelete(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/videos");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        if (!checkAdmin(req, resp)) return;

        String path = req.getServletPath();

        if ("/admin/video/add".equals(path)) {
            handleAdd(req, resp);
        } else if ("/admin/video/edit".equals(path)) {
            handleEdit(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int pageSize = 6; // Phân trang 6 video trên 01 trang theo đề bài
        int page = 1;

        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        long totalVideos = videoService.countAll();
        int totalPages = (int) Math.ceil((double) totalVideos / pageSize);
        if (totalPages == 0) totalPages = 1;
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        List<Video_24110013> videos = videoService.findAll(page, pageSize);

        req.setAttribute("videos", videos);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalVideos", totalVideos);

        req.getRequestDispatcher("/views/admin/video-list.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category_24110013> categories = categoryService.findAll();
        req.setAttribute("categories", categories);
        req.setAttribute("video", new Video_24110013());
        req.setAttribute("isEdit", false);
        req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoId = req.getParameter("id");
        Video_24110013 video = videoService.findById(videoId);
        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
            return;
        }

        List<Category_24110013> categories = categoryService.findAll();
        req.setAttribute("categories", categories);
        req.setAttribute("video", video);
        req.setAttribute("isEdit", true);
        req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoId = req.getParameter("videoId");
        String title = req.getParameter("title");
        String poster = req.getParameter("poster");
        String description = req.getParameter("description");
        String viewsStr = req.getParameter("views");
        boolean active = req.getParameter("active") != null;
        int categoryId = Integer.parseInt(req.getParameter("categoryId"));

        // Validate trùng videoId
        if (videoService.findById(videoId) != null) {
            req.setAttribute("error", "Mã video '" + videoId + "' đã tồn tại!");
            List<Category_24110013> categories = categoryService.findAll();
            req.setAttribute("categories", categories);
            req.setAttribute("isEdit", false);
            req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp);
            return;
        }

        int views = 0;
        try {
            views = Integer.parseInt(viewsStr);
        } catch (Exception ignored) {}

        if (poster == null || poster.trim().isEmpty()) {
            poster = "https://picsum.photos/400/250?random=" + System.currentTimeMillis() % 1000;
        }

        Category_24110013 category = categoryService.findById(categoryId);
        Video_24110013 video = new Video_24110013(videoId, title, poster, views, description, active, category);
        videoService.insert(video);

        resp.sendRedirect(req.getContextPath() + "/admin/videos?msg=added");
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoId = req.getParameter("videoId");
        String title = req.getParameter("title");
        String poster = req.getParameter("poster");
        String description = req.getParameter("description");
        String viewsStr = req.getParameter("views");
        boolean active = req.getParameter("active") != null;
        int categoryId = Integer.parseInt(req.getParameter("categoryId"));

        Video_24110013 video = videoService.findById(videoId);
        if (video != null) {
            video.setTitle(title);
            if (poster != null && !poster.trim().isEmpty()) {
                video.setPoster(poster);
            }
            try {
                video.setViews(Integer.parseInt(viewsStr));
            } catch (Exception ignored) {}
            video.setDescription(description);
            video.setActive(active);
            Category_24110013 category = categoryService.findById(categoryId);
            video.setCategory(category);

            videoService.update(video);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/videos?msg=updated");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String videoId = req.getParameter("id");
        if (videoId != null && !videoId.trim().isEmpty()) {
            videoService.delete(videoId);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/videos?msg=deleted");
    }
}
