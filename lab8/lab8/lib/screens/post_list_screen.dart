import 'package:flutter/material.dart';
import '../models/post.dart';
import '../service/api_service.dart';
import 'create_post_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    setState(() {
      _postsFuture = _apiService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Posts List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPosts,
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // 1. Trạng thái Đang Tải (Loading State)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Trạng thái Gặp Lỗi (Error State)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 12),
                    Text(
                      'Đã xảy ra lỗi!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadPosts,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Trạng thái Thành Công (Data State)
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final posts = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async => _loadPosts(),
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${post.id}'),
                      ),
                      title: Text(
                        post.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        // Tùy chọn: Hiển thị chi tiết bài viết
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(post.title),
                            content: Text(post.body),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Đóng'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Không có dữ liệu'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
          if (result == true) {
            _loadPosts(); // Làm mới lại danh sách sau khi đăng bài thành công
          }
        },
      ),
    );
  }
}