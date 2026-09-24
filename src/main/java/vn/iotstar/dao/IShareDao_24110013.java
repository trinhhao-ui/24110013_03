package vn.iotstar.dao;

import vn.iotstar.entity.Share_24110013;

public interface IShareDao_24110013 {
    long countByVideoId(String videoId);
    void insert(Share_24110013 share);
}
