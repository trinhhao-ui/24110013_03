package vn.iotstar.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "Videos")
public class Video_24110013 implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "VideoId", length = 50)
    private String videoId;

    @Column(name = "Title", length = 200, nullable = false)
    private String title;

    @Column(name = "Poster", length = 500)
    private String poster;

    @Column(name = "Views")
    private Integer views = 0;

    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "Active")
    private Boolean active = true;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "CategoryId", nullable = false)
    private Category_24110013 category;

    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Favorite_24110013> favorites;

    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Share_24110013> shares;

    public Video_24110013() {
    }

    public Video_24110013(String videoId, String title, String poster, Integer views, String description, Boolean active, Category_24110013 category) {
        this.videoId = videoId;
        this.title = title;
        this.poster = poster;
        this.views = views;
        this.description = description;
        this.active = active;
        this.category = category;
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public Integer getViews() {
        return views != null ? views : 0;
    }

    public void setViews(Integer views) {
        this.views = views;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getActive() {
        return active != null && active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public Category_24110013 getCategory() {
        return category;
    }

    public void setCategory(Category_24110013 category) {
        this.category = category;
    }

    public List<Favorite_24110013> getFavorites() {
        return favorites;
    }

    public void setFavorites(List<Favorite_24110013> favorites) {
        this.favorites = favorites;
    }

    public List<Share_24110013> getShares() {
        return shares;
    }

    public void setShares(List<Share_24110013> shares) {
        this.shares = shares;
    }
}
