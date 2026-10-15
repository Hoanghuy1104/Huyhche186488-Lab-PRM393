import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Lab 7 - Signup Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 1. Form Key
  final _formKey = GlobalKey<FormState>();

  // 2. State variables for storing form data
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  // 3. UX & Async State variables
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _isCheckingEmail = false;

  // Controllers (Dùng controller để lấy giá trị realtime cho Password Match & Password Strength)
  final TextEditingController _passwordController = TextEditingController();

  // 4. Focus Nodes for Keyboard Navigation
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    // Giải phóng tài nguyên
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  // ================= VALIDATION LOGIC =================

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập Email';
    }
    // Email regex cơ bản kiểm tra có @ và .
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email không hợp lệ (phải chứa @ và .)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ số (0-9)';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (value != _passwordController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  // ================= ENHANCEMENT: PASSWORD STRENGTH =================

  Widget _buildPasswordStrengthIndicator() {
    final password = _passwordController.text;
    if (password.isEmpty) return const SizedBox.shrink();

    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    String label = 'Yếu';
    Color color = Colors.red;

    if (score == 2) {
      label = 'Trung bình';
      color = Colors.orange;
    } else if (score >= 3) {
      label = 'Mạnh';
      color = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 4.0),
      child: Row(
        children: [
          Text(
            'Độ mạnh mật khẩu: ',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ================= SUBMISSION LOGIC (SYNC + ASYNC) =================

  Future<void> _submitForm() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // 1. Kiểm tra validation đồng bộ (Local Validation)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Kiểm tra điều khoản (Bonus Requirement)
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn phải đồng ý với Điều khoản & Điều kiện!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Lưu dữ liệu từ form
    _formKey.currentState!.save();

    // 3. Giả lập Async Validation (Lab 7.4 - Email check)
    setState(() {
      _isCheckingEmail = true;
    });

    try {
      // Giả lập thời gian delay gọi API (2 giây)
      await Future.delayed(const Duration(seconds: 2));

      // Rule giả lập: Email bắt đầu bằng "taken" sẽ báo đã tồn tại
      if (_email.trim().toLowerCase().startsWith('taken')) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email "$_email" đã được sử dụng! Hãy thử email khác.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // 4. Nếu thành công hoàn tất
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng ký thành công! Chào mừng $_fullName.'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingEmail = false;
        });
      }
    }
  }

  // ================= UI BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Ký Tài Khoản'),
        elevation: 0,
        centerTitle: true,
      ),
      // Dismiss keyboard khi tap ngoài màn hình
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              // Tự động kiểm tra lỗi khi người dùng tương tác
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Tạo tài khoản mới',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vui lòng điền đầy đủ thông tin bên dưới',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),

                  // 1. Full Name Field
                  TextFormField(
                    focusNode: _nameFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Họ và tên *',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: _validateFullName,
                    onSaved: (value) => _fullName = value!.trim(),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                  ),
                  const SizedBox(height: 16),

                  // 2. Email Field
                  TextFormField(
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email *',
                      hintText: 'vi-du: taken@gmail.com để test lỗi',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: _validateEmail,
                    onSaved: (value) => _email = value!.trim(),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Password Field
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: _isObscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu *',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscurePassword = !_isObscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: _validatePassword,
                    onChanged: (_) => setState(() {}), // Refresh chỉ số mật khẩu
                    onSaved: (value) => _password = value!,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_confirmPasswordFocusNode);
                    },
                  ),
                  _buildPasswordStrengthIndicator(),
                  const SizedBox(height: 16),

                  // 4. Confirm Password Field
                  TextFormField(
                    focusNode: _confirmPasswordFocusNode,
                    obscureText: _isObscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Xác nhận mật khẩu *',
                      prefixIcon: const Icon(Icons.lock_reset),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscureConfirmPassword =
                                !_isObscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: _validateConfirmPassword,
                    onSaved: (value) => _confirmPassword = value!,
                    onFieldSubmitted: (_) => _submitForm(),
                  ),
                  const SizedBox(height: 12),

                  // 5. Terms and Conditions Checkbox (Bonus Requirement)
                  FormField<bool>(
                    initialValue: _acceptedTerms,
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptedTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptedTerms = value ?? false;
                                    state.didChange(value);
                                  });
                                },
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _acceptedTerms = !_acceptedTerms;
                                      state.didChange(_acceptedTerms);
                                    });
                                  },
                                  child: const Text(
                                    'Tôi đồng ý với Điều khoản & Điều kiện dịch vụ',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                state.errorText!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // 6. Submit Button
                  ElevatedButton(
                    onPressed: _isCheckingEmail ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isCheckingEmail
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'ĐĂNG KÝ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}