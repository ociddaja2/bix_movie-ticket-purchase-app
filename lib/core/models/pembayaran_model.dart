class PembayaranModel {
  final String pembayaranId;
  final String userId;
  final String bookingId;
  final String metodePembayaran;
  final String status;
  // final String snapToken;

  final int totalHarga;
  final int biayaLayanan;
  final DateTime paidAt;
  final DateTime createdAt;

  PembayaranModel({
    required this.pembayaranId,
    required this.userId,
    required this.bookingId,
    required this.metodePembayaran,
    required this.status,
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
      bookingId: json['bookingId'] as String,
      metodePembayaran: json['metodePembayaran'] as String,
      status: json['status'] as String,
      // snapToken: json['snap_token'] as String,
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
      'bookingId': bookingId,
      'metodePembayaran': metodePembayaran,
      'status': status,
      // 'snap_token': snapToken,
      'totalHarga': totalHarga,
      'biayaLayanan': biayaLayanan,
      'paidAt': paidAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}