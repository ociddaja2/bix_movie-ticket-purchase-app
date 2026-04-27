class MovieModel {
  final String id;
  final String judul;
  final String sinopsis;
  final List<String> genre;
  final String durasi;
  final String format;
  final String rating;
  final bool status;

  final List<String> jam; // List of showtimes in string format
  String posterUrl;
  final String? trailerUrl;

  MovieModel({  
    required this.id,
    required this.judul,
    required this.sinopsis,
    required this.genre,
    required this.durasi,
    required this.format,
    required this.rating,
    required this.status,
    required this.jam,
    required this.posterUrl,
    this.trailerUrl,
  });

  // Factory method to create a MovieModel from JSON
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String? ?? '',
      judul: json['judul'] as String? ?? '',
      sinopsis: json['sinopsis'] as String? ?? '',
      genre: List<String>.from(json['genre'] as List<dynamic>? ?? []),
      durasi: json['durasi'] as String? ?? '',
      format: json['format'] as String? ?? '',
      rating: json['rating'] as String? ?? '',
      status: json['status'] as bool? ?? false,
      jam: List<String>.from(json['jam'] as List<dynamic>? ?? []),
      posterUrl: json['posterUrl'] as String? ?? '',
      trailerUrl: json['trailerUrl'] as String?,
    );
  }

  // Method to convert a MovieModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'sinopsis': sinopsis,
      'genre': genre,
      'durasi': durasi,
      'format': format,
      'rating': rating,
      'status': status,
      'jam': jam,
      'posterUrl': posterUrl,
      'trailerUrl': trailerUrl,
    };
  }
}

