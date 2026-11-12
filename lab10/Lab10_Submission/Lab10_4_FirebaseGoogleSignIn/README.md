# Lab 10.4 – Firebase Authentication (Google Sign-In)

## 1. Giới thiệu
Dự án tích hợp phương thức xác thực người dùng bằng tài khoản Google thông qua Firebase Authentication:
- Cấu hình Firebase (`google-services.json` với package name `com.lab10.appname`).
- Luồng đăng nhập Google Sign-In (`google_sign_in` kết hợp `firebase_auth`).
- Hiển thị thông tin hồ sơ người dùng sau khi đăng nhập: Ảnh đại diện (Avatar URL), Họ tên (Display Name), Email.
- Chức năng đăng xuất đồng bộ cả Firebase và Google.

## 2. Tài khoản kiểm thử
- Sử dụng bất kỳ tài khoản Google (@gmail.com) nào khả dụng trên thiết bị Android hoặc máy ảo Google Play.

## 3. Hướng dẫn chạy ứng dụng
1. Mở terminal tại thư mục này:
   ```bash
   cd Lab10_4_FirebaseGoogleSignIn
   ```
2. Tải dependencies:
   ```bash
   flutter pub get
   ```
3. Chạy ứng dụng trên máy ảo Android (có Google Play Services) hoặc thiết bị thật:
   ```bash
   flutter run
   ```
4. Bấm **Đăng nhập bằng tài khoản Google**, chọn tài khoản để đăng nhập và xem thông tin cá nhân trên màn hình hồ sơ.
