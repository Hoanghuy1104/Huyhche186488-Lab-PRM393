import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthSession();
  }

  Future<void> _checkAuthSession() async {
    // Độ trễ hiển thị Splash Screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 1. Kiểm tra session từ Firebase Google Sign-In
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final authUser = AuthUser(
        provider: AuthProviderType.firebaseGoogle,
        displayName: firebaseUser.displayName ?? 'Người dùng Google',
        email: firebaseUser.email ?? 'google@account.com',
        photoUrl: firebaseUser.photoURL,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: authUser)),
      );
      return;
    }

    // 2. Kiểm tra session từ SharedPreferences (REST API Token)
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      final fullName = prefs.getString('full_name') ??
          prefs.getString('username') ??
          'Người dùng REST API';
      final email = prefs.getString('email') ?? prefs.getString('username') ?? '';

      final authUser = AuthUser(
        provider: AuthProviderType.restApi,
        displayName: fullName,
        email: email,
        token: token,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: authUser)),
      );
      return;
    }

    // 3. Nếu chưa đăng nhập, chuyển tới LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.security_rounded,
                size: 80,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Lab 10 - Full Application',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Authentication & Local Notification',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 36),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
            ),
            const SizedBox(height: 16),
            const Text(
              'Đang kiểm tra phiên đăng nhập...',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
