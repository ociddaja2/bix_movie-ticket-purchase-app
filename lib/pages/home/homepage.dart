import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bixcinema/ui/widgets/backgroundLoginWidget.dart';
import 'package:bixcinema/core/models/movie_model.dart';
import 'package:go_router/go_router.dart';
import 'package:bixcinema/core/repo/movie_repo.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MovieRepository();
    
    return FutureBuilder(
      // Fetch keduanya sekaligus secara paralel
      future: Future.wait([
        repo.fetchNowShowing(),
        repo.fetchComingSoon(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
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
        child: Text('Tidak ada film tersedia.', style: TextStyle(color: Color.fromARGB(255, 199, 0, 0))),
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

  Widget _buildMovieCard(BuildContext context, MovieModel movie, double height) {
    return GestureDetector(
      onTap: () => context.push('/movie-detail/${movie.id}', extra: movie),
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
                  movie.posterUrl != null && movie.posterUrl.isNotEmpty
                      ? Image.network(
                          movie.posterUrl,
                          height: height,
                          width: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _posterFallback(height),
                        )
                      : _posterFallback(height),
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
    return AppBar(
              elevation: 0,
              backgroundColor: const Color.fromARGB(255, 5, 53, 125),
              automaticallyImplyLeading: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              flexibleSpace: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('lib/assets/images/icons/iconbix3.png'),
                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () => context.push('/location'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text('Banjarbaru', style: TextStyle(color: Colors.white, fontSize: 14)),
                                ],
                              ),
                              Icon(Icons.keyboard_arrow_down, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              toolbarHeight: 120,
    );
  }

  Widget _buildWelcome() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi User, welcome to BIX Cinema!',
          style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Explore the latest movies and shows now.',
          style: TextStyle(
          fontSize: 14,
          color: Colors.black54,
            ),
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
                context.push('/now-showing');
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
}