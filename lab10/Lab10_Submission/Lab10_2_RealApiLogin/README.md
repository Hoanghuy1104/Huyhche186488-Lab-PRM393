# Lab 10.2 – Real REST API Login (DummyJSON)

## 1. Giới thiệu
Dự án thực hiện xác thực người dùng thông qua REST API thực tế của hệ thống [DummyJSON](https://dummyjson.com/docs/auth):
- Gửi yêu cầu HTTP POST tới `https://dummyjson.com/auth/login`.
- Xử lý trạng thái tải (loading spinner) khi đang gọi API.
- Bóc tách mã JWT Token (`accessToken`) và thông tin người dùng từ dữ liệu JSON trả về.
- Xử lý lỗi kết nối và phản hồi lỗi từ server một cách trực quan.

## 2. Tài khoản kiểm thử (Test Account)
- **Username:** `emilys`
- **Password:** `emilyspass`

*(Hệ thống đã điền sẵn tài khoản mẫu trên form đăng nhập để thuận tiện kiểm thử).*

## 3. Hướng dẫn chạy ứng dụng
1. Mở terminal tại thư mục này:
   ```bash
   cd Lab10_2_RealApiLogin
   ```
2. Tải các dependencies:
   ```bash
   flutter pub get
   ```
3. Chạy ứng dụng (yêu cầu thiết bị có kết nối Internet để gọi API):
   ```bash
   flutter run
   ```
