package vn.iotstar.model;

import vn.iotstar.entity.Video_24110013;
import java.io.Serializable;

public class CartItemModel_24110013 implements Serializable {
    private static final long serialVersionUID = 1L;

    private Video_24110013 video;
    private int quantity;
    private double price;

    public CartItemModel_24110013() {
    }

    public CartItemModel_24110013(Video_24110013 video, int quantity) {
        this.video = video;
        this.quantity = quantity;
        this.price = (video != null && video.getPrice() != null) ? video.getPrice() : 150000.0;
    }

    public Video_24110013 getVideo() {
        return video;
    }

    public void setVideo(Video_24110013 video) {
        this.video = video;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getSubtotal() {
        return price * quantity;
    }

    public int getMaxQuantity() {
        return (video != null && video.getQuantity() != null) ? video.getQuantity() : 99;
    }
}
