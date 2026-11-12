import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const RealApiApp());
}

class RealApiApp extends StatelessWidget {
  const RealApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RealApiLoginScreen(),
    );
  }
}

class RealApiLoginScreen extends StatefulWidget {
  const RealApiLoginScreen({super.key});

  @override
  State<RealApiLoginScreen> createState() => _RealApiLoginScreenState();
}

class _RealApiLoginScreenState extends State<RealApiLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  // DummyJSON mặc định yêu cầu Username (vd: emilys / emilyspass)
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _loginWithApi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
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
        final token = data['token'] ?? data['accessToken'];
        final fullName = '${data['firstName']} ${data['lastName']}';
        
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ApiHomeScreen(token: token, fullName: fullName),
          ),
        );
      } else {
        setState(() {
          _errorMessage = data['message'] ?? 'Đăng nhập thất bại!';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối mạng: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.2 - DummyJSON API Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    color: Colors.red.shade100,
                    child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                  ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username (Thử: emilys)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Nhập username' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password (Thử: emilyspass)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Nhập password' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loginWithApi,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Đăng nhập API'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ApiHomeScreen extends StatelessWidget {
  final String token;
  final String fullName;

  const ApiHomeScreen({super.key, required this.token, required this.fullName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Xin chào, $fullName!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('JWT Token nhận được:'),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey.shade200,
              child: Text(token, maxLines: 3, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RealApiLoginScreen()),
                );
              },
              child: const Text('Quay lại Login'),
            )
          ],
        ),
      ),
    );
  }
}