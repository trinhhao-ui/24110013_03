package vn.iotstar;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class UpdateDbSchema {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=WebVideoDB_24110013;encrypt=false;trustServerCertificate=true;";
        String user = "sa";
        String pass = "0373703896Hao@";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement()) {

                System.out.println("Kết nối SQL Server thành công!");

                // 1. Thêm Price và Quantity vào bảng Videos nếu chưa có
                try {
                    stmt.executeUpdate("ALTER TABLE Videos ADD Price FLOAT DEFAULT 150000;");
                    System.out.println("Đã thêm cột Price vào Videos.");
                } catch (Exception e) {
                    System.out.println("Cột Price đã tồn tại hoặc bỏ qua: " + e.getMessage());
                }

                try {
                    stmt.executeUpdate("ALTER TABLE Videos ADD Quantity INT DEFAULT 20;");
                    System.out.println("Đã thêm cột Quantity vào Videos.");
                } catch (Exception e) {
                    System.out.println("Cột Quantity đã tồn tại hoặc bỏ qua: " + e.getMessage());
                }

                // Cập nhật giá và tồn kho mẫu nếu đang NULL hoặc 0
                stmt.executeUpdate("UPDATE Videos SET Price = 120000, Quantity = 25 WHERE VideoId = 'V001' AND (Price IS NULL OR Price = 0);");
                stmt.executeUpdate("UPDATE Videos SET Price = 180000, Quantity = 15 WHERE VideoId = 'V002' AND (Price IS NULL OR Price = 0);");
                stmt.executeUpdate("UPDATE Videos SET Price = 90000, Quantity = 30 WHERE VideoId = 'V003' AND (Price IS NULL OR Price = 0);");
                stmt.executeUpdate("UPDATE Videos SET Price = 250000, Quantity = 10 WHERE VideoId = 'V004' AND (Price IS NULL OR Price = 0);");
                stmt.executeUpdate("UPDATE Videos SET Price = 150000, Quantity = 20 WHERE Price IS NULL OR Price = 0;");
                stmt.executeUpdate("UPDATE Videos SET Quantity = 20 WHERE Quantity IS NULL OR Quantity = 0;");
                System.out.println("Đã cập nhật dữ liệu mẫu Price và Quantity cho Videos.");

                // 2. Tạo bảng Orders nếu chưa có
                String createOrdersSql = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Orders' and xtype='U') " +
                        "CREATE TABLE Orders (" +
                        "    OrderId NVARCHAR(50) PRIMARY KEY," +
                        "    OrderDate DATETIME DEFAULT GETDATE()," +
                        "    RecipientName NVARCHAR(100) NOT NULL," +
                        "    Phone NVARCHAR(20) NOT NULL," +
                        "    Address NVARCHAR(255) NOT NULL," +
                        "    Note NVARCHAR(500) NULL," +
                        "    TotalAmount FLOAT NOT NULL," +
                        "    ShippingFee FLOAT DEFAULT 30000," +
                        "    PaymentMethod NVARCHAR(50) DEFAULT 'COD'," +
                        "    Status NVARCHAR(50) DEFAULT 'PENDING'," +
                        "    Username NVARCHAR(50) NULL," +
                        "    CONSTRAINT FK_Orders_Users FOREIGN KEY (Username) REFERENCES Users(Username) ON DELETE SET NULL" +
                        ");";
                stmt.executeUpdate(createOrdersSql);
                System.out.println("Bảng Orders đã được kiểm tra/tạo thành công.");

                // 3. Tạo bảng OrderDetails nếu chưa có
                String createOrderDetailsSql = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='OrderDetails' and xtype='U') " +
                        "CREATE TABLE OrderDetails (" +
                        "    OrderDetailId INT IDENTITY(1,1) PRIMARY KEY," +
                        "    OrderId NVARCHAR(50) NOT NULL," +
                        "    VideoId NVARCHAR(50) NOT NULL," +
                        "    Quantity INT NOT NULL," +
                        "    Price FLOAT NOT NULL," +
                        "    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE," +
                        "    CONSTRAINT FK_OrderDetails_Videos FOREIGN KEY (VideoId) REFERENCES Videos(VideoId) ON DELETE CASCADE" +
                        ");";
                stmt.executeUpdate(createOrderDetailsSql);
                System.out.println("Bảng OrderDetails đã được kiểm tra/tạo thành công.");

                System.out.println("HOÀN TẤT CẬP NHẬT DATABASE!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
