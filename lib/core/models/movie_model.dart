class MovieModel {
  final String id;
  final int harga;
  final String judul;
  final String sinopsis;
  final List<String> genre;
  final String durasi;
  final String format;
  final String rating;
  final String teater;

  final String? posterUrl;
  final String? trailerUrl;

  MovieModel({
    required this.id,
    required this.harga,
    required this.judul,
    required this.sinopsis,
    required this.genre,
    required this.durasi,
    required this.format,
    required this.rating,
    required this.teater,
    this.posterUrl,
    this.trailerUrl,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String,
      harga: json['harga'] as int,
      judul: json['judul'] as String,
      sinopsis: json['sinopsis'] as String,
      genre: List<String>.from(json['genre'] as List<dynamic>),
      durasi: json['durasi'] as String,
      format: json['format'] as String,
      rating: json['rating'] as String,
      teater: json['teater'] as String,
      posterUrl: json['poster_url'] as String?,
      trailerUrl: json['trailer_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'harga': harga,
      'judul': judul,
      'sinopsis': sinopsis,
      'genre': genre,
      'durasi': durasi,
      'format': format,
      'rating': rating,
      'teater': teater,
      'poster_url': posterUrl,
      'trailer_url': trailerUrl,
    };
  }
}

