package vn.iotstar.service;

import vn.iotstar.entity.Favorite_24110013;

public interface IFavoriteService_24110013 {
    long countByVideoId(String videoId);
    boolean isLiked(String username, String videoId);
    void insert(Favorite_24110013 favorite);
    void delete(String username, String videoId);
}
