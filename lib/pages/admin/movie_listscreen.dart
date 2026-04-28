import 'package:flutter/material.dart';
import 'package:bixcinema/core/models/movie_model.dart';

void main() {
  runApp(const BixCinemaApp());
}

class BixCinemaApp extends StatelessWidget {
  const BixCinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BIX Cinema',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Georgia',
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B5BDB),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ─── Data Model ───────────────────────────────────────────────────────────────

final List<Movie> demoMovies = [
  Movie(
    title: 'Avatar Fire And Ash',
    genres: 'action-adventure, fantasy film',
    duration: '3j 17m',
    ageRating: '13+',
    format: '2D',
    posterAsset:
        'https://image.tmdb.org/t/p/w200/tElnmtQ6yz1PjN1kePNl8yMSb59.jpg',
  ),
  Movie(
    title: 'The Spongebob Movie',
    genres: 'action-adventure, fantasy, Animation',
    duration: '1j 38m',
    ageRating: '8+',
    format: '2D',
    posterAsset:
        'https://image.tmdb.org/t/p/w200/jtnfNzqZwN4E32FGGxx1YZaBWWf.jpg',
  ),
  Movie(
    title: 'Zootopia 2',
    genres: 'Investigation, Comedy',
    duration: '1j 47m',
    ageRating: '8+',
    format: '2D',
    posterAsset:
        'https://image.tmdb.org/t/p/w200/6Co7wSMOQB0nF5ZGxaAbCFo2r7b.jpg',
  ),
];

// ─── Home Screen ──────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: Column(
        children: [
          // ── Top navy header bar ──────────────────────────────────────────
          _TopBar(),

          // ── Scrollable body ──────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting row
                  _GreetingRow(),
                  const SizedBox(height: 8),
                  const Text(
                    'Mau nambah film baru apa lagi nih ?',
                    style: TextStyle(
                      color: Color(0xFFB0B8C8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Tambah Film button
                  _TambahFilmButton(),
                  const SizedBox(height: 24),

                  // Daftar Film card
                  _DaftarFilmCard(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 16,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1E3A8A), // deep blue
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'BIX ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                TextSpan(
                  text: 'cinema',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Greeting Row ─────────────────────────────────────────────────────────────

class _GreetingRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Hallo, ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.logout, color: Color(0xFF60A5FA), size: 18),
          label: const Text(
            'Log out',
            style: TextStyle(color: Color(0xFF60A5FA), fontSize: 13),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

// ─── Tambah Film Button ───────────────────────────────────────────────────────

class _TambahFilmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white, size: 22),
        label: const Text(
          'Tambah Film',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B5BDB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: const Color(0xFF3B5BDB).withOpacity(0.5),
        ),
      ),
    );
  }
}

// ─── Daftar Film Card ─────────────────────────────────────────────────────────

class _DaftarFilmCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2D4DB5),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          const Text(
            'Daftar Film',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          ...demoMovies
              .map((movie) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MovieCard(movie: movie),
                  ))
              .toList(),
        ],
      ),
    );
  }
}

// ─── Movie Card ───────────────────────────────────────────────────────────────

class _MovieCard extends StatelessWidget {
  final Movie movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: Image.network(
              movie.posterAsset,
              width: 72,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 100,
                color: const Color(0xFF374151),
                child: const Icon(Icons.movie, color: Colors.white54),
              ),
            ),
          ),

          // Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Detail button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: const [
                            Text(
                              'Detail',
                              style: TextStyle(
                                color: Color(0xFF3B5BDB),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Color(0xFF3B5BDB),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Genres
                  Text(
                    movie.genres,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Badge row
                  Row(
                    children: [
                      _Badge(label: movie.duration, color: const Color(0xFF3B5BDB)),
                      const SizedBox(width: 6),
                      _Badge(label: movie.ageRating, color: const Color(0xFF3B5BDB)),
                      const SizedBox(width: 6),
                      _Badge(label: movie.format, color: const Color(0xFF3B5BDB)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Badge ────────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}