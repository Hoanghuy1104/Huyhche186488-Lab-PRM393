# Lab 10 Full – Ứng dụng tích hợp toàn diện (Authentication & Local Notifications)

## 1. Giới thiệu tổng quan
Dự án **Lab10_Full** tích hợp toàn bộ các tính năng từ 5 bài lab thành phần vào một ứng dụng hoàn chỉnh:
- **SplashScreen Routing:** Khởi động ứng dụng và tự động kiểm tra phiên đăng nhập từ cả `SharedPreferences` (REST API JWT) và `FirebaseAuth` (Google Sign-In).
- **Real REST API Login:** Đăng nhập thông qua hệ thống REST API DummyJSON, hiển thị JWT Access Token, xử lý trạng thái Loading và lỗi mạng.
- **Auto-Login & Logout:** Tự động khôi phục phiên làm việc sau khi khởi động lại ứng dụng, chức năng đăng xuất xóa toàn bộ session an toàn.
- **Firebase Google Sign-In:** Đăng nhập 1 chạm bằng tài khoản Google, lấy thông tin họ tên, email, avatar URL.
- **Local Notification (LO7):** 
  - Tự động kích hoạt thông báo cục bộ ngay sau khi đăng nhập thành công (`showLoginSuccessNotification`).
  - Kích hoạt thông báo khi người dùng đăng xuất (`showLogoutNotification`).
  - Hỗ trợ nút kiểm thử phát thông báo trực tiếp trên màn hình Home (`showTestNotification`).

## 2. Tài khoản kiểm thử (Test Account)
### Cách 1: Đăng nhập REST API (DummyJSON)
- **Username:** `emilys`
- **Password:** `emilyspass`
*(Hoặc bất kỳ tài khoản nào được hỗ trợ tại DummyJSON Auth API).*

### Cách 2: Đăng nhập Google
- Bấm vào nút **"Đăng nhập bằng tài khoản Google"** và chọn tài khoản Google trên máy.

## 3. Hướng dẫn chạy ứng dụng
1. Mở terminal tại thư mục dự án:
   ```bash
   cd Lab10_Full
   ```
2. Cài đặt các gói phụ thuộc:
   ```bash
   flutter pub get
   ```
3. Chạy ứng dụng trên thiết bị Android:
   ```bash
   flutter run
   ```

## 4. Kịch bản kiểm thử (Test Scenarios)
1. **Kiểm thử REST API & Notification:**
   - Mở ứng dụng, nhập `emilys` / `emilyspass` và bấm **Đăng nhập với REST API**.
   - Kiểm tra thông báo: Điện thoại hiện thông báo *"Đăng nhập thành công! Chào mừng Emily Johnson..."*.
   - Màn hình Home hiển thị họ tên, email và chuỗi JWT Token.
2. **Kiểm thử Auto-Login:**
   - Tắt ứng dụng hoàn toàn và mở lại.
   - Ứng dụng hiển thị Splash Screen 2 giây rồi tự động chuyển thẳng vào Home Screen mà không bắt đăng nhập lại.
3. **Kiểm thử Logout:**
   - Bấm nút **Đăng xuất**.
   - Thông báo *"Đăng xuất thành công"* xuất hiện. Ứng dụng quay về màn hình Login.
   - Tắt và mở lại ứng dụng: Ứng dụng dừng ở màn hình Login (Session đã được xóa).
4. **Kiểm thử Google Sign-In:**
   - Bấm nút **Đăng nhập bằng tài khoản Google**, chọn tài khoản.
   - Nhận thông báo đăng nhập thành công.
   - Màn hình Home hiển thị Avatar Google, họ tên, email và huy hiệu "Google Firebase Auth".
5. **Kiểm thử thông báo thủ công (LO7):**
   - Trên màn hình Home, bấm nút **"Bắn thông báo thử nghiệm"** để kiểm tra notification bất cứ lúc nào.
