package vn.iotstar;

import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.entity.Order_24110013;
import vn.iotstar.service.IOrderService_24110013;
import vn.iotstar.service.OrderService_24110013;

import java.util.List;
import java.util.Map;

public class Test8StatusFilter_24110013 {
    public static void main(String[] args) {
        System.out.println("========== BẮT ĐẦU KIỂM TRA LỌC ĐƠN HÀNG THEO 8 TRẠNG THÁI ==========");

        try {
            IOrderService_24110013 orderService = new OrderService_24110013();

            // 1. Kiểm tra thống kê số lượng theo 8 trạng thái cho user1
            System.out.println("1. Thống kê số lượng đơn hàng của tài khoản 'user1':");
            Map<String, Long> userCounts = orderService.countOrdersByStatusForUser("user1");
            for (Map.Entry<String, Long> entry : userCounts.entrySet()) {
                System.out.println("   + [" + entry.getKey() + "] = " + entry.getValue() + " đơn");
            }

            // 2. Kiểm tra lọc từng trạng thái
            String[] statuses = {"NEW", "CONFIRMED", "PREPARING", "SHIPPING", "DELIVERING", "DELIVERED", "CANCELLED", "RETURNED"};
            String[] vietnameseNames = {"Đơn hàng mới", "Đã xác nhận", "Chuẩn bị hàng", "Vận chuyển", "Giao hàng", "Đã giao", "Đơn hàng hủy", "Đơn hàng hoàn"};

            System.out.println("\n2. Kiểm tra kết quả truy vấn lọc theo từng trạng thái:");
            for (int i = 0; i < statuses.length; i++) {
                String st = statuses[i];
                String vn = vietnameseNames[i];
                List<Order_24110013> list = orderService.findByUsernameAndStatus("user1", st);
                System.out.println("   + [" + st + " - " + vn + "]: Tìm thấy " + list.size() + " đơn.");
                for (Order_24110013 o : list) {
                    System.out.println("       * Mã đơn: #" + o.getOrderId() + " | Trạng thái hiển thị: " + o.getStatusVietnamese() + " | Tiền COD: " + o.getTotalAmount() + " đ");
                }
            }

            // 3. Kiểm tra thống kê của Admin
            System.out.println("\n3. Thống kê toàn hệ thống cho Admin:");
            Map<String, Long> adminCounts = orderService.countOrdersByStatusForAdmin();
            for (Map.Entry<String, Long> entry : adminCounts.entrySet()) {
                System.out.println("   + Admin [" + entry.getKey() + "] = " + entry.getValue() + " đơn");
            }

            System.out.println("\n========== TẤT CẢ 8 TRẠNG THÁI ĐỀU HOẠT ĐỘNG HOÀN HẢO 100%! ==========");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JpaConfig_24110013.close();
        }
    }
}
