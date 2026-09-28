import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  final List<String> movies = const [
    'Avatar',
    'Inception',
    'Interstellar',
    'Joker',
    'Avengers: Endgame',
    'The Dark Knight'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 – Layout Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding chuẩn 16px
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Now Playing',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16), // SizedBox tạo khoảng cách 16px
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0), // Khoảng cách giữa các item 12px
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(movie[0]), // Lấy chữ cái đầu làm Avatar
                        ),
                        title: Text(movie),
                        subtitle: const Text('Sample description'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}