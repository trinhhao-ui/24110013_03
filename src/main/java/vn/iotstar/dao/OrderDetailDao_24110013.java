package vn.iotstar.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.entity.OrderDetail_24110013;

import java.util.List;

public class OrderDetailDao_24110013 implements IOrderDetailDao_24110013 {

    @Override
    public void insert(OrderDetail_24110013 orderDetail) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(orderDetail);
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public List<OrderDetail_24110013> findByOrderId(String orderId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<OrderDetail_24110013> query = em.createQuery(
                    "SELECT d FROM OrderDetail_24110013 d WHERE d.order.orderId = :orderId", OrderDetail_24110013.class);
            query.setParameter("orderId", orderId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
