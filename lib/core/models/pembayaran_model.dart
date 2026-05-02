class PembayaranModel {
  final String pembayaranId;
  final String userId;
  final String tayangId;  // ✅ Tambah tayangId
  final String movieId;   // ✅ Tambah movieId
  final String tanggal;   // ✅ Tambah tanggal (format: yyyy-MM-dd)
  final String jam;
  final String metodePembayaran;
  final String status;
  final List<Map> seats;
  // final String snapToken;

  final int totalHarga;
  final int biayaLayanan;
  final DateTime paidAt;
  final DateTime createdAt;

  PembayaranModel({
    required this.pembayaranId,
    required this.userId,
    required this.tayangId,
    required this.movieId,
    required this.tanggal,
    required this.jam,
    required this.metodePembayaran,
    required this.status,
    // required this.jam,
    required this.seats,
    // required this.snapToken,
    required this.totalHarga,
    required this.biayaLayanan,
    required this.paidAt,
    required this.createdAt,
  });

  factory PembayaranModel.fromJson(Map<String, dynamic> json) {
    return PembayaranModel(
      pembayaranId: json['id'] as String,
      userId: json['userId'] as String,
      tayangId: json['tayangId'] as String? ?? '',
      movieId: json['movieId'] as String? ?? '',
      tanggal: json['tanggal'] as String? ?? '',
      jam: json['jam'] as String? ?? '',
      metodePembayaran: json['metodePembayaran'] as String? ?? '',
      status: json['status'] as String,
      seats: List<Map>.from(json['seats'] as List<dynamic>),
      totalHarga: json['totalHarga'] as int,
      biayaLayanan: json['biayaLayanan'] as int,
      paidAt: (json['paidAt']?.toDate()) ?? DateTime.now(),
      createdAt: (json['createdAt']?.toDate()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': pembayaranId,
      'userId': userId,
      'tayangId': tayangId,
      'movieId': movieId,
      'tanggal': tanggal,
      'jam': jam,
      'metodePembayaran': metodePembayaran,
      'status': status,
      'seats': seats,
      'totalHarga': totalHarga,
      'biayaLayanan': biayaLayanan,
      'paidAt': paidAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
