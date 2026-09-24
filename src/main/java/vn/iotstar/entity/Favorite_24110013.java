package vn.iotstar.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "Favorites")
public class Favorite_24110013 implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "FavoriteId")
    private Integer favoriteId;

    @Temporal(TemporalType.DATE)
    @Column(name = "LikedDate")
    private Date likedDate = new Date();

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "VideoId", nullable = false)
    private Video_24110013 video;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Username", nullable = false)
    private User_24110013 user;

    public Favorite_24110013() {
    }

    public Favorite_24110013(Video_24110013 video, User_24110013 user, Date likedDate) {
        this.video = video;
        this.user = user;
        this.likedDate = likedDate;
    }

    public Integer getFavoriteId() {
        return favoriteId;
    }

    public void setFavoriteId(Integer favoriteId) {
        this.favoriteId = favoriteId;
    }

    public Date getLikedDate() {
        return likedDate;
    }

    public void setLikedDate(Date likedDate) {
        this.likedDate = likedDate;
    }

    public Video_24110013 getVideo() {
        return video;
    }

    public void setVideo(Video_24110013 video) {
        this.video = video;
    }

    public User_24110013 getUser() {
        return user;
    }

    public void setUser(User_24110013 user) {
        this.user = user;
    }
}
