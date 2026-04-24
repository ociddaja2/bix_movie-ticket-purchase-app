class TeaterModel {
  final String teaterId;
  final String namaTeater;
  final String kota;

  TeaterModel({
    required this.teaterId,
    required this.namaTeater,
    required this.kota,
  });

  factory TeaterModel.fromJson(Map<String, dynamic> json) {
    return TeaterModel(
      teaterId: json['teaterid'] as String? ?? '',
      namaTeater: json['nama'] as String? ?? '',
      kota: json['kota'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teaterId': teaterId,
      'namaTeater': namaTeater,
      'kota': kota,
    };
  }
}