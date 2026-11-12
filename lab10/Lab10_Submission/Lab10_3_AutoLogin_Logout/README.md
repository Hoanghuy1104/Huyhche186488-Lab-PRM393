# Lab 10.3 – Auto Login & Logout (Session Management)

## 1. Giới thiệu
Dự án quản lý phiên đăng nhập của người dùng sử dụng bộ nhớ cục bộ `shared_preferences`:
- Màn hình Splash (`SplashScreen`) tự động kiểm tra token lưu trữ cục bộ khi khởi động.
- Nếu token đã tồn tại: Tự động đăng nhập thẳng vào màn hình `Home` mà không cần nhập lại tài khoản (Auto-login).
- Nếu chưa có token: Chuyển đến màn hình `Login`.
- Chức năng **Đăng xuất (Logout)**: Xóa token và dữ liệu phiên khỏi thiết bị, đưa người dùng quay lại màn hình Login.

## 2. Tài khoản kiểm thử (Test Account)
- **Username:** `emilys`
- **Password:** `emilyspass`

## 3. Hướng dẫn kiểm thử Auto-Login & Logout
1. Mở terminal và tải dependencies:
   ```bash
   cd Lab10_3_AutoLogin_Logout
   flutter pub get
   ```
2. Chạy ứng dụng:
   ```bash
   flutter run
   ```
3. Đăng nhập bằng tài khoản `emilys` / `emilyspass`.
4. Thoát hoàn toàn ứng dụng (hoặc bấm Restart/Hot Restart). Mở lại app sẽ thấy SplashScreen tự động nhảy thẳng vào Home screen (Auto Login thành công).
5. Bấm nút **Đăng xuất (Xóa Session)** trên Home screen, sau đó khởi động lại app sẽ thấy ứng dụng dừng ở màn hình Login (Session đã bị hủy).
