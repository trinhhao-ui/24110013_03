package vn.iotstar.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.Random;

public class EmailUtils_24110013 {
    private static final String FROM_EMAIL = "trinhphuhao2108@gmail.com";
    private static final String APP_PASSWORD = "szrh wwdx swtb nrld";

    public static String generateOtp(int length) {
        String numbers = "0123456789";
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(numbers.charAt(rnd.nextInt(numbers.length())));
        }
        return sb.toString();
    }

    public static boolean sendOtp(String toEmail, String otp) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD.replace(" ", ""));
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "WebVideo - Trịnh Văn Phú Hào - 24110013"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP kích hoạt tài khoản - WebVideo");

            String content = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px;'>"
                    + "<h2 style='color: #0d6efd; text-align: center;'>KÍCH HOẠT TÀI KHOẢN</h2>"
                    + "<p>Xin chào,</p>"
                    + "<p>Bạn vừa đăng ký tài khoản tại hệ thống <strong>WebVideo</strong> (Đề thi 03 - Sinh viên: Trịnh Văn Phú Hào - MSSV: 24110013).</p>"
                    + "<p>Mã OTP kích hoạt của bạn là:</p>"
                    + "<div style='text-align: center; margin: 20px 0;'>"
                    + "<span style='font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #dc3545; background: #f8f9fa; padding: 10px 20px; border: 2px dashed #dc3545; border-radius: 6px;'>"
                    + otp + "</span>"
                    + "</div>"
                    + "<p style='color: #6c757d; font-size: 13px;'>Mã OTP này có hiệu lực trong vòng 5 phút. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>"
                    + "<hr style='border: none; border-top: 1px solid #eee;'/>"
                    + "<p style='font-size: 12px; color: #999; text-align: center;'>Họ tên: Trịnh Văn Phú Hào | MSSV: 24110013 | Mã đề: 03</p>"
                    + "</div>";

            message.setContent(content, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
