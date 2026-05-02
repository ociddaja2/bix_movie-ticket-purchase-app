// ignore_for_file: deprecated_member_use

import 'package:bixcinema/ui/widgets/appbar_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bixcinema/core/repo/pembayaran_repo.dart';
import 'package:bixcinema/core/repo/tayang_repo.dart';
import 'package:bixcinema/core/repo/movie_repo.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BIX Cinema',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5BB5)),
        useMaterial3: true,
      ),
      home: const BookingScreen(),
    );
  }
}

/// Satu kursi: row (huruf) + number (angka)
/// Contoh Firestore: { "row": "J", "number": 1 }
class SeatItem {
  final String row;
  final int number;

  const SeatItem({required this.row, required this.number});

  /// Dari Map Firestore
  factory SeatItem.fromMap(Map<String, dynamic> map) {
    return SeatItem(
      row: map['row'] as String,
      number: (map['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() => {'row': row, 'number': number};

  /// Tampilkan sebagai "J1"
  String get label => '$row$number';
}

/// Status pemesanan
enum BookingStatus { paid, pending, cancelled }

/// Model utama Booking — field 1-to-1 dengan Firestore
class BookingItem {
  final String id;
  final int biayaLayanan;   // biaya layanan / service fee
  final DateTime createdAt;
  final int harga;          // harga per tiket
  final DateTime? paidAt;
  final List<SeatItem> seats;
  final BookingStatus status;
  final String tayangId;    // ID jadwal tayang
  final int totalHarga;     // total yang dibayar
  final String userId;

  // Field tambahan yang diambil dari koleksi Tayang / Film
  // (join di sisi app, bukan dari dokumen booking)
  final String? movieTitle;
  final String? genre;
  final String? duration;
  final String? ageRating;
  final String? format;
  final String? cinema;
  final String? showTime;
  final String? imagePath;

  const BookingItem({
    required this.id,
    required this.biayaLayanan,
    required this.createdAt,
    required this.harga,
    this.paidAt,
    required this.seats,
    required this.status,
    required this.tayangId,
    required this.totalHarga,
    required this.userId,
    this.movieTitle,
    this.genre,
    this.duration,
    this.ageRating,
    this.format,
    this.cinema,
    this.showTime,
    this.imagePath,
  });

  /// Dari dokumen Firestore (Map)
  factory BookingItem.fromFirestore(Map<String, dynamic> data) {
    final rawSeats = data['seats'] as List<dynamic>? ?? [];
    final seats = rawSeats
        .map((s) => SeatItem.fromMap(Map<String, dynamic>.from(s as Map)))
        .toList();

    BookingStatus status;
    switch ((data['status'] as String?)?.toLowerCase()) {
      case 'paid':
        status = BookingStatus.paid;
        break;
      case 'pending':
        status = BookingStatus.pending;
        break;
      default:
        status = BookingStatus.cancelled;
    }

    DateTime parseDate(dynamic raw) {
      if (raw is DateTime) return raw;
      // Jika pakai cloud_firestore, uncomment:
      // if (raw is Timestamp) return raw.toDate();
      return DateTime.now();
    }

    return BookingItem(
      id: data['id'] as String? ?? '',
      biayaLayanan: (data['biayaLayanan'] as num?)?.toInt() ?? 0,
      createdAt: parseDate(data['createdAt']),
      harga: (data['harga'] as num?)?.toInt() ?? 0,
      paidAt: data['paidAt'] != null ? parseDate(data['paidAt']) : null,
      seats: seats,
      status: status,
      tayangId: data['tayangId'] as String? ?? '',
      totalHarga: (data['totalHarga'] as num?)?.toInt() ?? 0,
      userId: data['userId'] as String? ?? '',
    );
  }

  /// Salin dengan menambah info film dari koleksi Tayang
  BookingItem copyWithMovieInfo({
    String? movieTitle,
    String? genre,
    String? duration,
    String? ageRating,
    String? format,
    String? cinema,
    String? showTime,
    String? imagePath,
  }) {
    return BookingItem(
      id: id,
      biayaLayanan: biayaLayanan,
      createdAt: createdAt,
      harga: harga,
      paidAt: paidAt,
      seats: seats,
      status: status,
      tayangId: tayangId,
      totalHarga: totalHarga,
      userId: userId,
      movieTitle: movieTitle ?? this.movieTitle,
      genre: genre ?? this.genre,
      duration: duration ?? this.duration,
      ageRating: ageRating ?? this.ageRating,
      format: format ?? this.format,
      cinema: cinema ?? this.cinema,
      showTime: showTime ?? this.showTime,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  /// Label kursi gabungan: "J1, J2, J3"
  String get seatsLabel => seats.map((s) => s.label).join(', ');

  /// Jumlah kursi
  int get jumlahKursi => seats.length;

  /// Subtotal (harga × jumlah kursi)
  int get subtotal => harga * jumlahKursi;

  String get tanggalPembayaran {
    if (paidAt == null) return '-';
    return '${paidAt!.day.toString().padLeft(2, '0')}-'
        '${paidAt!.month.toString().padLeft(2, '0')}-'
        '${paidAt!.year}';
  }

  String get tanggalPemesanan =>
      '${createdAt.day.toString().padLeft(2, '0')}-'
      '${createdAt.month.toString().padLeft(2, '0')}-'
      '${createdAt.year}';
}

class MoviePoster extends StatelessWidget {
  final String movieId;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const MoviePoster({
    super.key,
    required this.movieId,
    this.width = 70,
    this.height = 90,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvatar = movieId == 'avatar';
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: isAvatar
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0D3B8E), Color(0xFF1A7A4A)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B2252), Color(0xFF2D4A8A)],
                ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              top: -8,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isAvatar ? Icons.movie_filter : Icons.pets,
                    color: Colors.white.withOpacity(0.9),
                    size: width * 0.38,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      isAvatar ? 'AVATAR' : 'ZOOTOPIA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.11,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieBadge extends StatelessWidget {
  final String text;
  const MovieBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF1A5BB5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MovieBadgeRow extends StatelessWidget {
  final String? duration;
  final String? ageRating;
  final String? format;

  const MovieBadgeRow({super.key, this.duration, this.ageRating, this.format});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: [
        if (duration != null) MovieBadge(text: duration!),
        if (ageRating != null) MovieBadge(text: ageRating!),
        if (format != null) MovieBadge(text: format!),
      ],
    );
  }
}

// ====================== SCREENS ======================

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late Future<List<BookingItem>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _fetchUserBookings();
  }

  // ✅ Fetch semua pembayaran user yang status = "paid" dan join dengan tayang + movie
  Future<List<BookingItem>> _fetchUserBookings() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return [];

      final pembayaranList =
          await PembayaranRepository().getUserPaidPembayaran(userId);

      // Untuk setiap pembayaran, fetch detail tayang dan movie
      final bookingDetails = <BookingItem>[];

      for (var pembayaran in pembayaranList) {
        try {
          // Convert PembayaranModel to Map if needed
          final pembayaranData = pembayaran is Map<String, dynamic> 
              ? pembayaran 
              : (pembayaran as dynamic).toJson() as Map<String, dynamic>;
          
          final tayangId = pembayaranData['tayangId'] as String? ?? '';

          // Fetch tayang details
          final tayang =
              await TayangRepository().fetchTayangById(tayangId);

          if (tayang != null) {
            // Ambil movieId dari tayang.movieId (list)
            final movieId = tayang.movieId.isNotEmpty ? tayang.movieId.first : '';
            
            // Fetch movie details
            final movies = movieId.isNotEmpty
                ? await MovieRepository().fetchMoviesById([movieId])
                : [];
            final movie = movies.isNotEmpty ? movies.first : null;

            // Buat BookingItem dari pembayaran
            final bookingItem = BookingItem.fromFirestore(pembayaranData);
            
            // Tambahkan info film dari tayang dan movie
            final bookingWithMovieInfo = bookingItem.copyWithMovieInfo(
              movieTitle: movie?.judul,
              genre: movie?.genre.join(', '),
              duration: movie?.durasi,
              ageRating: movie?.rating,
              format: movie?.format,
              cinema: tayang.namaTeater.namaTeater,
              showTime: tayang.tanggal.isNotEmpty 
                  ? _formatShowTime(tayang.tanggal.first) 
                  : '-',
              imagePath: movie?.id,
            );

            bookingDetails.add(bookingWithMovieInfo);
          }
        } catch (e) {
          print('Error processing booking: $e');
          continue;
        }
      }

      return bookingDetails;
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  String _formatShowTime(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: BixAppBar.subtitle(title: 'Booking', subtitle: 'Menampilkan detail Pesanan tiket yang sudah di Booking', onBack: () => context.go('/booking')),
      body: FutureBuilder<List<BookingItem>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading bookings'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _bookingsFuture = _fetchUserBookings();
                      });
                    },
                    child: const Text('Retry'),
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
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada pemesanan',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.movie),
                    label: const Text('Pesan Tiket Sekarang'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return _BookingCard(
                      booking: booking,
                      onTap: () => context.push('/booking-detail', extra: booking),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingItem booking;
  final VoidCallback onTap;

  const _BookingCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MoviePoster(movieId: booking.imagePath ?? '', width: 70, height: 90),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              booking.movieTitle ?? 'Film',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: onTap,
                            child: const Row(
                              children: [
                                Text(
                                  'Detail Pesanan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF1A5BB5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(Icons.chevron_right, size: 16, color: Color(0xFF1A5BB5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        booking.genre ?? '',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      MovieBadgeRow(
                        duration: booking.duration,
                        ageRating: booking.ageRating,
                        format: booking.format,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.chair_outlined, size: 14, color: Color(0xFF888888)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              // seats[].row + seats[].number → "J1, J2"
                              booking.seatsLabel,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
                            ),
                          ),
                          Text(
                            booking.paidAt != null
                                ? booking.tanggalPembayaran
                                : booking.tanggalPemesanan,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

