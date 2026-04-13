class JadwalModel {
  final String movieId;
  final String tanggalTayang;
  final String jamTayang;
  final List<String> bookingKursi;

  JadwalModel({
    required this.movieId,
    required this.tanggalTayang,
    required this.jamTayang,
    required this.bookingKursi,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      movieId: json['movie_id'] as String,
      tanggalTayang: json['tanggal_tayang'] as String,
      jamTayang: json['jam_tayang'] as String,
      bookingKursi: List<String>.from(json['booking_kursi'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movie_id': movieId,
      'tanggal_tayang': tanggalTayang,
      'jam_tayang': jamTayang,
      'booking_kursi': bookingKursi,
    };
  }
}