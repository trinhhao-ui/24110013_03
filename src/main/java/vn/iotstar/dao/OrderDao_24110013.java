package vn.iotstar.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.entity.Order_24110013;

import java.util.List;

public class OrderDao_24110013 implements IOrderDao_24110013 {

    @Override
    public void insert(Order_24110013 order) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(order);
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
    public void update(Order_24110013 order) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.merge(order);
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
    public void delete(String orderId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Order_24110013 order = em.find(Order_24110013.class, orderId);
            if (order != null) {
                em.remove(order);
            }
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
    public Order_24110013 findById(String orderId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            return em.find(Order_24110013.class, orderId);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Order_24110013> findAll() {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Order_24110013> query = em.createQuery(
                    "SELECT o FROM Order_24110013 o ORDER BY o.orderDate DESC", Order_24110013.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Order_24110013> findByUsername(String username) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            vn.iotstar.entity.User_24110013 u = em.find(vn.iotstar.entity.User_24110013.class, username);
            String fullname = (u != null && u.getFullname() != null) ? u.getFullname().trim() : "";
            String phone = (u != null && u.getPhone() != null) ? u.getPhone().trim() : "";

            TypedQuery<Order_24110013> query = em.createQuery(
                    "SELECT DISTINCT o FROM Order_24110013 o " +
                    "WHERE (o.user IS NOT NULL AND o.user.username = :username) " +
                    "   OR (:fn <> '' AND o.recipientName = :fn) " +
                    "   OR (:ph <> '' AND o.phone = :ph) " +
                    "ORDER BY o.orderDate DESC", Order_24110013.class);
            query.setParameter("username", username);
            query.setParameter("fn", fullname);
            query.setParameter("ph", phone);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Order_24110013> findByStatus(String status) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Order_24110013> query = em.createQuery(
                    "SELECT o FROM Order_24110013 o WHERE o.status = :status ORDER BY o.orderDate DESC", Order_24110013.class);
            query.setParameter("status", status);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countAll() {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(o) FROM Order_24110013 o", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
}
