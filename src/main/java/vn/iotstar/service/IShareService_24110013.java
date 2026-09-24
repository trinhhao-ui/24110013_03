package vn.iotstar.service;

import vn.iotstar.entity.Share_24110013;

public interface IShareService_24110013 {
    long countByVideoId(String videoId);
    void insert(Share_24110013 share);
}
