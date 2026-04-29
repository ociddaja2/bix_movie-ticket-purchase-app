// lib/pages/user/booking_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bixcinema/ui/widgets/appbar_2.dart';
import 'package:bixcinema/ui/widgets/navbar.dart';
import 'package:bixcinema/core/repo/pembayaran_repo.dart';
import 'package:bixcinema/core/repo/tayang_repo.dart';
import 'package:bixcinema/core/repo/movie_repo.dart';
import 'package:go_router/go_router.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late Future<List<Map<String, dynamic>>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _fetchUserBookings();
  }

  // ✅ Fetch semua pembayaran user yang status = "paid"
  Future<List<Map<String, dynamic>>> _fetchUserBookings() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return [];

      final pembayaranList =
          await PembayaranRepository().getUserPaidPembayaran(userId);

      // Untuk setiap pembayaran, fetch detail tayang dan movie
      final bookingDetails = <Map<String, dynamic>>[];

      for (var pembayaran in pembayaranList) {
        try {
          final tayangId = pembayaran['tayangId'] as String? ?? '';

          // Fetch tayang details
          final tayang =
              await TayangRepository().fetchTayangById(tayangId);

          if (tayang != null) {
            // Fetch movie details
            final movieId = tayang.movieId.isNotEmpty ? tayang.movieId.first : '';
            final movie =
                movieId.isNotEmpty
                    ? await MovieRepository().fetchMoviesById(movieId)
                    : null;

            bookingDetails.add({
              'pembayaran': pembayaran,
              'tayang': tayang,
              'movie': movie,
            });
          }
        } catch (e) {
          print('Error fetching booking details: $e');
        }
      }

      return bookingDetails;
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BixAppBar.subtitle(
        title: 'Booking',
        subtitle: 'Tiket Saya',
        onBack: () => context.go('/home'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1A3A8F),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text('Gagal memuat data booking'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _bookingsFuture = _fetchUserBookings();
                    }),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final bookings = snapshot.data ?? [];

          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.confirmation_number_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada tiket yang dipesan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3A8F),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Pesan Tiket Sekarang',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final pembayaran = booking['pembayaran'] as Map<String, dynamic>;
              final tayang = booking['tayang'];
              final movie = booking['movie'];

              final seats = pembayaran['seats'] as List<dynamic>? ?? [];
              final totalHarga = pembayaran['totalHarga'] as int? ?? 0;
              final createdAt = pembayaran['createdAt'] as DateTime?;
              final paidAt = pembayaran['paidAt'] as DateTime?;

              final seatLabels = seats
                  .map((s) => '${s['row']}${s['number']}')
                  .toList()
                  .join(', ');

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header dengan status
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A3A8F),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Film title
                          if (movie != null)
                            Text(
                              movie.judul ?? 'Film',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          const SizedBox(height: 8),
                          // Status badge
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Pembayaran Berhasil',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Detail tiket
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Teater & format
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: Color(0xFF1A3A8F),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  tayang?.namaTeater.namaTeater ??
                                      'Teater',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Text(
                                movie?.format ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          Divider(
                            color: Colors.grey.shade300,
                            height: 1,
                          ),

                          const SizedBox(height: 12),

                          // Tanggal & jam
                          if (tayang != null && tayang.tanggal.isNotEmpty)
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                  color: Color(0xFF1A3A8F),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDate(tayang.tanggal.first),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.schedule_outlined,
                                  size: 18,
                                  color: Color(0xFF1A3A8F),
                                ),
                                const SizedBox(width: 8),
                                if (movie != null && movie.jam.isNotEmpty)
                                  Text(
                                    movie.jam.first,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                              ],
                            ),

                          const SizedBox(height: 12),

                          // Kursi yang dipesan
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Kursi Anda',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: seats
                                      .map(
                                        (seat) => Chip(
                                          label: Text(
                                            '${seat['row']}${seat['number']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          backgroundColor:
                                              const Color(0xFF1A3A8F),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Harga
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Pembayaran',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Rp${_formatPrice(totalHarga)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A3A8F),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Tanggal pemesanan
                          if (paidAt != null)
                            Text(
                              'Dipesan pada: ${_formatDate(paidAt)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Action buttons
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Implement e-ticket/download
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('E-Ticket'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1A3A8F),
                                side: const BorderSide(
                                  color: Color(0xFF1A3A8F),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implement share/show barcode
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Bagikan'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A3A8F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}