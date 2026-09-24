package vn.iotstar.model;

import vn.iotstar.entity.Video_24110013;

public class VideoItemModel_24110013 {
    private Video_24110013 video;
    private long likeCount;
    private long shareCount;

    public VideoItemModel_24110013() {
    }

    public VideoItemModel_24110013(Video_24110013 video, long likeCount, long shareCount) {
        this.video = video;
        this.likeCount = likeCount;
        this.shareCount = shareCount;
    }

    public Video_24110013 getVideo() {
        return video;
    }

    public void setVideo(Video_24110013 video) {
        this.video = video;
    }

    public long getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(long likeCount) {
        this.likeCount = likeCount;
    }

    public long getShareCount() {
        return shareCount;
    }

    public void setShareCount(long shareCount) {
        this.shareCount = shareCount;
    }
}
