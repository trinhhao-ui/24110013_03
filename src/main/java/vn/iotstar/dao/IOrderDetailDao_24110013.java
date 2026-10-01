package vn.iotstar.dao;

import vn.iotstar.entity.OrderDetail_24110013;
import java.util.List;

public interface IOrderDetailDao_24110013 {
    void insert(OrderDetail_24110013 orderDetail);
    List<OrderDetail_24110013> findByOrderId(String orderId);
}
