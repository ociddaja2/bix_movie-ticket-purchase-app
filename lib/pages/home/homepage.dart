import 'package:bixcinema/core/app/route.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bixcinema/ui/widgets/backgroundLoginWidget.dart';
import 'package:bixcinema/core/models/movie_model.dart';
import 'package:go_router/go_router.dart';
import 'package:bixcinema/core/repo/movie_repo.dart';
import 'package:bixcinema/ui/widgets/loading_screen.dart';
import 'package:bixcinema/ui/widgets/appbar.dart';
import 'package:bixcinema/core/models/tayang_model.dart';
import 'package:bixcinema/core/repo/tayang_repo.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MovieRepository();// Contoh ID film, bisa diganti sesuai kebutuhan

    return FutureBuilder(
      // Fetch keduanya sekaligus secara paralel
      future: Future.wait([repo.fetchNowShowing(), repo.fetchComingSoon()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Stack(
            children: [
              _buildContent(context, [], []), // atau Scaffold transparan
              const Scaffold(
              backgroundColor: Colors.transparent,
              body: BixLoadingScreen(),
      ),
    ],
  );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        // Hasil fetch
        final data = snapshot.data as List<List<MovieModel>>;
        final nowShowing = data[0];
        final comingSoon = data[1];

        return _buildContent(context, nowShowing, comingSoon);
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<MovieModel> nowShowing,
    List<MovieModel> comingSoon,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Stack(
            children: [
              const DecorativeCirclesBackground(),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildWelcome(),
                    const SizedBox(height: 10),
                    _buildCarousel(),
                    const SizedBox(height: 15),

                    // Sedang Tayang
                    _buildSectionHeader(context, 'Sedang Tayang'),
                    const SizedBox(height: 16),
                    _buildMovieList(context, nowShowing, 250),

                    const Divider(),

                    // Coming Soon
                    _buildSectionHeader(context, 'Coming Soon'),
                    const SizedBox(height: 16),
                    _buildMovieList(context, comingSoon, 200),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieList(
    BuildContext context,
    List<MovieModel> movies,
    double cardHeight,
  ) {
    if (movies.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Tidak ada film tersedia.',
          style: TextStyle(color: Color.fromARGB(255, 199, 0, 0)),
        ),
      );
    }

    return SizedBox(
      height: cardHeight + 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _buildMovieCard(context, movie, cardHeight);
        },
      ),
    );
  }

  Widget _buildMovieCard(
    BuildContext context,
    MovieModel movie,
    double height,
  ) {
    return GestureDetector(
      onTap: () async { 
        // Ambil tayang berdasarkan movieId
        try {
          final tayangList = await TayangRepository().fetchTayangByMovieId(movie.id);
          if (tayangList.isNotEmpty) {
            if (context.mounted) {
              context.push('${AppRoutes.movieDetail}?id=${movie.id}', extra: MovieDetailParams(movie: movie, tayang: tayangList.first
              ));
            }
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error fetching showtimes: $e')),
              );
            }
          }
        },
          // =>
          // context.push('${AppRoutes.movieDetail}?id=${movie.id}', extra: movie),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Poster dari URL, fallback ke asset lokal
                  // movie.posterUrl.isNotEmpty ?
                  Image.network(
                    movie.posterUrl,
                    height: height,
                    width: 140,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: height,
                        width: 140,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (_, __, ___) => _posterFallback(height),
                  ),
                  // : _posterFallback(height),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _posterFallback(double height) {
    return Container(
      height: height,
      width: 140,
      color: Colors.grey[300],
      child: const Icon(Icons.movie, color: Colors.grey, size: 40),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return const AppBarWidget(title: 'BIX Cinema');
  }

  Widget _buildWelcome() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi User, welcome to BIX Cinema!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore the latest movies and shows now.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      items: List.generate(2, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(
                'lib/assets/images/banners/banner${(index % 4) + 2}.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        );
      }),
      options: CarouselOptions(
        aspectRatio: 4.5,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            status,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: () {
              if (status == 'Sedang Tayang') {
                context.go('/sedang-tayang');
              } else if (status == 'Coming Soon') {
                context.go('coming-soon');
              }
            },
            child: const Text('Lihat Semua'),
          ),
        ],
      ),
    );
  }
}
