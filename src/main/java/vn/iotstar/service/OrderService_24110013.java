package vn.iotstar.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.dao.*;
import vn.iotstar.entity.*;

import java.util.List;

public class OrderService_24110013 implements IOrderService_24110013 {

    private IOrderDao_24110013 orderDao = new OrderDao_24110013();
    private IOrderDetailDao_24110013 orderDetailDao = new OrderDetailDao_24110013();

    @Override
    public boolean createOrder(Order_24110013 order, List<OrderDetail_24110013> details) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();

            // 1. Gắn lại User managed nếu có
            if (order.getUser() != null && order.getUser().getUsername() != null) {
                User_24110013 managedUser = em.find(User_24110013.class, order.getUser().getUsername());
                if (managedUser != null) {
                    order.setUser(managedUser);
                }
            }

            // 2. Lưu Order
            em.persist(order);

            // 2. Lưu từng OrderDetail và cập nhật tồn kho (Quantity) của Video
            for (OrderDetail_24110013 detail : details) {
                detail.setOrder(order);
                em.persist(detail);

                // Trừ tồn kho sản phẩm trong CSDL
                Video_24110013 video = em.find(Video_24110013.class, detail.getVideo().getVideoId());
                if (video != null) {
                    int currentStock = (video.getQuantity() != null) ? video.getQuantity() : 0;
                    int newStock = Math.max(0, currentStock - detail.getQuantity());
                    video.setQuantity(newStock);
                    em.merge(video);
                }
            }

            trans.commit();
            return true;
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    @Override
    public void updateStatus(String orderId, String newStatus) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Order_24110013 order = em.find(Order_24110013.class, orderId);
            if (order != null) {
                String oldStatus = order.getStatus();
                order.setStatus(newStatus);
                em.merge(order);

                // Nếu chuyển từ trạng thái khác sang CANCELLED thì hoàn lại số lượng kho
                if ("CANCELLED".equalsIgnoreCase(newStatus) && !"CANCELLED".equalsIgnoreCase(oldStatus)) {
                    List<OrderDetail_24110013> details = em.createQuery(
                            "SELECT d FROM OrderDetail_24110013 d WHERE d.order.orderId = :orderId", OrderDetail_24110013.class)
                            .setParameter("orderId", orderId)
                            .getResultList();
                    for (OrderDetail_24110013 d : details) {
                        Video_24110013 v = em.find(Video_24110013.class, d.getVideo().getVideoId());
                        if (v != null) {
                            v.setQuantity((v.getQuantity() != null ? v.getQuantity() : 0) + d.getQuantity());
                            em.merge(v);
                        }
                    }
                }
            }
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean cancelOrder(String orderId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Order_24110013 order = em.find(Order_24110013.class, orderId);
            if (order != null && "PENDING".equalsIgnoreCase(order.getStatus())) {
                order.setStatus("CANCELLED");
                em.merge(order);

                // Hoàn lại kho
                List<OrderDetail_24110013> details = em.createQuery(
                        "SELECT d FROM OrderDetail_24110013 d WHERE d.order.orderId = :orderId", OrderDetail_24110013.class)
                        .setParameter("orderId", orderId)
                        .getResultList();
                for (OrderDetail_24110013 d : details) {
                    Video_24110013 v = em.find(Video_24110013.class, d.getVideo().getVideoId());
                    if (v != null) {
                        v.setQuantity((v.getQuantity() != null ? v.getQuantity() : 0) + d.getQuantity());
                        em.merge(v);
                    }
                }

                trans.commit();
                return true;
            }
            if (trans.isActive()) trans.rollback();
            return false;
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    @Override
    public Order_24110013 findById(String orderId) {
        return orderDao.findById(orderId);
    }

    @Override
    public List<Order_24110013> findAll() {
        return orderDao.findAll();
    }

    @Override
    public List<Order_24110013> findByUsername(String username) {
        return orderDao.findByUsername(username);
    }

    @Override
    public List<Order_24110013> findByStatus(String status) {
        return orderDao.findByStatus(status);
    }
}
