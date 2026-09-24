package vn.iotstar.dao;

import vn.iotstar.entity.Favorite_24110013;

public interface IFavoriteDao_24110013 {
    long countByVideoId(String videoId);
    boolean isLiked(String username, String videoId);
    void insert(Favorite_24110013 favorite);
    void delete(String username, String videoId);
}
