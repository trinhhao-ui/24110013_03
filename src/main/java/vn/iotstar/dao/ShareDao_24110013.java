package vn.iotstar.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig_24110013;
import vn.iotstar.entity.Share_24110013;

public class ShareDao_24110013 implements IShareDao_24110013 {

    @Override
    public long countByVideoId(String videoId) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(s) FROM Share_24110013 s WHERE s.video.videoId = :videoId", Long.class);
            query.setParameter("videoId", videoId);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public void insert(Share_24110013 share) {
        EntityManager em = JpaConfig_24110013.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(share);
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
