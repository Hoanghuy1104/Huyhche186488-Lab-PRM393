import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user.dart';
import '../services/notification_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthUser user;

  const HomeScreen({super.key, required this.user});

  Future<void> _handleLogout(BuildContext context) async {
    // 1. Xóa session lưu cục bộ
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('username');
    await prefs.remove('full_name');
    await prefs.remove('email');
    await prefs.remove('auth_provider');

    // 2. Đăng xuất Google & Firebase nếu có
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    // 3. Bắn thông báo đăng xuất
    await NotificationService.instance.showLogoutNotification();

    if (!context.mounted) return;

    // 4. Quay về màn hình đăng nhập
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGoogle = user.provider == AuthProviderType.firebaseGoogle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ (Lab 10 Full)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // User Avatar Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    if (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(user.photoUrl!),
                      )
                    else
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: isGoogle ? Colors.red.shade100 : Colors.blue.shade100,
                        child: Icon(
                          isGoogle ? Icons.account_circle : Icons.person,
                          size: 55,
                          color: isGoogle ? Colors.red : Colors.blue,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      user.displayName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      user.email,
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 12),
                    Chip(
                      avatar: Icon(
                        isGoogle ? Icons.g_mobiledata : Icons.api,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        isGoogle ? 'Google Firebase Auth' : 'REST API (DummyJSON)',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: isGoogle ? Colors.red.shade600 : Colors.indigo.shade600,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // JWT Token display if logged in via REST API
            if (user.token != null) ...[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.vpn_key, size: 20, color: Colors.indigo),
                              SizedBox(width: 8),
                              Text(
                                'JWT Access Token',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            tooltip: 'Sao chép token',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: user.token!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Đã sao chép token!')),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          user.token!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Feature Card: Local Notification Test (LO7)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.notifications_active, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          'Kiểm thử Local Notification (LO7)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Bấm nút bên dưới để phát thông báo hệ thống lên thanh trạng thái thiết bị.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.teal,
                          side: const BorderSide(color: Colors.teal),
                        ),
                        icon: const Icon(Icons.send),
                        label: const Text('Bắn thông báo thử nghiệm'),
                        onPressed: () async {
                          await NotificationService.instance.showTestNotification();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã gửi thông báo hệ thống!')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Đăng xuất & Xóa Session',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () => _handleLogout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

