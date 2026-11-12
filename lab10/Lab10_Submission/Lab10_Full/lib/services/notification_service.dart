import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings: initSettings);

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    _isInitialized = true;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'lab10_full_channel',
      'Lab 10 Full Notifications',
      channelDescription: 'Kênh thông báo tích hợp cho Lab 10 Full',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  Future<void> showLoginSuccessNotification({required String userName}) async {
    await showNotification(
      id: 1001,
      title: 'Đăng nhập thành công! 🎉',
      body: 'Chào mừng $userName đã đăng nhập vào hệ thống.',
    );
  }

  Future<void> showLogoutNotification() async {
    await showNotification(
      id: 1002,
      title: 'Đăng xuất thành công',
      body: 'Phiên làm việc của bạn đã được xóa an toàn.',
    );
  }

  Future<void> showTestNotification() async {
    await showNotification(
      id: 1003,
      title: 'Thông báo cục bộ (LO7)',
      body: 'Hệ thống Local Notification đang hoạt động chính xác trên thiết bị!',
    );
  }
}

