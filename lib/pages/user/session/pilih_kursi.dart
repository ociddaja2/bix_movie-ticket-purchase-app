// lib/pages/user/session/pilih_kursi.dart

import 'package:bixcinema/pages/user/session/pembayaran.dart';
import 'package:bixcinema/ui/widgets/appbar_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bixcinema/core/models/movie_model.dart';
import 'package:bixcinema/core/models/tayang_model.dart';
import 'package:bixcinema/core/repo/kursi_repo.dart';

import '../../../core/repo/pembayaran_repo.dart';

class PilihKursiPage extends StatelessWidget {
  final MovieModel movie;
  final TayangModel tayang;
  final DateTime selectedDate;
  final String selectedTime;

  const PilihKursiPage({
    super.key,
    required this.movie,
    required this.tayang,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return SeatBookingScreen(
      movie: movie,
      tayang: tayang,
      selectedDate: selectedDate,
      selectedTime: selectedTime,
    );
  }
}

enum SeatStatus { tersedia, dipilih, terisi }

// ✅ PERBAIKAN: Seat dengan row dan number
class Seat {
  final String row;
  final int number;
  SeatStatus status;

  Seat({
    required this.row,
    required this.number,
    this.status = SeatStatus.tersedia,
  });

  // Identifier unik untuk seat
  String get id => '${row}_$number';
}

class SeatBookingScreen extends StatefulWidget {
  final MovieModel movie;
  final TayangModel tayang;
  final DateTime selectedDate;
  final String selectedTime;

