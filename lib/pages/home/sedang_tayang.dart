import 'package:bixcinema/ui/widgets/appbar_2.dart';
import 'package:bixcinema/ui/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bixcinema/core/models/movie_model.dart';
import 'package:bixcinema/core/repo/movie_repo.dart';


class SedangTayangPage extends StatefulWidget {
  const SedangTayangPage({super.key});

  @override
  State<SedangTayangPage> createState() => _SedangTayangPageState();
}

class _SedangTayangPageState extends State<SedangTayangPage> {
  late Future<List<MovieModel>> futureMovies;
  final MovieRepository _movieRepo = MovieRepository();

  @override
  void initState() {
    super.initState();
    // Fetch film yang sedang tayang (status: true)
    futureMovies = _movieRepo.fetchNowShowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BixAppBar.subtitle(title: 'Sedang Tayang', subtitle: 'Film Yang Sedang Tayang'),
      bottomNavigationBar: Navbar(currentIndex: 0),
      body: FutureBuilder<List<MovieModel>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final movies = snapshot.data ?? [];
          
          if (movies.isEmpty) {
            return const Center(child: Text('No movies available'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: GridView.builder(
              itemCount: movies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                return MovieCard(movie: movies[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final MovieModel movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate ke detail film atau jadwal tayang
        print('Movie tapped: ${movie.judul}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.movie, size: 48, color: Colors.grey),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.judul,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}