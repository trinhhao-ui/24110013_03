package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Category_24110013;
import vn.iotstar.entity.Video_24110013;
import vn.iotstar.model.CategoryVideosModel_24110013;
import vn.iotstar.model.VideoItemModel_24110013;
import vn.iotstar.service.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/home", ""})
public class HomeController_24110013 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ICategoryService_24110013 categoryService = new CategoryService_24110013();
    private IVideoService_24110013 videoService = new VideoService_24110013();
    private IFavoriteService_24110013 favoriteService = new FavoriteService_24110013();
    private IShareService_24110013 shareService = new ShareService_24110013();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        List<Category_24110013> categories = categoryService.findAll();
        List<CategoryVideosModel_24110013> categoryModelList = new ArrayList<>();

        int pageSize = 3; // Phân trang 3 video / trang theo Câu 4

        for (Category_24110013 cat : categories) {
            if (!Boolean.TRUE.equals(cat.getStatus())) continue;

            // Câu 5: Đếm số lượng Video theo từng Category
            long totalVideos = categoryService.countVideosByCategoryId(cat.getCategoryId());
            int totalPages = (int) Math.ceil((double) totalVideos / pageSize);
            if (totalPages == 0) totalPages = 1;

            // Lấy trang hiện tại cho category này (tham số URL: p_{catId})
            String pageParam = req.getParameter("p_" + cat.getCategoryId());
            int currentPage = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                    if (currentPage > totalPages) currentPage = totalPages;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            // Lấy danh sách 3 video cho category theo trang hiện tại
            List<Video_24110013> videos = videoService.findByCategoryId(cat.getCategoryId(), currentPage, pageSize);
            List<VideoItemModel_24110013> videoItems = new ArrayList<>();

            for (Video_24110013 v : videos) {
                long likeCount = favoriteService.countByVideoId(v.getVideoId());
                long shareCount = shareService.countByVideoId(v.getVideoId());
                videoItems.add(new VideoItemModel_24110013(v, likeCount, shareCount));
            }

            categoryModelList.add(new CategoryVideosModel_24110013(cat, totalVideos, currentPage, totalPages, videoItems));
        }

        req.setAttribute("categoryList", categoryModelList);
        req.getRequestDispatcher("/views/web/home.jsp").forward(req, resp);
    }
}