  const SeatBookingScreen({
    super.key,
    required this.movie,
    required this.tayang,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<SeatBookingScreen> createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  // static const int pricePerSeat = 50000; // contoh harga per kursi

  final List<String> rowLabels = ['J', 'H', 'G', 'F', 'E', 'D', 'C', 'B', 'A'];

  // row label


  final int seatsPerRow = 4; // 4 kiri + 4 kanan

  late Map<String, Seat> kursi; // Key: "row_number"
  late Future<Set<String>> _bookedSeatsFuture;

  @override
  void initState() {
    super.initState();
    kursi = {};
    _initSeatsDefault({});

    _bookedSeatsFuture = _fetchBookedSeats();
  }

  // ✅ Fetch kursi booked berdasarkan tayangId, movieId, tanggal, dan jam
  Future<Set<String>> _fetchBookedSeats() async {
    try {
      final movieId = widget.movie.id;
      // Format tanggal: yyyy-MM-dd
      final tanggalStr = '${widget.selectedDate.year.toString().padLeft(4, '0')}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}';
      
      final bookedSeat = await KursiRepository()
          .fetchBookedSeatsByTayangId(
            widget.tayang.tayangId,
            movieId,
            tanggalStr,            // ✅ Pass tanggal sebagai string
            widget.selectedTime,  // ✅ Pass selectedTime sebagai jam
          );
      
      // _initSeats(bookedSeat);
      setState(() {
        for (var id in bookedSeat) {
          if (kursi.containsKey(id)) {
            kursi[id]!.status = SeatStatus.terisi;
          }
        }
      });

      return bookedSeat;
    } catch (e) {
      print('Error fetching booked seats: $e');
      return {};
    }
  }

  void _initSeatsDefault(Set<String> bookedSeats) {
    kursi = {};
    for (final row in rowLabels) {
      for (int number = 1; number <= 8; number++) {
        final id = '${row}_$number';
        kursi[id] = Seat(
          row: row,
          number: number,
          status: 
          // bookedSeats.contains(kursiId)
          //     ? SeatStatus.terisi :
               SeatStatus.tersedia,
        );
      }
    }
  }


  List<Seat> get selectedSeats =>
      kursi.values.where((k) => k.status == SeatStatus.dipilih).toList();

  int get totalPrice => selectedSeats.length * widget.tayang.harga; // Ambil harga dari tayang

  void _toggleSeat(String seatId) {
    final seat = kursi[seatId];
    if (seat == null || seat.status == SeatStatus.terisi) return;
    setState(() {
      seat.status = seat.status == SeatStatus.dipilih
          ? SeatStatus.tersedia
          : SeatStatus.dipilih;
    });
  }

  void _cancelSelection() {
    setState(() {
      for (final seat in kursi.values) {
        if (seat.status == SeatStatus.dipilih) {
          seat.status = SeatStatus.tersedia;
        }
      }
    });
  }

  void _pay() async {
  if (selectedSeats.isEmpty) return;

  final seatDisplay = selectedSeats
      .map((s) => '${s.row}${s.number}')
      .join(', ');

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Konfirmasi Pemesanan'),
      content: Text(
        'Kursi: $seatDisplay\n'
        'Total: Rp${_formatPrice(totalPrice)}',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batalkan'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            
            try {
              final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
              
              // ✅ Konversi selectedSeats ke format untuk disimpan
              final seatsToBook = selectedSeats
                  .map((s) => {'row': s.row, 'number': s.number})
                  .toList();

              // ✅ Buat pembayaran PENDING (bukan langsung terisi)
              // Format tanggal: yyyy-MM-dd
              final tanggalStr = '${widget.selectedDate.year.toString().padLeft(4, '0')}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}';
              
              final pembayaranId = await PembayaranRepository().createPembayaran(
                userId: userId,
                tayangId: widget.tayang.tayangId,   // ✅ Single tayangId
                movieId: widget.movie.id,            // ✅ Pass movieId
                tanggal: tanggalStr,                 // ✅ Pass tanggal sebagai string
                jam: widget.selectedTime,            // ✅ Pass selectedTime sebagai jam
                seats: seatsToBook,
                harga: widget.tayang.harga,
              );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lanjut ke pembayaran...')),
                );
                
                // ✅ Navigate ke pembayaran
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PembayaranPage(
                      pembayaranId: pembayaranId,
                      seats: seatsToBook,
                    ),
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            }
          },
          child: const Text('Lanjut'),
        ),
      ],
    ),
  );
}

  String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  Color _seatColor(SeatStatus status) {
    switch (status) {
      case SeatStatus.tersedia:
        return const Color(0xFF1A3A8F);
      case SeatStatus.dipilih:
        return const Color(0xFF6B9EFF);
      case SeatStatus.terisi:
        return const Color(0xFFD32F2F);
    }
  }

  Widget _buildSeat(String kursiId) {
    final seat = kursi[kursiId];
    if (seat == null) return const SizedBox(width: 32, height: 32);

    return GestureDetector(
      onTap: () => _toggleSeat(kursiId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 32,
        height: 32,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _seatColor(seat.status),
          borderRadius: BorderRadius.circular(6),
          boxShadow: seat.status == SeatStatus.dipilih
              ? [
                  BoxShadow(
                    color: const Color(0xFF6B9EFF),
                    blurRadius: 6,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            seat.number.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Build row dengan label kursi
  Widget _buildRow(String rowLabel) {
    // Kursi 1-4 (kiri) dan 5-8 (kanan)
    final leftSeats = [1, 2, 3, 4].map((n) => '${rowLabel}_$n').toList();
    final rightSeats = [5, 6, 7, 8].map((n) => '${rowLabel}_$n').toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Label row
          SizedBox(
            width: 24,
            child: Text(
              rowLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Kursi kiri
          ...leftSeats.map(_buildSeat),
          const SizedBox(width: 10), // Aisle gap
          // Kursi kanan
          ...rightSeats.map(_buildSeat),
          const SizedBox(width: 4),
          // Label row (kanan)
          SizedBox(
            width: 24,
            child: Text(
              rowLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedSeats.isNotEmpty;
    final dateStr =
        '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}';
    final dayName = _getDayName(widget.selectedDate.weekday);

    return FutureBuilder<Set<String>>(
      future: _bookedSeatsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: BixAppBar.seatPicker(
            movieTitle:  widget.movie.judul,
            cinema: widget.tayang.namaTeater.namaTeater,
            timeRange: '$dateStr. $dayName',
            date: widget.selectedTime,
            ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      // Screen
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: CustomPaint(
                          size: const Size(double.infinity, 50),
                          painter: _ScreenPainter(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Layar',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.movie.format,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Seat grid
                      for (final row in rowLabels) _buildRow(row),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Bottom panel
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem(
                            const Color(0xFF1A3A8F), 'Tersedia'),
                        const SizedBox(width: 16),
                        _buildLegendItem(
                            const Color(0xFF6B9EFF), 'Dipilih'),
                        const SizedBox(width: 16),
                        _buildLegendItem(
                            const Color(0xFFD32F2F), 'Telah Di Booking'),
                      ],
                    ),
                    if (hasSelection) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.event_seat,
                            color: Color(0xFF1A3A8F),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${selectedSeats.length} Kursi terpilih',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Total : ',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Rp${_formatPrice(totalPrice)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A3A8F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _cancelSelection,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color(0xFF1A3A8F)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Batalkan',
                                style: TextStyle(
                                  color: Color(0xFF1A3A8F),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _pay,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A3A8F),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Pembayaran',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
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
}

class _ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blueGrey.shade200,
          Colors.blueGrey.shade50,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.05, size.height);
    path.quadraticBezierTo(size.width * 0.5, 0, size.width * 0.95, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.blueGrey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}