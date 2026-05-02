class KursiModel {
  final String id;
  final String tayangId;
  final String movieId;
  final String tanggal;  // ✅ Tambah tanggal untuk membedakan hari tayang (format: yyyy-MM-dd)
  final String jam;  // ✅ Tambah jam untuk membedakan showtimes
  final String userId;
  final int number; // contoh number = 1
  final String row; // contoh row = "A"
  final String status;

  KursiModel({
    required this.id,
    required this.tayangId,
    required this.movieId,
    required this.tanggal,
    required this.jam,
    required this.userId,
    required this.number,
    required this.row,
    required this.status,
  });

  factory KursiModel.fromJson(Map<String, dynamic> json) {
    return KursiModel(
      id: json['id'] as String? ?? '',
      tayangId: json['tayangId'] as String? ?? '',
      movieId: json['movieId'] as String? ?? '',
      tanggal: json['tanggal'] as String? ?? '',  // ✅ Parse tanggal
      jam: json['jam'] as String? ?? '',  // ✅ Parse jam
      userId: json['userId'] as String? ?? '',
      number: json['number'] as int? ?? 0,
      row: json['row'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tayangId': tayangId,
      'movieId': movieId,
      'tanggal': tanggal,  // ✅ Simpan tanggal
      'jam': jam,  // ✅ Simpan jam
      'userId': userId,
      'number': number,
      'row': row,
      'status': status,
    };
  }
}
