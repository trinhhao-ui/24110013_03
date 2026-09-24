package vn.iotstar.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "Shares")
public class Share_24110013 implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ShareId")
    private Integer shareId;

    @Column(name = "Emails", length = 50, nullable = false)
    private String emails;

    @Temporal(TemporalType.DATE)
    @Column(name = "SharedDate")
    private Date sharedDate = new Date();

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Username", nullable = false)
    private User_24110013 user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "VideoId", nullable = false)
    private Video_24110013 video;

    public Share_24110013() {
    }

    public Share_24110013(String emails, User_24110013 user, Video_24110013 video, Date sharedDate) {
        this.emails = emails;
        this.user = user;
        this.video = video;
        this.sharedDate = sharedDate;
    }

    public Integer getShareId() {
        return shareId;
    }

    public void setShareId(Integer shareId) {
        this.shareId = shareId;
    }

    public String getEmails() {
        return emails;
    }

    public void setEmails(String emails) {
        this.emails = emails;
    }

    public Date getSharedDate() {
        return sharedDate;
    }

    public void setSharedDate(Date sharedDate) {
        this.sharedDate = sharedDate;
    }

    public User_24110013 getUser() {
        return user;
    }

    public void setUser(User_24110013 user) {
        this.user = user;
    }

    public Video_24110013 getVideo() {
        return video;
    }

    public void setVideo(Video_24110013 video) {
        this.video = video;
    }
}
