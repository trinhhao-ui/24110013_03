package vn.iotstar.model;

import vn.iotstar.entity.Video_24110013;
import java.io.Serializable;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class CartModel_24110013 implements Serializable {
    private static final long serialVersionUID = 1L;

    private Map<String, CartItemModel_24110013> items = new LinkedHashMap<>();
    private String lastNotice;

    public CartModel_24110013() {
    }

    public Collection<CartItemModel_24110013> getItems() {
        return items.values();
    }

    public Map<String, CartItemModel_24110013> getItemsMap() {
        return items;
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public int getItemCount() {
        return items.size();
    }

    /**
     * Thêm sản phẩm vào giỏ hàng với kiểm tra giới hạn tồn kho
     */
    public boolean addItem(Video_24110013 video, int qtyToAdd) {
        if (video == null || qtyToAdd <= 0) {
            return false;
        }

        int stock = video.getQuantity() != null ? video.getQuantity() : 0;
        if (stock <= 0) {
            this.lastNotice = "Sản phẩm \"" + video.getTitle() + "\" hiện đã hết hàng trong kho!";
            return false;
        }

        CartItemModel_24110013 existing = items.get(video.getVideoId());
        if (existing == null) {
            int finalQty = Math.min(qtyToAdd, stock);
            items.put(video.getVideoId(), new CartItemModel_24110013(video, finalQty));
            if (qtyToAdd > stock) {
                this.lastNotice = "Đã thêm " + finalQty + " sản phẩm vào giỏ (đạt số lượng tồn kho tối đa là " + stock + ")!";
            } else {
                this.lastNotice = "Đã thêm \"" + video.getTitle() + "\" vào giỏ hàng thành công!";
            }
        } else {
            int currentQty = existing.getQuantity();
            int targetQty = currentQty + qtyToAdd;
            if (targetQty > stock) {
                existing.setQuantity(stock);
                this.lastNotice = "Số lượng trong giỏ đã đạt giới hạn tồn kho tối đa (" + stock + " sản phẩm)!";
            } else {
                existing.setQuantity(targetQty);
                this.lastNotice = "Đã cập nhật số lượng trong giỏ hàng thành " + targetQty + "!";
            }
        }
        return true;
    }

    /**
     * Thay đổi số lượng sản phẩm trong giỏ hàng (có giới hạn min=1, max=stock)
     */
    public boolean updateQuantity(String videoId, int newQty) {
        CartItemModel_24110013 item = items.get(videoId);
        if (item == null) {
            return false;
        }

        if (newQty <= 0) {
            items.remove(videoId);
            this.lastNotice = "Đã xóa sản phẩm khỏi giỏ hàng!";
            return true;
        }

        int stock = item.getMaxQuantity();
        if (newQty > stock) {
            item.setQuantity(stock);
            this.lastNotice = "Số lượng yêu cầu vượt quá tồn kho! Đã đặt về mức tối đa: " + stock + " sản phẩm.";
            return false;
        } else {
            item.setQuantity(newQty);
            this.lastNotice = "Đã cập nhật số lượng thành " + newQty + "!";
            return true;
        }
    }

    /**
     * Xóa 1 sản phẩm khỏi giỏ
     */
    public void removeItem(String videoId) {
        if (items.remove(videoId) != null) {
            this.lastNotice = "Đã xóa sản phẩm khỏi giỏ hàng!";
        }
    }

    /**
     * Xóa toàn bộ giỏ hàng
     */
    public void clear() {
        items.clear();
        this.lastNotice = "Đã dọn sạch toàn bộ giỏ hàng!";
    }

    /**
     * Tổng số lượng sản phẩm trong giỏ
     */
    public int getTotalQuantity() {
        int total = 0;
        for (CartItemModel_24110013 item : items.values()) {
            total += item.getQuantity();
        }
        return total;
    }

    /**
     * Tổng tiền hàng (Tạm tính)
     */
    public double getSubtotal() {
        double subtotal = 0;
        for (CartItemModel_24110013 item : items.values()) {
            subtotal += item.getSubtotal();
        }
        return subtotal;
    }

    /**
     * Phí giao hàng COD: Mặc định 30.000 VNĐ, miễn phí nếu đơn >= 500.000 VNĐ
     */
    public double getShippingFee() {
        if (isEmpty()) return 0;
        return getSubtotal() >= 500000.0 ? 0.0 : 30000.0;
    }

    /**
     * Tổng thanh toán = Tạm tính + Phí vận chuyển
     */
    public double getTotalAmount() {
        if (isEmpty()) return 0;
        return getSubtotal() + getShippingFee();
    }

    public String getLastNotice() {
        return lastNotice;
    }

    public void setLastNotice(String lastNotice) {
        this.lastNotice = lastNotice;
    }
}
