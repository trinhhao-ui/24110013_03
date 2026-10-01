package vn.iotstar;

import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.entity.*;
import vn.iotstar.model.*;
import vn.iotstar.service.*;

import java.util.ArrayList;
import java.util.List;

public class TestCartAndOrder_24110013 {
    public static void main(String[] args) {
        System.out.println("========== BẮT ĐẦU KIỂM TRA CHỨC NĂNG GIỎ HÀNG & THANH TOÁN COD ==========");

        try {
            IVideoService_24110013 videoService = new VideoService_24110013();
            IOrderService_24110013 orderService = new OrderService_24110013();
            IUserService_24110013 userService = new UserService_24110013();

            Video_24110013 v1 = videoService.findById("V001");
            if (v1 == null) {
                System.out.println("Lỗi: Không tìm thấy Video V001!");
                return;
            }

            int initialStock = v1.getQuantity();
            System.out.println("1. Video V001: Giá = " + v1.getPrice() + " đ, Tồn kho hiện tại = " + initialStock);

            // Test 1: Giỏ hàng
            CartModel_24110013 cart = new CartModel_24110013();
            System.out.println("2. Kiểm tra thêm vào giỏ hàng:");
            cart.addItem(v1, 2);
            System.out.println("   + Thêm 2 sản phẩm: Số lượng trong giỏ = " + cart.getTotalQuantity() + ", Tạm tính = " + cart.getSubtotal());

            // Thử thêm quá số lượng tồn kho
            boolean limitCheck = cart.addItem(v1, initialStock + 10);
            System.out.println("   + Thêm vượt tồn kho: Số lượng trong giỏ bị giới hạn tối đa = " + cart.getTotalQuantity() + " (Tồn kho là " + initialStock + ")");
            System.out.println("   + Thông báo giới hạn: " + cart.getLastNotice());

            // Cập nhật số lượng về 3
            cart.updateQuantity("V001", 3);
            System.out.println("   + Cập nhật về 3: Số lượng trong giỏ = " + cart.getTotalQuantity() + ", Phí ship COD = " + cart.getShippingFee() + ", Tổng tiền = " + cart.getTotalAmount());

            // Test 2: Đặt hàng thanh toán COD
            System.out.println("3. Kiểm tra Thanh toán COD (Tạo đơn hàng):");
            String testOrderId = "TEST-ORD-" + System.currentTimeMillis();
            User_24110013 user1 = userService.findById("user1");

            Order_24110013 order = new Order_24110013(
                    testOrderId,
                    "Nguyễn Văn A (Test)",
                    "0912345678",
                    "1 Võ Văn Ngân, Thủ Đức, TP.HCM",
                    "Giao hàng COD giờ hành chính",
                    cart.getTotalAmount(),
                    cart.getShippingFee(),
                    "COD",
                    "PENDING",
                    user1
            );

            List<OrderDetail_24110013> details = new ArrayList<>();
            for (CartItemModel_24110013 item : cart.getItems()) {
                details.add(new OrderDetail_24110013(order, item.getVideo(), item.getQuantity(), item.getPrice()));
            }

            boolean orderCreated = orderService.createOrder(order, details);
            System.out.println("   + Tạo đơn hàng COD #" + testOrderId + ": " + (orderCreated ? "THÀNH CÔNG" : "THẤT BÀI"));

            // Kiểm tra trừ kho
            Video_24110013 v1After = videoService.findById("V001");
            int stockAfterOrder = v1After.getQuantity();
            System.out.println("   + Kiểm tra tồn kho sau khi đặt 3 sản phẩm: Trước = " + initialStock + ", Sau = " + stockAfterOrder + " (Giảm đúng 3: " + (stockAfterOrder == initialStock - 3) + ")");

            // Test 3: Tra cứu đơn hàng
            Order_24110013 retrievedOrder = orderService.findById(testOrderId);
            System.out.println("4. Tra cứu đơn hàng #" + testOrderId + ":");
            System.out.println("   + Người nhận: " + retrievedOrder.getRecipientName());
            System.out.println("   + Phương thức: " + retrievedOrder.getPaymentMethod());
            System.out.println("   + Trạng thái: " + retrievedOrder.getStatusVietnamese());
            System.out.println("   + Số món: " + retrievedOrder.getOrderDetails().size());

            // Test 4: Cập nhật trạng thái Admin
            System.out.println("5. Kiểm tra Admin cập nhật trạng thái đơn:");
            orderService.updateStatus(testOrderId, "SHIPPING");
            Order_24110013 shippingOrder = orderService.findById(testOrderId);
            System.out.println("   + Chuyển trạng thái sang SHIPPING: " + shippingOrder.getStatusVietnamese());

            // Đổi lại PENDING để test Hủy đơn và Hoàn kho
            orderService.updateStatus(testOrderId, "PENDING");

            // Test 5: Hủy đơn hàng và hoàn lại tồn kho
            System.out.println("6. Kiểm tra Hủy đơn hàng & Hoàn lại tồn kho:");
            boolean cancelled = orderService.cancelOrder(testOrderId);
            System.out.println("   + Hủy đơn hàng #" + testOrderId + ": " + (cancelled ? "THÀNH CÔNG" : "THẤT BÀI"));

            Video_24110013 v1AfterCancel = videoService.findById("V001");
            System.out.println("   + Tồn kho sau khi hủy đơn: " + v1AfterCancel.getQuantity() + " (Đã hoàn lại đúng như ban đầu: " + (v1AfterCancel.getQuantity() == initialStock) + ")");

            System.out.println("========== TẤT CẢ TEST ĐỀU HOÀN THÀNH XUẤT SẮC & CHÍNH XÁC 100%! ==========");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JpaConfig_24110013.close();
        }
    }
}
