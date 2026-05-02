// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:bixcinema/ui/widgets/appbar_2.dart';
import 'package:bixcinema/core/repo/pembayaran_repo.dart';
import 'package:bixcinema/core/repo/tayang_repo.dart';
import 'package:bixcinema/core/repo/movie_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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
  final int biayaLayanan; // biaya layanan / service fee
  final DateTime createdAt;
  final int harga; // harga per tiket
  final DateTime? paidAt;
  final List<SeatItem> seats;
  final BookingStatus status;
  final String tayangId; // ID jadwal tayang
  final int totalHarga; // total yang dibayar
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
  final String? posterUrl;  // ✅ URL poster film dari Firebase

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
    this.posterUrl,
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
    String? posterUrl,
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
      posterUrl: posterUrl ?? this.posterUrl,
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

// ✅ Helper function untuk fetch bookings dari backend
Future<List<BookingItem>> fetchUserBookings() async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final pembayaranList =
        await PembayaranRepository().getUserPaidPembayaran(userId);
    final bookingDetails = <BookingItem>[];

    for (var pembayaran in pembayaranList) {
      try {
        // Convert seats dari List<Map> to List<SeatItem>
        final seats = (pembayaran.seats as List<dynamic>)
            .map((s) => SeatItem.fromMap(Map<String, dynamic>.from(s as Map)))
            .toList();

        // Tentukan status
        BookingStatus status;
        switch (pembayaran.status.toLowerCase()) {
          case 'paid':
            status = BookingStatus.paid;
            break;
          case 'pending':
            status = BookingStatus.pending;
            break;
          default:
            status = BookingStatus.cancelled;
        }

        // Fetch tayang details
        final tayang =
            await TayangRepository().fetchTayangById(pembayaran.tayangId);

        String movieTitle = 'Film';
        String cinema = 'Teater';
        String? genre;
        String? duration;
        String? ageRating;
        String? format;
        String? posterUrl;  // ✅ Poster URL dari Firebase

        if (tayang != null) {
          cinema = tayang.namaTeater.namaTeater;

          // Fetch movie details
          if (pembayaran.movieId.isNotEmpty) {
            final movie =
                await MovieRepository().fetchMovieById(pembayaran.movieId);
            if (movie != null) {
              movieTitle = movie.judul;
              genre = movie.genre.join(', ');
              duration = movie.durasi;
              ageRating = movie.rating;
              format = movie.format;
              posterUrl = movie.posterUrl;  // ✅ Ambil poster URL
            }
          }
        }

        // Hitung harga per kursi jika belum ada
        int hargaPerKursi =
            seats.isNotEmpty ? (pembayaran.totalHarga ~/ seats.length) : 0;

        bookingDetails.add(
          BookingItem(
            id: pembayaran.pembayaranId,
            biayaLayanan: pembayaran.biayaLayanan,
            createdAt: pembayaran.createdAt,
            harga: hargaPerKursi,
            paidAt: pembayaran.paidAt,
            seats: seats,
            status: status,
            tayangId: pembayaran.tayangId,
            totalHarga: pembayaran.totalHarga,
            userId: pembayaran.userId,
            movieTitle: movieTitle,
            cinema: cinema,
            showTime: pembayaran.jam,
            genre: genre,
            duration: duration,
            ageRating: ageRating,
            format: format,
            posterUrl: posterUrl,  // ✅ URL poster dari movie
          ),
        );
      } catch (e) {
        print('Error processing pembayaran: $e');
        continue;
      }
    }

    return bookingDetails;
  } catch (e) {
    print('Error fetching user bookings: $e');
    return [];
  }
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
    _bookingsFuture = fetchUserBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: BixAppBar.subtitle(
        title: 'Booking',
        subtitle: 'Menampilkan detail Pesanan tiket yang sudah di Booking',
        onBack: () => context.go('/home'),
      ),
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
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
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
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada pemesanan',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Pesan Sekarang'),
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BookingDetailScreen(booking: booking),
                        ),
                      ),
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
                // ✅ Display poster dari URL dengan error handling
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 70,
                    height: 90,
                    color: Colors.grey[300],
                    child: booking.posterUrl != null &&
                            booking.posterUrl!.isNotEmpty
                        ? Image.network(
                            booking.posterUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[400],
                              child: const Icon(
                                Icons.movie,
                                color: Colors.white54,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.movie,
                            color: Colors.grey[600],
                          ),
                  ),
                ),
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
                                Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                  color: Color(0xFF1A5BB5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        booking.genre ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888888),
                        ),
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
                          const Icon(
                            Icons.chair_outlined,
                            size: 14,
                            color: Color(0xFF888888),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              // seats[].row + seats[].number → "J1, J2"
                              booking.seatsLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ),
                          Text(
                            booking.paidAt != null
                                ? booking.tanggalPembayaran
                                : booking.tanggalPemesanan,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                            ),
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
        onBack: () => context.go('/home'),
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
                          // ✅ Display poster dari URL
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 82,
                              height: 108,
                              color: Colors.grey[300],
                              child: booking.posterUrl != null &&
                                      booking.posterUrl!.isNotEmpty
                                  ? Image.network(
                                      booking.posterUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            value: progress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? progress
                                                        .cumulativeBytesLoaded /
                                                    progress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (_, __, ___) =>
                                          Container(
                                        color: Colors.grey[400],
                                        child: const Icon(
                                          Icons.movie,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.movie,
                                      color: Colors.grey[600],
                                    ),
                            ),
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
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF888888),
                                  ),
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
                            value:
                                '${_fmt(booking.harga)} × ${booking.jumlahKursi}',
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
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
        ),
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
          child: const Icon(
            Icons.hourglass_top,
            color: Color(0xFFF59E0B),
            size: 28,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Menunggu Pembayaran',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
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
            'Info Pemesanan',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF555555),
            ),
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
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
          ),
        ),
        const Text(
          ': ',
          style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// =================== HELPER WIDGETS ===================

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _PaymentRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              labelStyle ??
              const TextStyle(fontSize: 13, color: Color(0xFF666666)),
        ),
        Text(
          value,
          style:
              valueStyle ??
              const TextStyle(
                fontSize: 13,
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.w500,
              ),
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
