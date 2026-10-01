package vn.iotstar.service;

import vn.iotstar.entity.Order_24110013;
import vn.iotstar.entity.OrderDetail_24110013;
import java.util.List;

public interface IOrderService_24110013 {
    boolean createOrder(Order_24110013 order, List<OrderDetail_24110013> details);
    void updateStatus(String orderId, String newStatus);
    boolean cancelOrder(String orderId);
    Order_24110013 findById(String orderId);
    List<Order_24110013> findAll();
    List<Order_24110013> findByUsername(String username);
    List<Order_24110013> findByStatus(String status);
}
