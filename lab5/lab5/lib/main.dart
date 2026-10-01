import 'package:flutter/material.dart';

void main() {
  runApp(const MovieApp());
}

// ==========================================
// 1. DATA MODEL
// ==========================================
class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final double rating;
  final List<String> genres;
  final String overview;
  final List<String> trailers;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.genres,
    required this.overview,
    required this.trailers,
  });
}

// ==========================================
// 2. SAMPLE DATA
// ==========================================
final List<Movie> sampleMovies = [
  Movie(
    id: '1',
    title: 'Dune: Part Two',
    posterUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=800&auto=format&fit=crop',
    rating: 8.6,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    overview:
        'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    trailers: ['Official Trailer #1', 'IMAX Sneak Peek'],
  ),
  Movie(
    id: '2',
    title: 'Deadpool & Wolverine',
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=800&auto=format&fit=crop',
    rating: 8.3,
    genres: ['Action', 'Comedy'],
    overview:
        'The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.',
    trailers: ['Red Band Trailer', 'Behind the Scenes'],
  ),
];

// ==========================================
// 3. MAIN APP WIDGET
// ==========================================
class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Detail App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F6FC),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

// ==========================================
// 4. HOME SCREEN
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movies',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sampleMovies.length,
        itemBuilder: (context, index) {
          final movie = sampleMovies[index];
          return Card(
            elevation: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // Navigation sang màn hình Chi tiết truyền đối tượng Movie
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Hình ảnh Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        movie.posterUrl,
                        width: 100,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(width: 100, height: 70, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Thông tin Phim
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '☆ ${movie.rating} • ${movie.genres.join(', ')}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.black54),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 5. MOVIE DETAIL SCREEN
// ==========================================
class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Poster + Title Overlay
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.network(
                  movie.posterUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 220, color: Colors.grey),
                ),
                // Gradient mờ đen bên dưới chữ
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Genres Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                children: movie.genres.map((genre) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Text(
                      genre,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                movie.overview,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons (Favorite, Rate, Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.black87,
                  label: 'Favorite',
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
                _buildActionButton(
                  icon: Icons.star_border,
                  label: 'Rate',
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: Icons.share,
                  label: 'Share',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Trailers Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Trailers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            // Trailers List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movie.trailers.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.play_circle_fill,
                      size: 32, color: Colors.black87),
                  title: Text(
                    movie.trailers[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    // Xử lý phát trailer nếu cần
                  },
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị nút thao tác
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}