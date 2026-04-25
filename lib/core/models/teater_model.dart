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
    print('Parsing TeaterModel from JSON: $json'); // Debug print
    return TeaterModel(
      teaterId: json['teaterId'] as String? ?? '',
      namaTeater: json['namaTeater'] as String? ?? '',
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