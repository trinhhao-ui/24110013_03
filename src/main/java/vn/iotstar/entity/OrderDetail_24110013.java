package vn.iotstar.entity;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "OrderDetails")
public class OrderDetail_24110013 implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OrderDetailId")
    private Integer orderDetailId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OrderId", nullable = false)
    private Order_24110013 order;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "VideoId", nullable = false)
    private Video_24110013 video;

    @Column(name = "Quantity", nullable = false)
    private Integer quantity;

    @Column(name = "Price", nullable = false)
    private Double price;

    public OrderDetail_24110013() {
    }

    public OrderDetail_24110013(Order_24110013 order, Video_24110013 video, Integer quantity, Double price) {
        this.order = order;
        this.video = video;
        this.quantity = quantity;
        this.price = price;
    }

    public Integer getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(Integer orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public Order_24110013 getOrder() {
        return order;
    }

    public void setOrder(Order_24110013 order) {
        this.order = order;
    }

    public Video_24110013 getVideo() {
        return video;
    }

    public void setVideo(Video_24110013 video) {
        this.video = video;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Double getSubtotal() {
        return (price != null ? price : 0.0) * (quantity != null ? quantity : 0);
    }
}
