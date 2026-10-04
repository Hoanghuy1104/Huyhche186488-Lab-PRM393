import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

// -----------------------------------------------------------------------------
// 1. DỮ LIỆU VÀ MODEL PHIM
// -----------------------------------------------------------------------------
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// Danh sách phim mẫu
final List<Movie> sampleMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://via.placeholder.com/150/0000FF/808080?text=Inception',
    rating: 8.8,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://via.placeholder.com/150/000000/FFFFFF?text=Dark+Knight',
    rating: 9.0,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Drama', 'Sci-Fi'],
    posterUrl: 'https://via.placeholder.com/150/FF0000/FFFFFF?text=Interstellar',
    rating: 8.6,
  ),
  Movie(
    title: 'Parasite',
    year: 2019,
    genres: ['Drama', 'Comedy'],
    posterUrl: 'https://via.placeholder.com/150/00FF00/000000?text=Parasite',
    rating: 8.5,
  ),
  Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://via.placeholder.com/150/FFFF00/000000?text=Avengers',
    rating: 8.4,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: 'https://via.placeholder.com/150/FF00FF/FFFFFF?text=Hangover',
    rating: 7.7,
  ),
];

// -----------------------------------------------------------------------------
// 2. WIDGET CHÍNH VÀ MÀN HÌNH MẪU
// -----------------------------------------------------------------------------
class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Movie Browsing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // Quản lý trạng thái Tìm kiếm, Thể loại và Sắp xếp
  String searchQuery = '';
  final Set<String> selectedGenres = {};
  String selectedSort = 'A-Z';

  final List<String> availableGenres = ['Action', 'Drama', 'Comedy', 'Sci-Fi'];
  final List<String> sortOptions = ['A-Z', 'Z-A', 'Year', 'Rating'];

  // Hàm xử lý lọc và sắp xếp danh sách phim
  List<Movie> get filteredAndSortedMovies {
    return sampleMovies.where((movie) {
      // 1. Lọc theo tên phim
      final matchesSearch = movie.title.toLowerCase().contains(searchQuery.toLowerCase());

      // 2. Lọc theo thể loại đã chọn
      final matchesGenre = selectedGenres.isEmpty ||
          movie.genres.any((genre) => selectedGenres.contains(genre));

      return matchesSearch && matchesGenre;
    }).toList()
      ..sort((a, b) {
        // 3. Sắp xếp danh sách
        switch (selectedSort) {
          case 'Z-A':
            return b.title.compareTo(a.title);
          case 'Year':
            return b.year.compareTo(a.year); // Mới nhất lên đầu
          case 'Rating':
            return b.rating.compareTo(a.rating); // Điểm cao lên đầu
          case 'A-Z':
          default:
            return a.title.compareTo(b.title);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final displayedMovies = filteredAndSortedMovies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Movie'),
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Ô TÌM KIẾM ---
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search for a movie title...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 12),

              // --- DANH SÁCH THỂ LOẠI (DÙNG WRAP) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Genres:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (selectedGenres.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedGenres.clear();
                        });
                      },
                      child: const Text('Clear filters'),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: availableGenres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedGenres.add(genre);
                        } else {
                          selectedGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // --- THANH SẮP XẾP ---
              Row(
                children: [
                  const Text(
                    'Sort by: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedSort,
                    items: sortOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedSort = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // --- DANH SÁCH PHIM RESPONSIVE ---
              Expanded(
                child: displayedMovies.isEmpty
                    ? const Center(child: Text('No movies found.'))
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // Điểm ngắt (Breakpoint): 800px
                          if (constraints.maxWidth < 800) {
                            // Màn hình nhỏ: Hiển thị 1 cột (ListView)
                            return ListView.builder(
                              itemCount: displayedMovies.length,
                              itemBuilder: (context, index) {
                                return MovieCard(movie: displayedMovies[index]);
                              },
                            );
                          } else {
                            // Màn hình rộng (Tablet/Web): Hiển thị 2 cột (GridView)
                            return GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.8,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: displayedMovies.length,
                              itemBuilder: (context, index) {
                                return MovieCard(movie: displayedMovies[index]);
                              },
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. WIDGET BẢNG HIỂN THỊ PHIM (MOVIE CARD)
// -----------------------------------------------------------------------------
class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Ảnh bìa
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.posterUrl,
                width: 80,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.movie, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Thông tin chi tiết
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('Year: ${movie.year}'),
                  const SizedBox(height: 4),
                  Text('Genres: ${movie.genres.join(", ")}'),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('${movie.rating}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}