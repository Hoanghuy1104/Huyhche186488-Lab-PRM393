# Lab 10.1 – Mock Login (Backend Simulation)

## 1. Giới thiệu
Dự án mô phỏng quá trình xác thực người dùng (Backend Simulation) trên Flutter:
- Form đăng nhập có đầy đủ validation (kiểm tra định dạng email, độ dài mật khẩu).
- Giả lập độ trễ mạng (`Future.delayed`) trong 2 giây khi gửi yêu cầu.
- Điều hướng sang màn hình Home khi đăng nhập thành công hoặc hiển thị thông báo lỗi nếu thông tin không đúng.

## 2. Tài khoản kiểm thử (Test Account)
- **Email:** `admin@gmail.com`
- **Password:** `123456`

*(Nếu nhập sai bất kỳ trường nào, ứng dụng sẽ báo lỗi "Email hoặc mật khẩu không chính xác!").*

## 3. Hướng dẫn chạy ứng dụng
1. Mở terminal tại thư mục này:
   ```bash
   cd Lab10_1_MockLogin
   ```
2. Cài đặt các thư viện cần thiết:
   ```bash
   flutter pub get
   ```
3. Chạy ứng dụng trên thiết bị hoặc máy ảo:
   ```bash
   flutter run
   ```
