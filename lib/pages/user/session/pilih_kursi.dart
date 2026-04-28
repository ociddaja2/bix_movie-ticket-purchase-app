import 'package:flutter/material.dart';
import 'package:bixcinema/core/models/movie_model.dart';
import 'package:bixcinema/core/models/tayang_model.dart';
import 'package:bixcinema/core/repo/tayang_repo.dart';
import 'package:bixcinema/core/models/teater_model.dart';

class PilihKursiPage extends StatelessWidget {
  const PilihKursiPage({
    super.key,
    required String tayang,
    required MovieModel movie,
    required String selectedShowtime,
    required DateTime selectedDate,
    });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinema Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A3A8F)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SeatBookingScreen(),
    );
  }
}

enum SeatStatus { available, selected, booked }

class Seat {
  final String id;
  SeatStatus status;

  Seat({required this.id, this.status = SeatStatus.available});
}

class SeatBookingScreen extends StatefulWidget {
  final MovieModel? movie;
  final TayangModel? tayang;


  const SeatBookingScreen({super.key, this.movie, this.tayang});

  @override
  State<SeatBookingScreen> createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  static const int pricePerSeat = 50000;

  // Row labels from back to front
  final List<String> rowLabels = ['J', 'H', 'G', 'F', 'E', 'D', 'C', 'B', 'A'];

  // Left block columns: 13..10, Right block columns: 9..6
  // We'll model seats as a map: rowLabel+colNum -> Seat
  late Map<String, Seat> seats;

  // Pre-booked seats (red in design)
  final Set<String> bookedSeats = {
    'J10', 'H12', 'E13', 'E12', 'C7', 'A9',
  };

  @override
  void initState() {
    super.initState();
    _initSeats();
  }

  void _initSeats() {
    seats = {};
    for (final row in rowLabels) {
      // Left block: col 13 down to 10
      for (int col = 13; col >= 10; col--) {
        final id = '$row$col';
        seats[id] = Seat(
          id: id,
          status: bookedSeats.contains(id) ? SeatStatus.booked : SeatStatus.available,
        );
      }
      // Right block: col 9 down to 6
      for (int col = 9; col >= 6; col--) {
        final id = '$row$col';
        seats[id] = Seat(
          id: id,
          status: bookedSeats.contains(id) ? SeatStatus.booked : SeatStatus.available,
        );
      }
    }
  }

  List<String> get selectedSeats =>
      seats.values.where((s) => s.status == SeatStatus.selected).map((s) => s.id).toList();

  int get totalPrice => selectedSeats.length * pricePerSeat;

  void _toggleSeat(String id) {
    final seat = seats[id];
    if (seat == null || seat.status == SeatStatus.booked) return;
    setState(() {
      seat.status = seat.status == SeatStatus.selected
          ? SeatStatus.available
          : SeatStatus.selected;
    });
  }

  void _cancelSelection() {
    setState(() {
      for (final seat in seats.values) {
        if (seat.status == SeatStatus.selected) {
          seat.status = SeatStatus.available;
        }
      }
    });
  }

  void _pay() {
    if (selectedSeats.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Text(
          'Kursi: ${selectedSeats.join(', ')}\n'
          'Total: Rp${_formatPrice(totalPrice)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
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
      case SeatStatus.available:
        return const Color(0xFF1A3A8F);
      case SeatStatus.selected:
        return const Color(0xFF6B9EFF);
      case SeatStatus.booked:
        return const Color(0xFFD32F2F);
    }
  }

  Widget _buildSeat(String id) {
    final seat = seats[id];
    if (seat == null) return const SizedBox(width: 32, height: 32);
    return GestureDetector(
      onTap: () => _toggleSeat(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 32,
        height: 32,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _seatColor(seat.status),
          borderRadius: BorderRadius.circular(6),
          boxShadow: seat.status == SeatStatus.selected
              ? [BoxShadow(color: const Color(0xFF6B9EFF).withOpacity(0.5), blurRadius: 6, spreadRadius: 1)]
              : null,
        ),
        child: Center(
          child: Text(
            id,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 7.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String rowLabel) {
    // Left block: 13, 12, 11, 10
    final leftSeats = [13, 12, 11, 10].map((c) => '$rowLabel$c').toList();
    // Right block: 9, 8, 7, 6
    final rightSeats = [9, 8, 7, 6].map((c) => '$rowLabel$c').toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...leftSeats.map(_buildSeat),
          const SizedBox(width: 20), // aisle gap
          ...rightSeats.map(_buildSeat),
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
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedSeats.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3A8F),
        leading: const BackButton(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.movie?.judul ?? 'Film',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              widget.tayang!.namaTeater.namaTeater,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  selectedDate,
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2),
                Text(
                  selectedShowtime,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  // Screen shape
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
                  const Text(
                    'Reguler 2D',
                    style: TextStyle(
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
                    _buildLegendItem(const Color(0xFF1A3A8F), 'Tersedia'),
                    const SizedBox(width: 16),
                    _buildLegendItem(const Color(0xFF6B9EFF), 'Dipilih'),
                    const SizedBox(width: 16),
                    _buildLegendItem(const Color(0xFFD32F2F), 'Telah Di Booking'),
                  ],
                ),
                if (hasSelection) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.event_seat, color: Color(0xFF1A3A8F), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${selectedSeats.length} Kursi terpilih',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const Spacer(),
                      const Text('Total : ', style: TextStyle(fontSize: 14)),
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
                            side: const BorderSide(color: Color(0xFF1A3A8F)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Batalkan',
                            style: TextStyle(color: Color(0xFF1A3A8F), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _pay,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A3A8F),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Pembayaran',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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