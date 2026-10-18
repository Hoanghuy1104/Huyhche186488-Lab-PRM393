import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client client;

  // Hỗ trợ Dependency Injection cho việc Test
  ApiService({http.Client? client}) : client = client ?? http.Client();

  // Lab 8.1 & 8.2: Hàm lấy danh sách Bài viết (GET Request)
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await client
          .get(Uri.parse('$baseUrl/posts'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi máy chủ: Mã trạng thái ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể tải dữ liệu: $e');
    }
  }

  // Optional: Hàm tạo mới Bài viết (POST Request)
  Future<Post> createPost(String title, String body) async {
    final response = await client.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Tạo bài viết mới thất bại');
    }
  }
}