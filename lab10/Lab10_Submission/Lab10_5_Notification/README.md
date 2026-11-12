# Lab 10.5 – Local Notification (MANDATORY – LO7)

## 1. Giới thiệu
Dự án đáp ứng chuẩn đầu ra **LO7** – Tích hợp thông báo cục bộ (Local Notification) trong ứng dụng di động:
- Cấu hình thư viện `flutter_local_notifications`.
- Khởi tạo Notification Channel với độ ưu tiên cao (`Importance.max`, `Priority.high`).
- Tự động yêu cầu quyền gửi thông báo trên Android 13+ (API 33+ `POST_NOTIFICATIONS`).
- Nút bấm phát thông báo tức thì hiển thị trên thanh trạng thái (status bar) của hệ thống.

## 2. Hướng dẫn chạy và kiểm thử
1. Mở terminal tại thư mục này:
   ```bash
   cd Lab10_5_Notification
   ```
2. Cài đặt các gói thư viện:
   ```bash
   flutter pub get
   ```
3. Chạy ứng dụng trên thiết bị Android:
   ```bash
   flutter run
   ```
4. Khi ứng dụng khởi động lần đầu trên Android 13+, chọn **Allow** (Cho phép) khi hộp thoại xin quyền thông báo xuất hiện.
5. Bấm nút **"Bắn thông báo thử nghiệm"** để kiểm tra thông báo xuất hiện trên thanh trạng thái hệ thống.
