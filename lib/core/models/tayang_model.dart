class TayangModel {
    final String tayangId;
    final String teaterId;
    final String movieId;
    final String jam;
    final String tanggal;
    final String harga;

    TayangModel({
        required this.tayangId,
        required this.teaterId,
        required this.movieId,
        required this.jam,
        required this.tanggal,
        required this.harga,
    });

    factory TayangModel.fromJson(Map<String, dynamic> json) {
        return TayangModel(
            tayangId: json['tayangId'] as String? ?? '',
            teaterId: json['teater_id'] as String? ?? '',
            movieId: json['movie_id'] as String? ?? '',
            jam: json['jam'] as String? ?? '',
            tanggal: json['tanggal'] as String? ?? '',
            harga: json['harga'] as String? ?? '',
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'tanggalId': tayangId,
            'teaterId': teaterId,
            'movieId': movieId,
            'jam': jam,
            'tanggal': tanggal,
            'harga': harga,
        };
    }
}