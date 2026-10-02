package vn.iotstar;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.entity.*;

import java.util.Date;
import java.util.List;

public class Seed8StatusOrders {
    public static void main(String[] args) {
        System.out.println("========== BẮT ĐẦU NẠP DỮ LIỆU MẪU 8 TRẠNG THÁI ĐƠN HÀNG ==========");

        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();

        try {
            trans.begin();

            User_24110013 user1 = em.find(User_24110013.class, "user1");
            if (user1 == null) {
                System.out.println("Lỗi: Không tìm thấy tài khoản user1!");
                trans.rollback();
                return;
            }

            List<Video_24110013> videos = em.createQuery("SELECT v FROM Video_24110013 v ORDER BY v.videoId", Video_24110013.class)
                    .setMaxResults(5)
                    .getResultList();

            if (videos.isEmpty()) {
                System.out.println("Lỗi: Không tìm thấy sản phẩm video nào!");
                trans.rollback();
                return;
            }

            String[][] statusData = {
                {"ORD-STAT-01", "NEW", "Nguyễn Văn A", "0912345678", "Số 1 Võ Văn Ngân, TP. Thủ Đức, TP.HCM", "Đơn hàng mới tạo vừa đặt xong", "150000", "30000"},
                {"ORD-STAT-02", "CONFIRMED", "Nguyễn Văn A", "0912345678", "Số 1 Võ Văn Ngân, TP. Thủ Đức, TP.HCM", "Shop đã gọi điện xác nhận đơn", "180000", "30000"},
                {"ORD-STAT-03", "PREPARING", "Nguyễn Văn A", "0912345678", "Số 1 Võ Văn Ngân, TP. Thủ Đức, TP.HCM", "Kho đang đóng gói sản phẩm", "210000", "30000"},
                {"ORD-STAT-04", "SHIPPING", "Nguyễn Văn A", "0912345678", "Số 1 Võ Văn Ngân, TP. Thủ Đức, TP.HCM", "Đang vận chuyển qua bưu cục trung chuyển", "250000", "0"},
                {"ORD-STAT-05", "DELIVERING", "Nguyễn Văn A", "0912345678", "Số 1 Võ Văn Ngân, TP. Thủ Đức, TP.HCM", "Shipper đang trên đường đi giao COD tận nơi", "280000", "0"},
                {"ORD-STAT-06", "DELIVERED", "Nguyễn Văn A", "0912345678", "Số 1 Võ Văn Ngân, TP. Thủ Đức, TP.HCM", "Đã nhận hàng và thanh toán COD thành công", "350000", "0"},
                {"ORD-STAT-07", "CANCELLED", "Nguyễn Văn A", "0912345678", "Số 1 Võ Văn Ngân, TP. Thủ Đức, TP.HCM", "Khách hàng đổi ý đã hủy đơn", "120000", "30000"},
                {"ORD-STAT-08", "RETURNED", "Nguyễn Văn A", "0912345678", "Số 1 Võ Văn Ngân, TP. Thủ Đức, TP.HCM", "Giao không thành công, hàng hoàn về kho", "160000", "30000"}
            };

            for (int i = 0; i < statusData.length; i++) {
                String orderId = statusData[i][0];
                String status = statusData[i][1];
                String name = statusData[i][2];
                String phone = statusData[i][3];
                String address = statusData[i][4];
                String note = statusData[i][5];
                double total = Double.parseDouble(statusData[i][6]);
                double ship = Double.parseDouble(statusData[i][7]);

                Order_24110013 existing = em.find(Order_24110013.class, orderId);
                if (existing != null) {
                    existing.setStatus(status);
                    existing.setNote(note);
                    existing.setTotalAmount(total);
                    existing.setShippingFee(ship);
                    em.merge(existing);
                    System.out.println("-> Đã cập nhật đơn #" + orderId + " sang trạng thái [" + status + "]");
                } else {
                    Order_24110013 order = new Order_24110013(
                            orderId, name, phone, address, note, total, ship, "COD", status, user1
                    );
                    // Lùi thời gian một chút để các đơn có thứ tự thời gian khác nhau
                    long timeOffset = (long) (statusData.length - i) * 3600000L;
                    order.setOrderDate(new Date(System.currentTimeMillis() - timeOffset));
                    em.persist(order);

                    // Thêm 1-2 chi tiết đơn hàng
                    Video_24110013 v = videos.get(i % videos.size());
                    OrderDetail_24110013 d1 = new OrderDetail_24110013(order, v, 1, v.getPrice());
                    em.persist(d1);

                    System.out.println("-> Đã tạo mới đơn #" + orderId + " với trạng thái [" + status + "] cho user1");
                }
            }

            trans.commit();
            System.out.println("========== HOÀN TẤT NẠP DỮ LIỆU MẪU 8 TRẠNG THÁI THÀNH CÔNG! ==========");

        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            e.printStackTrace();
        } finally {
            em.close();
            JpaConfig_24110013.close();
        }
    }
}
