class KursiModel {
    final String id;
    final String tayangId;
    final String userId;
    final String namaKursi;
    final String status;

    KursiModel({
        required this.id,
        required this.tayangId,
        required this.userId,
        required this.namaKursi,
        required this.status,
    });

    factory KursiModel.fromJson(Map<String, dynamic> json) {
        return KursiModel(
            id: json['id'] as String? ?? '',
            tayangId: json['tayangId'] as String? ?? '',
            userId: json['userId'] as String? ?? '',
            namaKursi: json['namaKursi'] as String? ?? '',
            status: json['status'] as String? ?? '',
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'tayangId': tayangId,
            'userId': userId,
            'namaKursi': namaKursi,
            'status': status,
        };
    }
}