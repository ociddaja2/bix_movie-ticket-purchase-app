class PembayaranModel {
  final String id;
  final String userId;
  final String bookingId;
  final String metodePembayaran;
  final String status;
  final String snapToken;

  final int totalHarga;
  final int biayaLayanan;
  final DateTime paidAt;

  PembayaranModel({
    required this.id,
    required this.userId,
    required this.bookingId,
    required this.metodePembayaran,
    required this.status,
    required this.snapToken,
    required this.totalHarga,
    required this.biayaLayanan,
    required this.paidAt,
  });

  factory PembayaranModel.fromJson(Map<String, dynamic> json) {
    return PembayaranModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bookingId: json['booking_id'] as String,
      metodePembayaran: json['metode_pembayaran'] as String,
      status: json['status'] as String,
      snapToken: json['snap_token'] as String,
      totalHarga: json['total_harga'] as int,
      biayaLayanan: json['biaya_layanan'] as int,
      paidAt: (json['paid_at']?.toDate()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'booking_id': bookingId,
      'metode_pembayaran': metodePembayaran,
      'status': status,
      'snap_token': snapToken,
      'total_harga': totalHarga,
      'biaya_layanan': biayaLayanan,
      'paid_at': paidAt.toIso8601String(),
    };
  }
}