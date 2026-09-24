package vn.iotstar.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.entity.User_24110013;
import java.util.List;

public class UserDao_24110013 implements IUserDao_24110013 {

    @Override
    public void insert(User_24110013 user) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(user);
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
    public void update(User_24110013 user) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.merge(user);
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
    public void delete(String username) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            User_24110013 user = em.find(User_24110013.class, username);
            if (user != null) {
                em.remove(user);
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
    public User_24110013 findById(String username) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            return em.find(User_24110013.class, username);
        } finally {
            em.close();
        }
    }

    @Override
    public User_24110013 findByEmail(String email) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<User_24110013> query = em.createQuery(
                    "SELECT u FROM User_24110013 u WHERE u.email = :email", User_24110013.class);
            query.setParameter("email", email);
            List<User_24110013> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    @Override
    public List<User_24110013> findAll() {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<User_24110013> query = em.createQuery("SELECT u FROM User_24110013 u", User_24110013.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public User_24110013 checkLogin(String username, String password) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<User_24110013> query = em.createQuery(
                    "SELECT u FROM User_24110013 u WHERE u.username = :username AND u.password = :password",
                    User_24110013.class);
            query.setParameter("username", username);
            query.setParameter("password", password);
            List<User_24110013> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }
}
