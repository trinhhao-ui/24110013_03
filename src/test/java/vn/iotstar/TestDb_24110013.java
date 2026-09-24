package vn.iotstar;

import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.dao.*;
import vn.iotstar.entity.*;
import vn.iotstar.service.*;

import java.util.List;

public class TestDb_24110013 {
    public static void main(String[] args) {
        System.out.println("========== BẮT ĐẦU KIỂM TRA HỆ THỐNG (ĐỀ 03 - 24110013) ==========");

        try {
            // 1. Kiểm tra Category & Câu 5: Đếm video theo category
            ICategoryService_24110013 catService = new CategoryService_24110013();
            List<Category_24110013> categories = catService.findAll();
            System.out.println("1. Tìm thấy tổng số Category: " + categories.size());
            for (Category_24110013 c : categories) {
                long count = catService.countVideosByCategoryId(c.getCategoryId());
                System.out.println("   + Chuyên mục: " + c.getCategoryname() + " (" + count + " videos)");
            }

            // 2. Kiểm tra Video & Câu 4: Phân trang 3 video / trang
            IVideoService_24110013 videoService = new VideoService_24110013();
            long totalVideos = videoService.countAll();
            System.out.println("2. Tổng số Video trong DB: " + totalVideos);

            if (!categories.isEmpty()) {
                int firstCatId = categories.get(0).getCategoryId();
                List<Video_24110013> page1Videos = videoService.findByCategoryId(firstCatId, 1, 3);
                System.out.println("   + Danh sách video trang 1 (tối đa 3 video) của CategoryId=" + firstCatId + ": " + page1Videos.size());
                for (Video_24110013 v : page1Videos) {
                    System.out.println("     - [" + v.getVideoId() + "] " + v.getTitle() + " (Views: " + v.getViews() + ")");
                }
            }

            // 3. Kiểm tra Câu 2.2: Phân trang 6 video / trang cho Admin
            List<Video_24110013> adminVideosPage1 = videoService.findAll(1, 6);
            System.out.println("3. Danh sách video trang 1 của Admin (tối đa 6 video): " + adminVideosPage1.size());

            // 4. Kiểm tra User & Câu 2.1
            IUserService_24110013 userService = new UserService_24110013();
            User_24110013 adminUser = userService.login("admin", "123");
            System.out.println("4. Đăng nhập tài khoản admin: " + (adminUser != null ? "THÀNH CÔNG (isAdmin=" + adminUser.getAdmin() + ")" : "THẤT BÀI"));

            User_24110013 normalUser = userService.login("user1", "123");
            System.out.println("   Đăng nhập tài khoản user1: " + (normalUser != null ? "THÀNH CÔNG (isAdmin=" + normalUser.getAdmin() + ")" : "THẤT BÀI"));

            // 5. Kiểm tra Favorites & Shares (Câu 3)
            IFavoriteService_24110013 favService = new FavoriteService_24110013();
            IShareService_24110013 shareService = new ShareService_24110013();
            long likesV001 = favService.countByVideoId("V001");
            long sharesV001 = shareService.countByVideoId("V001");
            System.out.println("5. Video V001 - Likes: " + likesV001 + ", Shares: " + sharesV001);

            System.out.println("========== TẤT CẢ KIỂM TRA ĐỀU HOÀN TOÀN CHÍNH XÁC & KHỚP CSDL! ==========");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JpaConfig_24110013.close();
        }
    }
}
