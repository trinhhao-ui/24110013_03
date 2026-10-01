package vn.iotstar.dao;

import vn.iotstar.entity.Order_24110013;
import java.util.List;

public interface IOrderDao_24110013 {
    void insert(Order_24110013 order);
    void update(Order_24110013 order);
    void delete(String orderId);
    Order_24110013 findById(String orderId);
    List<Order_24110013> findAll();
    List<Order_24110013> findByUsername(String username);
    List<Order_24110013> findByStatus(String status);
    long countAll();
}
