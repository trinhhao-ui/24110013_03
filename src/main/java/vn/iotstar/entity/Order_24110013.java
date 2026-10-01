package vn.iotstar.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "Orders")
public class Order_24110013 implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "OrderId", length = 50)
    private String orderId;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "OrderDate")
    private Date orderDate = new Date();

    @Column(name = "RecipientName", length = 100, nullable = false)
    private String recipientName;

    @Column(name = "Phone", length = 20, nullable = false)
    private String phone;

    @Column(name = "Address", length = 255, nullable = false)
    private String address;

    @Column(name = "Note", length = 500)
    private String note;

    @Column(name = "TotalAmount", nullable = false)
    private Double totalAmount;

    @Column(name = "ShippingFee")
    private Double shippingFee = 30000.0;

    @Column(name = "PaymentMethod", length = 50)
    private String paymentMethod = "COD";

    @Column(name = "Status", length = 50)
    private String status = "PENDING"; // PENDING, PROCESSING, SHIPPING, DELIVERED, CANCELLED

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Username")
    private User_24110013 user;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<OrderDetail_24110013> orderDetails;

    public Order_24110013() {
    }

    public Order_24110013(String orderId, String recipientName, String phone, String address, String note, Double totalAmount, Double shippingFee, String paymentMethod, String status, User_24110013 user) {
        this.orderId = orderId;
        this.orderDate = new Date();
        this.recipientName = recipientName;
        this.phone = phone;
        this.address = address;
        this.note = note;
        this.totalAmount = totalAmount;
        this.shippingFee = shippingFee;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.user = user;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(Double shippingFee) {
        this.shippingFee = shippingFee;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public User_24110013 getUser() {
        return user;
    }

    public void setUser(User_24110013 user) {
        this.user = user;
    }

    public List<OrderDetail_24110013> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail_24110013> orderDetails) {
        this.orderDetails = orderDetails;
    }

    public String getStatusVietnamese() {
        if ("PENDING".equalsIgnoreCase(status)) return "Chờ xác nhận";
        if ("PROCESSING".equalsIgnoreCase(status)) return "Đang chuẩn bị hàng";
        if ("SHIPPING".equalsIgnoreCase(status)) return "Đang giao hàng (COD)";
        if ("DELIVERED".equalsIgnoreCase(status)) return "Giao thành công (Đã thu COD)";
        if ("CANCELLED".equalsIgnoreCase(status)) return "Đã hủy đơn";
        return status;
    }

    public String getStatusBadgeClass() {
        if ("PENDING".equalsIgnoreCase(status)) return "bg-warning text-dark";
        if ("PROCESSING".equalsIgnoreCase(status)) return "bg-info text-dark";
        if ("SHIPPING".equalsIgnoreCase(status)) return "bg-primary";
        if ("DELIVERED".equalsIgnoreCase(status)) return "bg-success";
        if ("CANCELLED".equalsIgnoreCase(status)) return "bg-danger";
        return "bg-secondary";
    }

    public boolean isHasInvoice() {
        return "DELIVERED".equalsIgnoreCase(status);
    }

    public String getInvoiceNumber() {
        if (isHasInvoice()) {
            return "HD-" + orderId;
        }
        return null;
    }
}
