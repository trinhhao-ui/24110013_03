package vn.iotstar.service;

import vn.iotstar.dao.FavoriteDao_24110013;
import vn.iotstar.dao.IFavoriteDao_24110013;
import vn.iotstar.entity.Favorite_24110013;

public class FavoriteService_24110013 implements IFavoriteService_24110013 {
    private IFavoriteDao_24110013 favoriteDao = new FavoriteDao_24110013();

    @Override
    public long countByVideoId(String videoId) {
        return favoriteDao.countByVideoId(videoId);
    }

    @Override
    public boolean isLiked(String username, String videoId) {
        return favoriteDao.isLiked(username, videoId);
    }

    @Override
    public void insert(Favorite_24110013 favorite) {
        favoriteDao.insert(favorite);
    }

    @Override
    public void delete(String username, String videoId) {
        favoriteDao.delete(username, videoId);
    }
}
