// ignore_for_file: avoid_print

import 'package:bixcinema/core/app/route.dart';
import 'package:bixcinema/ui/widgets/appbar_2.dart';
import 'package:bixcinema/ui/widgets/decorativebackground.dart';
import 'package:bixcinema/ui/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bixcinema/core/models/movie_model.dart';
import 'package:bixcinema/core/repo/movie_repo.dart';
import 'package:bixcinema/core/repo/tayang_repo.dart';
import 'package:bixcinema/core/providers/city_teater_provider.dart';

class SedangTayangPage extends StatefulWidget {
  const SedangTayangPage({super.key});

  @override
  State<SedangTayangPage> createState() => _SedangTayangPageState();
}

class _SedangTayangPageState extends State<SedangTayangPage> {
  late Future<List<MovieModel>> futureMovies;
  final MovieRepository _movieRepo = MovieRepository();
  final TayangRepository _tayangRepo = TayangRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CityTeaterProvider>(
      builder: (context, cityTeaterProvider, _) {
        final selectedTeaterId = cityTeaterProvider.selectedTeaterId;

        if (selectedTeaterId == null) {
          return Scaffold(
            appBar: BixAppBar.subtitle(
              title: 'Sedang Tayang',
              subtitle: 'Film Yang Sedang Tayang',
              onBack: () => context.go('/home'),
              ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // fetch film berdasarkan teater yang dipilih
        futureMovies = _fetchNowShowingForTeater(selectedTeaterId);

        return Scaffold(
          appBar: BixAppBar.subtitle(
              title: 'Coming Soon',
              subtitle: 'Film Yang Sedang Tayang',
              onBack: () => context.go('/home'),
              ),
          backgroundColor: Colors.white,
          bottomNavigationBar: const Navbar(currentIndex: 0),
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

              return SafeArea(
                child: Stack(
                  children: [ const DecorativeCirclesBackground(),
                    Padding(
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
                        return MovieCard(
                          movie: movies[index],
                          selectedTeaterId: selectedTeaterId,
                        );
                      },
                    ),
                  ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Filter film now showing berdasarkan teater
  Future<List<MovieModel>> _fetchNowShowingForTeater(String selectedTeaterId) async {
    try {
      // 1. Ambil semua tayang di teater ini
      final tayangList = await _tayangRepo.fetchTayangByTeater(selectedTeaterId);

      // 2. Extract movieId
      final movieId = tayangList
          .expand((t) => t.movieId)
          .toSet()
          .toList();

      if (movieId.isEmpty) return [];

      // 3. Fetch semua film
      final allMovies = await _movieRepo.fetchMoviesById(movieId);

      // 4. Filter hanya yang status = true (now showing)
      return allMovies.where((m) => m.status == true).toList();
    } catch (e) {
      print('Error fetching now showing: $e');
      return [];
    }
  }
}

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final String selectedTeaterId;

  const MovieCard({
    super.key,
    required this.movie,
    required this.selectedTeaterId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //  Ambil tayang untuk teater & film ini
        try {
          final tayangList = await TayangRepository()
              .fetchTayangByMovieAndTeater(movie.id, selectedTeaterId);

          if (tayangList.isNotEmpty && context.mounted) {
            context.push('${AppRoutes.movieDetail}?id=${movie.id}',
              extra: MovieDetailParams(
                movie: movie,
                tayang: tayangList.first,
              ),
            );
          }
        } catch (e) {
          print('Error: $e');
        }
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