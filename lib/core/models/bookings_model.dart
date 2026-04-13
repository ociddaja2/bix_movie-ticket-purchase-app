class BookingsModel {
  final String id;
  final String userId;
  final String movieId;
  final String judulFilm;
  final String teater;
  final String jamTayang;
  final String status;

  final int totalTiket;
  final int biayaLayanan;
  final int hargaTiket;
  final int totalHarga;

  final DateTime tanggalTayang;
  final DateTime createdAt;
  final List<String> selectedKursi;

  BookingsModel({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.judulFilm,
    required this.teater,
    required this.jamTayang,
    required this.status,
    required this.totalTiket,
    required this.biayaLayanan,
    required this.hargaTiket,
    required this.totalHarga,
    required this.tanggalTayang,
    required this.createdAt,
    required this.selectedKursi,
  });

  factory BookingsModel.fromJson(Map<String, dynamic> json) {
    return BookingsModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      movieId: json['movie_id'] as String,
      judulFilm: json['judul_film'] as String,
      teater: json['teater'] as String,
      jamTayang: json['jam_tayang'] as String,
      status: json['status'] as String,
      totalTiket: json['total_tiket'] as int,
      biayaLayanan: json['biaya_layanan'] as int,
      hargaTiket: json['harga_tiket'] as int,
      totalHarga: json['total_harga'] as int,
      tanggalTayang: (json['tanggal_tayang']?.toDate()) ?? DateTime.now(),
      createdAt: (json['created_at']?.toDate()) ?? DateTime.now(),
      selectedKursi: List<String>.from(json['selected_kursi'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'movie_id': movieId,
      'judul_film': judulFilm,
      'teater': teater,
      'jam_tayang': jamTayang,
      'status': status,
      'total_tiket': totalTiket,
      'biaya_layanan': biayaLayanan,
      'harga_tiket': hargaTiket,
      'total_harga': totalHarga,
      'tanggal_tayang': tanggalTayang.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'selected_kursi': selectedKursi,
    };
  }  
}