import 'package:bixcinema/core/app/route.dart';
import 'package:bixcinema/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bixcinema/ui/widgets/backgroundLoginWidget.dart';
import 'package:bixcinema/core/models/movie_model.dart';
import 'package:go_router/go_router.dart';
import 'package:bixcinema/core/repo/movie_repo.dart';
import 'package:bixcinema/ui/widgets/loading_screen.dart';
import 'package:bixcinema/core/repo/tayang_repo.dart';
import 'package:bixcinema/ui/widgets/appbar_2.dart';
import 'package:bixcinema/core/providers/city_teater_provider.dart';
import 'package:provider/provider.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {

    final currentUser = FirebaseAuth.instance.currentUser;

     if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('User not authenticated. Please log in.'),
        ),
      );
    }

    return Consumer<CityTeaterProvider>(
      builder: (context, cityTeaterProvider, _) {
        final selectedTeaterId = cityTeaterProvider.selectedTeaterId;

        print('Homepage Build Ulang - Selected Teater ID: $selectedTeaterId');

        if (selectedTeaterId == null) {
          print('No teater selected yet, initializing provider...');
          cityTeaterProvider.initialize();
          return Scaffold(
            body: Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading teater...'),
                ],
              ),
            ),
          );
          
        }



    return FutureBuilder(
      // Fetch keduanya sekaligus secara paralel
      // future: Future.wait([repo.fetchNowShowing(), repo.fetchComingSoon()]),
      future: _fetchFilmsForSelectedTeater(context, selectedTeaterId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Stack(
            children: [
              _buildContent(context, cityTeaterProvider,[], []), // atau Scaffold transparan
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

        return _buildContent(context, cityTeaterProvider,nowShowing, comingSoon);
          },
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    CityTeaterProvider cityTeaterProvider,
    List<MovieModel> nowShowing,
    List<MovieModel> comingSoon,
  ) {
    final selectedTeaterId = cityTeaterProvider.selectedTeaterId ?? '';

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context, cityTeaterProvider),
        body: SafeArea(
          child: Stack(
            children: [
              const DecorativeCirclesBackground(),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildWelcome(), // Ganti dengan data user sebenarnya
                    const SizedBox(height: 10),
                    _buildCarousel(),
                    const SizedBox(height: 15),

                    // Sedang Tayang
                    _buildSectionHeader(context, 'Sedang Tayang'),
                    const SizedBox(height: 16),
                    _buildMovieList(context, nowShowing, 250, selectedTeaterId),

                    const Divider(),

                    // Coming Soon
                    _buildSectionHeader(context, 'Coming Soon'),
                    const SizedBox(height: 16),
                    _buildMovieList(context, comingSoon, 200, selectedTeaterId),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildMovieList(
    BuildContext context,
    List<MovieModel> movies,
    double cardHeight,
    String selectedTeaterId,
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
          return _buildMovieCard(context, movie, cardHeight, selectedTeaterId);
        },
      ),
    );
  }

  Widget _buildMovieCard(
    BuildContext context,
    MovieModel movie,
    double height,
    String selectedTeaterId,
  ) {
    return GestureDetector(
      onTap: () async { 
        // Ambil tayang berdasarkan movieId
        try {
          final tayangList = await TayangRepository()
            .fetchTayangByMovieAndTeater(movie.id, selectedTeaterId);

          if (tayangList.isNotEmpty) {
            if (context.mounted) {
              context.push('${AppRoutes.movieDetail}?id=${movie.id}',
              extra: MovieDetailParams(
                movie: movie,
                tayang: tayangList.first
                )
              );
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Showtimes not available for this movie')),
              );
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
                    errorBuilder: (_, _, _) => _posterFallback(height),
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

  PreferredSizeWidget _buildAppBar(BuildContext context, CityTeaterProvider cityTeaterProvider) {
    final locationName = cityTeaterProvider.selectedCity ?? 'Pilih Lokasi';

    print('Appbar location: $locationName');

    return BixAppBar.home(
      location: locationName,
      onLocationTap: () => context.push('/location'),
    );
  }

  Widget _buildWelcome() {

    final user = UserModel.fromFirebaseUser(FirebaseAuth.instance.currentUser!);
    final userName = user?.name.trim().isNotEmpty == true
        ? user!.displayName!
        : 'Pengguna';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi $userName, Selamat Datang di BIX Cinema!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Nikmati pengalaman menonton film terbaik di kota Anda.',
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
                context.push('/sedang-tayang');
              } else if (status == 'Coming Soon') {
                context.push('/coming-soon');
              }
            },
            child: const Text('Lihat Semua'),
          ),
        ],
      ),
    );
  }
  
  Future<List<List<MovieModel>>> _fetchFilmsForSelectedTeater(BuildContext context, String selectedTeaterId,) async {
  // 1. Ambil teater yang dipilih
  final movieRepo = MovieRepository();
    final tayangRepo = TayangRepository();

    try {
      print('Fetching films for teater: $selectedTeaterId');

      final tayangList = await tayangRepo.fetchTayangByTeater(selectedTeaterId);
      print('Found ${tayangList.length} tayang');

      final movieIds = tayangList
          .expand((t) => t.movieId)
          .toSet()
          .toList();

      print('Found ${movieIds.length} movies');

      if (movieIds.isEmpty) {
        print('Tidak ada film di teater ini');
        return [[], []];
      }

      final allMovies = await movieRepo.fetchMoviesById(movieIds);
      print('Fetched ${allMovies.length} movie details');

      final nowShowing = allMovies.where((m) => m.status == true).toList();
      final comingSoon = allMovies.where((m) => m.status == false).toList();

      print('Now showing: ${nowShowing.length}, Coming soon: ${comingSoon.length}');

      return [nowShowing, comingSoon];
    } catch (e) {
      print('Error fetching films: $e');
      return [[], []];
  }
}
}
