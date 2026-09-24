package vn.iotstar.service;

import vn.iotstar.dao.IVideoDao_24110013;
import vn.iotstar.dao.VideoDao_24110013;
import vn.iotstar.entity.Video_24110013;
import java.util.List;

public class VideoService_24110013 implements IVideoService_24110013 {
    private IVideoDao_24110013 videoDao = new VideoDao_24110013();

    @Override
    public void insert(Video_24110013 video) {
        videoDao.insert(video);
    }

    @Override
    public void update(Video_24110013 video) {
        videoDao.update(video);
    }

    @Override
    public void delete(String videoId) {
        videoDao.delete(videoId);
    }

    @Override
    public Video_24110013 findById(String videoId) {
        return videoDao.findById(videoId);
    }

    @Override
    public List<Video_24110013> findAll() {
        return videoDao.findAll();
    }

    @Override
    public List<Video_24110013> findAll(int page, int pageSize) {
        return videoDao.findAll(page, pageSize);
    }

    @Override
    public long countAll() {
        return videoDao.countAll();
    }

    @Override
    public List<Video_24110013> findByCategoryId(int categoryId, int page, int pageSize) {
        return videoDao.findByCategoryId(categoryId, page, pageSize);
    }

    @Override
    public long countByCategoryId(int categoryId) {
        return videoDao.countByCategoryId(categoryId);
    }

    @Override
    public void increaseViews(String videoId) {
        videoDao.increaseViews(videoId);
    }
}
