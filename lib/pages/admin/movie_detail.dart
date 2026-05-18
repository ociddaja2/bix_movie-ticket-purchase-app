import 'package:bixcinema/core/models/movie_model.dart';
import 'package:bixcinema/pages/admin/edit_movie.dart';
import 'package:flutter/material.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailPage({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  int selectedDateIndex = 0;
  int? selectedCinemaIndex;
  String? selectedShowtime;
  bool _synopsisExpanded = false;

  final List<DateTime> demoDates = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 1)),
    DateTime.now().add(const Duration(days: 2)),
  ];

  final List<Map<String, Object>> demoCinemas = [
    {
      'name': 'CGV Tunjungan Plaza',
      'price': 45000,
      'location': 'Surabaya',
    },
    {
      'name': 'XXI Grand City',
      'price': 52000,
      'location': 'Surabaya',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(),
                    _buildMovieInfo(),
                    const Divider(thickness: 8, color: Color(0x00000000)),
                    _buildSynopsis(),
                    const Divider(thickness: 8, color: Color(0x00000000)),
                    if (widget.movie.status) ...[
                      _buildDateSelector(),
                      const Divider(thickness: 8, color: Color(0x00000000)),
                      _buildCinemaSection(),
                    ] else ...[
                      _buildComingSoon(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.black87,
          child: Image.network(
            widget.movie.posterUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _posterFallback(),
          ),
        ),
        Container(width: double.infinity, height: 200, color: Colors.black54),
        Positioned(
          top: 12,
          left: 12,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 15, 0, 111),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditMoviePage(movie: widget.movie),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 15, 0, 111),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _posterFallback() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Icon(Icons.movie, color: Colors.white54, size: 60),
      ),
    );
  }

  Widget _buildMovieInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              widget.movie.posterUrl,
              width: 64,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _thumbnailFallback(),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.judul,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.movie.genre.join(', '),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildTag(widget.movie.durasi),
                    _buildTag(widget.movie.rating),
                    _buildTag(widget.movie.format),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumbnailFallback() {
    return Container(
      width: 64,
      height: 90,
      color: Colors.grey[300],
      child: const Icon(Icons.movie, color: Colors.grey),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 2, 31, 127)),
        borderRadius: BorderRadius.circular(4),
        color: const Color.fromARGB(255, 2, 31, 127),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  Widget _buildSynopsis() {
    const int maxChars = 120;
    final sinopsis = widget.movie.sinopsis;
    final isLong = sinopsis.length > maxChars;
    final displayText = (!_synopsisExpanded && isLong)
        ? '${sinopsis.substring(0, maxChars)}...'
        : sinopsis;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sinopsis',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                height: 1.5,
              ),
              children: [
                TextSpan(text: displayText),
                if (isLong)
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => setState(
                        () => _synopsisExpanded = !_synopsisExpanded,
                      ),
                      child: Text(
                        _synopsisExpanded ? ' Sembunyikan' : ' Lihat Selengkapnya',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1A73E8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    if (!widget.movie.status) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tayang',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(demoDates.length, (index) {
                final tanggal = demoDates[index];
                final dayName = _getDayName(tanggal.weekday);
                final dayNumber = tanggal.day.toString();
                final isSelected = selectedDateIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDateIndex = index;
                        selectedCinemaIndex = null;
                        selectedShowtime = null;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? const Color(0xFF003478) : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF003478) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF003478) : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              dayNumber,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCinemaSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bioskop',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(height: 14),
          Column(
            children: List.generate(demoCinemas.length, (cinemaIndex) {
              final cinema = demoCinemas[cinemaIndex];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCinemaCard(
                  cinemaIndex,
                  cinema['name'] as String,
                  cinema['price'] as int,
                  cinema['location'] as String,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCinemaCard(int cinemaIndex, String name, int price, String location) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Color.fromARGB(255, 0, 0, 94),
                size: 20,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.movie.format,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
                Text(
                  'Rp${_formatHarga(price)}',
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: widget.movie.jam.map((time) {
              final isSelected = selectedShowtime == time && selectedCinemaIndex == cinemaIndex;
              return GestureDetector(
                onTap: () => setState(() {
                  selectedCinemaIndex = cinemaIndex;
                  selectedShowtime = time;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? const Color.fromARGB(255, 0, 47, 108)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    color: isSelected ? const Color(0xFFE8F0FE) : Colors.white,
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? const Color.fromARGB(255, 1, 48, 110)
                          : Colors.black54,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoon() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFBDBDBD),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Film akan segera tayang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Setelah tayang, kembali lagi untuk melihat jadwal dan beli tiketnya ✨',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[weekday - 1];
  }

  String _formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+)'),
      (m) => '${m[1]}',
    );
  }
}
