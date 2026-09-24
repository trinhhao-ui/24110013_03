package vn.iotstar.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.entity.Video_24110013;
import java.util.List;

public class VideoDao_24110013 implements IVideoDao_24110013 {

    @Override
    public void insert(Video_24110013 video) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(video);
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
    public void update(Video_24110013 video) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.merge(video);
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
    public void delete(String videoId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Video_24110013 video = em.find(Video_24110013.class, videoId);
            if (video != null) {
                em.remove(video);
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
    public Video_24110013 findById(String videoId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            return em.find(Video_24110013.class, videoId);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video_24110013> findAll() {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Video_24110013> query = em.createQuery(
                    "SELECT v FROM Video_24110013 v ORDER BY v.videoId DESC", Video_24110013.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video_24110013> findAll(int page, int pageSize) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Video_24110013> query = em.createQuery(
                    "SELECT v FROM Video_24110013 v ORDER BY v.videoId ASC", Video_24110013.class);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countAll() {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(v) FROM Video_24110013 v", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video_24110013> findByCategoryId(int categoryId, int page, int pageSize) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Video_24110013> query = em.createQuery(
                    "SELECT v FROM Video_24110013 v WHERE v.category.categoryId = :catId AND v.active = true ORDER BY v.videoId ASC",
                    Video_24110013.class);
            query.setParameter("catId", categoryId);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countByCategoryId(int categoryId) {
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

    @Override
    public void increaseViews(String videoId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Video_24110013 video = em.find(Video_24110013.class, videoId);
            if (video != null) {
                video.setViews(video.getViews() + 1);
                em.merge(video);
            }
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
