package vn.iotstar.model;

import vn.iotstar.entity.Category_24110013;
import java.util.List;

public class CategoryVideosModel_24110013 {
    private Category_24110013 category;
    private long totalVideos;
    private int currentPage;
    private int totalPages;
    private List<VideoItemModel_24110013> videoItems;

    public CategoryVideosModel_24110013() {
    }

    public CategoryVideosModel_24110013(Category_24110013 category, long totalVideos, int currentPage, int totalPages, List<VideoItemModel_24110013> videoItems) {
        this.category = category;
        this.totalVideos = totalVideos;
        this.currentPage = currentPage;
        this.totalPages = totalPages;
        this.videoItems = videoItems;
    }

    public Category_24110013 getCategory() {
        return category;
    }

    public void setCategory(Category_24110013 category) {
        this.category = category;
    }

    public long getTotalVideos() {
        return totalVideos;
    }

    public void setTotalVideos(long totalVideos) {
        this.totalVideos = totalVideos;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public List<VideoItemModel_24110013> getVideoItems() {
        return videoItems;
    }

    public void setVideoItems(List<VideoItemModel_24110013> videoItems) {
        this.videoItems = videoItems;
    }
}
