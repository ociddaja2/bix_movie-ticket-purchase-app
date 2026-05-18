// import 'package:bixcinema/ui/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:bixcinema/core/models/movie_model.dart';
import 'package:bixcinema/pages/admin/add_movie.dart';
import 'package:bixcinema/pages/admin/movie_detail.dart';

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

final List<MovieModel> demoMovies = [
  MovieModel(
    id: '1',
    judul: 'Avatar Fire And Ash',
    sinopsis: 'Fantasy action about elemental worlds.',
    genre: ['action-adventure', 'fantasy film'],
    durasi: '3j 17m',
    format: '2D',
    rating: '13+',
    status: true,
    jam: ['12:00', '15:30'],
    posterUrl:
        'https://upload.wikimedia.org/wikipedia/en/9/95/Avatar_Fire_and_Ash_poster.jpeg',
  ),
  MovieModel(
    id: '2',
    judul: 'The Spongebob Movie',
    sinopsis: 'A fun undersea adventure with SpongeBob and friends.',
    genre: ['action-adventure', 'fantasy', 'animation'],
    durasi: '1j 38m',
    format: '2D',
    rating: '8+',
    status: true,
    jam: ['11:00', '14:00'],
    posterUrl:
        'https://upload.wikimedia.org/wikipedia/en/1/19/The_SpongeBob_Movie_Search_for_SquarePants_Poster.jpg',
  ),
  MovieModel(
    id: '3',
    judul: 'Zootopia 2',
    sinopsis: 'A new mystery unfolds in the animal metropolis.',
    genre: ['investigation', 'comedy'],
    durasi: '1j 47m',
    format: '2D',
    rating: '8+',
    status: true,
    jam: ['13:20', '16:45'],
    posterUrl:
        'https://upload.wikimedia.org/wikipedia/en/6/6a/Zootopia_2_%282025_film%29.jpg',
  ),
];

// ─── Home Screen ──────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
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
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
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
      bottomNavigationBar: const _LogoutNavbar(),
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
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1E3A8A), 
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ), // deep blue
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/images/BIX_Cinema_menyamping(1).png',
            height: 25,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

// ─── Navbar ──────────────────────────────────────────────────────────────────

class _LogoutNavbar extends StatelessWidget {
  const _LogoutNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
       
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                // Ganti dengan logika logout kamu
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.logout,
                color: Color(0xFFDC2626),
                size: 20,
              ),
              label: const Text(
                'Log out',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
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
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'caveat',
                ),
              ),
              TextSpan(
                text: 'admin',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMoviePage()),
          );
        },
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
          // List of movies
          ...demoMovies.map(
            (movie) => Padding(
              //ini yang ku tambah
              padding: const EdgeInsets.only(bottom: 12),
              child: _MovieCard(movie: movie),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Movie Card ───────────────────────────────────────────────────────────────

class _MovieCard extends StatelessWidget {
  final MovieModel movie;
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
              movie.posterUrl,
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
                          movie.judul,
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MovieDetailPage(movie: movie),
                            ),
                          );
                        },
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
                    movie.genre.join(', '),
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Badge row
                  Row(
                    children: [
                      _Badge(
                        label: movie.durasi,
                        color: const Color(0xFF3B5BDB),
                      ),
                      const SizedBox(width: 6),
                      _Badge(
                        label: movie.rating,
                        color: const Color(0xFF3B5BDB),
                      ),
                      const SizedBox(width: 6),
                      _Badge(
                        label: movie.format,
                        color: const Color(0xFF3B5BDB),
                      ),
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
