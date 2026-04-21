class LocationModel {
  final String teaterid;
  final String nama;
  final String kota;

  LocationModel({
    required this.teaterid,
    required this.nama,
    required this.kota,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      teaterid: json['teaterid'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      kota: json['kota'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teaterid': teaterid,
      'nama': nama,
      'kota': kota,
    };
  }
}