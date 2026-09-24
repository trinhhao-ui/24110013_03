package vn.iotstar.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.entity.Favorite_24110013;
import java.util.List;

public class FavoriteDao_24110013 implements IFavoriteDao_24110013 {

    @Override
    public long countByVideoId(String videoId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(f) FROM Favorite_24110013 f WHERE f.video.videoId = :videoId", Long.class);
            query.setParameter("videoId", videoId);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean isLiked(String username, String videoId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(f) FROM Favorite_24110013 f WHERE f.user.username = :username AND f.video.videoId = :videoId",
                    Long.class);
            query.setParameter("username", username);
            query.setParameter("videoId", videoId);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public void insert(Favorite_24110013 favorite) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(favorite);
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
    public void delete(String username, String videoId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            TypedQuery<Favorite_24110013> query = em.createQuery(
                    "SELECT f FROM Favorite_24110013 f WHERE f.user.username = :username AND f.video.videoId = :videoId",
                    Favorite_24110013.class);
            query.setParameter("username", username);
            query.setParameter("videoId", videoId);
            List<Favorite_24110013> list = query.getResultList();
            for (Favorite_24110013 fav : list) {
                em.remove(fav);
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
}
