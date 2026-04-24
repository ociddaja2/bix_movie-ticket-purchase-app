import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bixcinema/core/models/teater_model.dart';

class TayangModel {
    final String tayangId;
    final String teaterId;
    final List<String> movieId; // ✅ Ubah dari String ke List<String>
    final List<DateTime> tanggal;
    final int harga;
    final TeaterModel namaTeater; // Optional: nama teater dari joined data

    TayangModel({
        required this.tayangId,
        required this.teaterId,
        required this.movieId,
        required this.tanggal,
        required this.harga,
        required this.namaTeater,
    });

    factory TayangModel.fromJson(Map<String, dynamic> json) {
        return TayangModel(
            tayangId: json['tayangId'] as String? ?? '',
            teaterId: json['teaterId'] as String? ?? '',
            movieId: List<String>.from(json['movieId'] as List? ?? []),
            tanggal: (json['tanggal'] as List)
            .map((item) => (item as Timestamp).toDate())
            .toList(),
            harga: json['harga'] as int? ?? 0,

            namaTeater: json['namaTeater']is Map 
              ? TeaterModel.fromJson(json['namaTeater'] as Map<String, dynamic>)
              : TeaterModel(
                  teaterId: '',
                  namaTeater: json['namaTeater']?.toString() ?? '',
                  kota: '',
              )
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'tayangId': tayangId,
            'teaterId': teaterId,
            'movieId': movieId,
            'tanggal': tanggal,
            'harga': harga,
            'namaTeater': namaTeater.toJson(), // Sertakan data teater jika ada
        };
    }
}