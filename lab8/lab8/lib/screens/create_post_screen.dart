import 'package:flutter/material.dart';
import '../service/api_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final newPost = await _apiService.createPost(
          _titleController.text,
          _bodyController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tạo bài viết thành công (ID: ${newPost.id})')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thất bại: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo Bài Viết Mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
                validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Nội dung'),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập nội dung' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitData,
                      child: const Text('Gửi POST Request'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}