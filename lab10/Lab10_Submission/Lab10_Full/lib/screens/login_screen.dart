import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user.dart';
import '../services/notification_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');

  bool _isApiLoading = false;
  bool _isGoogleLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 1. Đăng nhập qua Real REST API (DummyJSON)
  Future<void> _loginWithApi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isApiLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse('https://dummyjson.com/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
          'expiresInMins': 60,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = (data['token'] ?? data['accessToken'] ?? '').toString();
        final firstName = (data['firstName'] ?? '').toString();
        final lastName = (data['lastName'] ?? '').toString();
        final username = (data['username'] ?? _usernameController.text.trim()).toString();
        final email = (data['email'] ?? '$username@dummyjson.com').toString();
        final fullName = '$firstName $lastName'.trim().isNotEmpty
            ? '$firstName $lastName'.trim()
            : username;

        // Lưu session vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('username', username);
        await prefs.setString('full_name', fullName);
        await prefs.setString('email', email);
        await prefs.setString('auth_provider', 'rest_api');

        // Bắn thông báo đăng nhập thành công (LO7)
        await NotificationService.instance.showLoginSuccessNotification(
          userName: fullName,
        );

        if (!mounted) return;

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
      } else {
        setState(() {
          _errorMessage = data['message'] ?? 'Đăng nhập API thất bại! Vui lòng thử lại.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối mạng: $e';
      });
    } finally {
      if (mounted) setState(() => _isApiLoading = false);
    }
  }

  // 2. Đăng nhập bằng Google thông qua Firebase Authentication
  Future<void> _loginWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });

    try {
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Không tìm thấy thông tin tài khoản Google.');
      }

      final displayName = firebaseUser.displayName ?? 'Người dùng Google';
      final email = firebaseUser.email ?? 'google@account.com';
      final photoUrl = firebaseUser.photoURL;

      // Lưu trạng thái session vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_provider', 'google');
      await prefs.setString('full_name', displayName);
      await prefs.setString('email', email);

      // Bắn thông báo đăng nhập thành công (LO7)
      await NotificationService.instance.showLoginSuccessNotification(
        userName: displayName,
      );

      if (!mounted) return;

      final authUser = AuthUser(
        provider: AuthProviderType.firebaseGoogle,
        displayName: displayName,
        email: email,
        photoUrl: photoUrl,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: authUser)),
      );
    } catch (e) {
      if (e is GoogleSignInException &&
          e.code == GoogleSignInExceptionCode.canceled) {
        // Người dùng tự hủy đăng nhập
        return;
      }
      setState(() {
        _errorMessage = 'Lỗi đăng nhập Google: $e';
      });
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final anyLoading = _isApiLoading || _isGoogleLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10 Full - Authentication'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 72,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Hệ thống Xác thực Toàn diện',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Hỗ trợ REST API DummyJSON & Firebase Google Sign-In',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username (DummyJSON)',
                    hintText: 'emilys',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Vui lòng nhập Username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password (DummyJSON)',
                    hintText: 'emilyspass',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Vui lòng nhập Password';
                    }
                    if (val.trim().length < 6) {
                      return 'Mật khẩu phải từ 6 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // REST API Login Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: anyLoading ? null : _loginWithApi,
                    child: _isApiLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Đăng nhập với REST API',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('HOẶC', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),

                // Firebase Google Sign-In Button
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    icon: _isGoogleLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.g_mobiledata, color: Colors.red, size: 28),
                    label: const Text(
                      'Đăng nhập bằng tài khoản Google',
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    onPressed: anyLoading ? null : _loginWithGoogle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

