package vn.iotstar.dao;

import vn.iotstar.entity.Video_24110013;
import java.util.List;

public interface IVideoDao_24110013 {
    void insert(Video_24110013 video);
    void update(Video_24110013 video);
    void delete(String videoId);
    Video_24110013 findById(String videoId);
    List<Video_24110013> findAll();
    List<Video_24110013> findAll(int page, int pageSize);
    long countAll();
    List<Video_24110013> findByCategoryId(int categoryId, int page, int pageSize);
    long countByCategoryId(int categoryId);
    void increaseViews(String videoId);
}
