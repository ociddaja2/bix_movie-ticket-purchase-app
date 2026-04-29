class KursiModel {
  final String id;
  final String tayangId;
  final String userId;
  final int number; // contoh number = 1
  final String row; // contoh row = "A"
  final String status;

  KursiModel({
    required this.id,
    required this.tayangId,
    required this.userId,
    required this.number,
    required this.row,
    required this.status,
  });

  factory KursiModel.fromJson(Map<String, dynamic> json) {
    return KursiModel(
      id: json['id'] as String? ?? '',
      tayangId: json['tayangId'] as String? ?? '',
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
      'userId': userId,
      'number': number,
      'row': row,
      'status': status,
    };
  }
}
