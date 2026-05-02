import 'package:bixcinema/pages/user/booking_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bixcinema/ui/widgets/appbar_2.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingItem booking;
  const BookingDetailScreen({super.key, required this.booking});

  String _fmt(int amount) {
    final s = amount.toString().split('').reversed.toList();
    final chunks = <String>[];
    for (int i = 0; i < s.length; i += 3) {
      chunks.add(s.sublist(i, i + 3 < s.length ? i + 3 : s.length).join());
    }
    return 'Rp${chunks.join('.').split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: BixAppBar.subtitle(
        title: booking.movieTitle ?? 'Detail Booking',
        subtitle: 'Menampilkan detail Pesanan tiket yang sudah di Booking',
        onBack: () => context.go('/booking'),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Info film
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MoviePoster(
                            movieId: booking.imagePath ?? '',
                            width: 82,
                            height: 108,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.movieTitle ?? 'Film',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  booking.genre ?? '',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                                ),
                                const SizedBox(height: 10),
                                MovieBadgeRow(
                                  duration: booking.duration,
                                  ageRating: booking.ageRating,
                                  format: booking.format,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    _DashedDivider(),

                    // Detail pembayaran
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detail Pembayaran',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Kursi dari seats[].row + seats[].number
                          _PaymentRow(
                            label: 'Tiket ${booking.format ?? '2D'}',
                            value: booking.seatsLabel,
                            valueStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1A5BB5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // harga (per tiket) × jumlahKursi
                          _PaymentRow(
                            label: 'Harga Tiket',
                            value: '${_fmt(booking.harga)} × ${booking.jumlahKursi}',
                          ),
                          const SizedBox(height: 8),

                          // subtotal = harga × jumlahKursi
                          _PaymentRow(
                            label: 'Sub total',
                            value: _fmt(booking.subtotal),
                          ),
                          const SizedBox(height: 8),

                          // biayaLayanan dari Firestore
                          _PaymentRow(
                            label: 'Biaya Layanan',
                            value: _fmt(booking.biayaLayanan),
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: Color(0xFFEEEEEE)),
                          ),

                          // totalHarga dari Firestore
                          _PaymentRow(
                            label: 'Total',
                            value: _fmt(booking.totalHarga),
                            labelStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                            ),
                            valueStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status pembayaran
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                      child: booking.status == BookingStatus.paid
                          ? _PaidStatus(date: booking.tanggalPembayaran)
                          : _PendingStatus(),
                    ),
                  ],
                ),
              ),
            ),

            // Info teknis (ID, tayangId, userId)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: _InfoTeknis(booking: booking),
            ),
          ],
        ),
      ),
    );
  }
}

// Status
class _PaidStatus extends StatelessWidget {
  final String date;
  const _PaidStatus({required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF22C55E).withOpacity(0.12),
            border: Border.all(color: const Color(0xFF22C55E), width: 2),
          ),
          child: const Icon(Icons.check, color: Color(0xFF22C55E), size: 30),
        ),
        const SizedBox(height: 10),
        const Text(
          'Pembayaran Berhasil !',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
        ),
        const SizedBox(height: 4),
        Text(date, style: const TextStyle(fontSize: 13, color: Color(0xFF888888))),
      ],
    );
  }
}

class _PendingStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF59E0B).withOpacity(0.12),
            border: Border.all(color: const Color(0xFFF59E0B), width: 2),
          ),
          child: const Icon(Icons.hourglass_top, color: Color(0xFFF59E0B), size: 28),
        ),
        const SizedBox(height: 10),
        const Text(
          'Menunggu Pembayaran',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Selesaikan pembayaran Anda',
          style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
        ),
      ],
    );
  }
}

//debug
class _InfoTeknis extends StatelessWidget {
  final BookingItem booking;
  const _InfoTeknis({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Info Pemesanan (Debug)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF555555)),
          ),
          const SizedBox(height: 8),
          _InfoRow(label: 'ID Booking', value: booking.id),
          const SizedBox(height: 4),
          _InfoRow(label: 'Tayang ID', value: booking.tayangId),
          const SizedBox(height: 4),
          _InfoRow(
            label: 'User ID',
            value: booking.userId.length > 20
                ? '${booking.userId.substring(0, 20)}...'
                : booking.userId,
          ),
          const SizedBox(height: 4),
          _InfoRow(label: 'Dibuat', value: booking.tanggalPemesanan),
        ],
      ),
    );
  }
}

// style value pembayaran = tiket kursi / harga / subtotal / biaya layanan
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
        ),
        const Text(': ', style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Color(0xFF333333), fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// row label dan value pembayaran
class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _PaymentRow({required this.label, required this.value, this.labelStyle, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle ?? const TextStyle(fontSize: 13, color: Color(0xFF666666))),
        Text(
          value,
          style: valueStyle ??
              const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashedLinePainter(),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDDDDDD)
      ..strokeWidth = 1.5;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + 6, 0), paint);
      x += 10;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => false;
}