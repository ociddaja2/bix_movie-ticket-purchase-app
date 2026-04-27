import 'package:bixcinema/core/models/movie_model.dart';
import 'package:bixcinema/core/models/tayang_model.dart';
// import 'package:bixcinema/core/repo/tayang_repo.dart';
// import 'package:bixcinema/core/models/teater_model.dart';
import 'package:flutter/material.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieModel movie;
  final TayangModel tayang;
  final String id;

  const MovieDetailPage({
    super.key, 
    required this.movie,
    required this.tayang,
    required this.id
    });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  int selectedDateIndex = 0;
  String? selectedShowtime;
  bool _synopsisExpanded = false;

  late Future<List<TayangModel>> _tayangFuture;
  

  @override
  void initState() {
    super.initState();
    // _tayangFuture = TayangRepository().fetchTayangByMovieId(widget.id);
    _tayangFuture = Future.value([widget.tayang]);
  }

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
                  const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                  _buildSynopsis(),
                  const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
  
                  if (widget.movie.status) ...[
                    _buildDateSelector(),
                    const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                    _buildCinemaSection(),
                  ] else ...[
                    // Coming Soon
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFFB74D)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFFF57C00),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Film ini akan segera tayang',
                                style: TextStyle(
                                  color: const Color(0xFFF57C00),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (widget.movie.status) _buildBuyButton(),
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
          child: widget.movie.posterUrl != null
              ? Image.network(
                  widget.movie.posterUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _posterFallback(),
                )
              : _posterFallback(),
        ),
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.black
        ),
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
              child: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 255, 255, 255), size: 20),
            ),
          ),
        ),
        // Tampilkan tombol play hanya jika ada trailerUrl
        if (widget.movie.trailerUrl != null)
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: navigasi ke halaman trailer
                  
                },
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(onPressed: () {
                    // Navigasi ke halaman trailer, passing URL trailer
                  }, icon: Icon(Icons.play_arrow, color: Colors.black87, size: 32))
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

  // poster kecil, Judul, genre, durasi, rating, format
  Widget _buildMovieInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: widget.movie.posterUrl != null
                ? Image.network(
                    widget.movie.posterUrl!,
                    width: 64,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _thumbnailFallback(),
                  )
                : _thumbnailFallback(),
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
                  style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400),
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
        color: Color.fromARGB(255, 2, 31, 127),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  // Sinopsis
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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


  // pilih hari nonton
  Widget _buildDateSelector() {
    // status cek
    if (!widget.movie.status) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<List<TayangModel>>(
    future: _tayangFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text('Tidak ada jadwal tayang');
      }

      final tayangList = snapshot.data!;
      
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tayang',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  tayangList.first.tanggal.length,
                  (index) {
                    final tanggal = tayangList.first.tanggal[index];
                    final dayName = _getDayName(tanggal.weekday);
                    final dayNumber = tanggal.day.toString();
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDateIndex = index;
                            selectedShowtime = null;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              dayName,
                              style: TextStyle(
                                fontSize: 12,
                                color: selectedDateIndex == index
                                    ? const Color.fromARGB(255, 0, 52, 120)
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: selectedDateIndex == index
                                    ? const Color.fromARGB(255, 0, 52, 120)
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selectedDateIndex == index
                                      ? const Color.fromARGB(255, 0, 52, 120)
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  dayNumber,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: selectedDateIndex == index
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
  
  }
   String _getDayName(int weekday) {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return days[weekday - 1];
  }

  // pilih jam nonton
  Widget _buildCinemaSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   children: const [
          //     Icon(Icons.location_on_outlined, color: Colors.black54, size: 20),
          //     SizedBox(width: 6),
          //   ],
          // ),
          // // Nama teater dari model
          Row(
            children: [
              // Icon Location
              const Icon(Icons.location_on_outlined, color: Color.fromARGB(255, 0, 0, 94), size: 20),
              
              const SizedBox(width: 6),
              Text(
                // widget.movie.teater,
                '${widget.tayang.namaTeater.namaTeater}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
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
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  'Rp${_formatHarga(widget.tayang.harga)}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: widget.movie.jam.map((time) {
              final isSelected = selectedShowtime == time;
              // showtimes.map((time) {
              return GestureDetector(
                onTap: () => setState(() => selectedShowtime = time),
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
                      color: isSelected ? const Color.fromARGB(255, 1, 48, 110) : Colors.black54,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  String _formatHarga(int harga) {
    // Format angka dengan titik ribuan: 50000 → 50.000
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]}.',
    );
  }

  // Tombol beli tiket
  Widget _buildBuyButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: ElevatedButton(
        onPressed: selectedShowtime != null ? () {} : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 46, 107),
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Beli Tiket',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}