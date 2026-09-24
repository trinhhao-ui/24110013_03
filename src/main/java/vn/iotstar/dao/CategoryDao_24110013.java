package vn.iotstar.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.entity.Category_24110013;
import java.util.List;

public class CategoryDao_24110013 implements ICategoryDao_24110013 {

    @Override
    public void insert(Category_24110013 category) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(category);
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
    public void update(Category_24110013 category) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.merge(category);
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
    public void delete(int categoryId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Category_24110013 cat = em.find(Category_24110013.class, categoryId);
            if (cat != null) {
                em.remove(cat);
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
    public Category_24110013 findById(int categoryId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            return em.find(Category_24110013.class, categoryId);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Category_24110013> findAll() {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Category_24110013> query = em.createQuery(
                    "SELECT c FROM Category_24110013 c ORDER BY c.categoryId ASC", Category_24110013.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countVideosByCategoryId(int categoryId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(v) FROM Video_24110013 v WHERE v.category.categoryId = :catId AND v.active = true",
                    Long.class);
            query.setParameter("catId", categoryId);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
}
