package vn.iotstar.service;

import vn.iotstar.dao.IShareDao_24110013;
import vn.iotstar.dao.ShareDao_24110013;
import vn.iotstar.entity.Share_24110013;

public class ShareService_24110013 implements IShareService_24110013 {
    private IShareDao_24110013 shareDao = new ShareDao_24110013();

    @Override
    public long countByVideoId(String videoId) {
        return shareDao.countByVideoId(videoId);
    }

    @Override
    public void insert(Share_24110013 share) {
        shareDao.insert(share);
    }
}
