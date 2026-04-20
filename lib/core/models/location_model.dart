class LocationModel {
  final String id;
  final String lokasiId;
  final String kota;
  final String teater;

  LocationModel({
    required this.id,
    required this.lokasiId,
    required this.kota,
    required this.teater,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String? ?? '',
      lokasiId: json['lokasi_id'] as String? ?? '',
      kota: json['kota'] as String? ?? '',
      teater: json['teater'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lokasi_id': lokasiId,
      'kota': kota,
      'teater': teater,
    };
  }
}
