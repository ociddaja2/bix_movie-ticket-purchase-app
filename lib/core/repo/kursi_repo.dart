// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:bixcinema/core/models/kursi_model.dart';
// import 'package:bixcinema/core/models/tayang_model.dart';

// class KursiRepository {
//   final _db = FirebaseFirestore.instance;

//   // Fetch kursi booked dari semua tayangId dalam array
//   Future<Set<String>> fetchBookedSeatsByTayangId(List<String> tayangId) async {
//     try {
//       if (tayangId.isEmpty) return {};

//       // Set untuk menyimpan kursi yang booked (row + number)
//       final bookedSeats = <String>{};

//       // Fetch untuk setiap tayangId
//       for (final tayangId in tayangId) {
//         final snapshot = await _db
//             .collection('kursi')
//             .where('tayangId', arrayContains: tayangId)
//             .where('status', isEqualTo: 'terisi')
//             .get();

//         // Tambahkan ke set dengan format "row_number"
//         for (var doc in snapshot.docs) {
//           final data = doc.data();
//           final row = data['row'] as String? ?? '';
//           final number = data['number'] as int? ?? 0;
//           if (row.isNotEmpty && number > 0) {
//             bookedSeats.add('${row}_$number');
//           }
//         }
//       }

//       return bookedSeats;
//     } catch (e) {
//       print('Error fetching booked seats: $e');
//       return {};
//     }
//   }

//   // Simpan booking ke Firebase dengan row dan number
//   Future<void> bookSeats({
//     required List<String> tayangId,
//     required String userId,
//     required List<Map<String, dynamic>> seats, // [{row, number}, ...]
//   }) async {
//     try {
//       final batch = _db.batch();

//       // Booking untuk semua tayangId dengan kursi yang sama
//       for (final tayangId in tayangId) {
//         for (final seat in seats) {
//           final docRef = _db.collection('kursi').doc();
//           batch.set(docRef, {
//             'tayangId': tayangId,
//             'userId': userId,
//             'row': seat['row'],
//             'number': seat['number'],
//             'status': 'terisi',
//             'createdAt': DateTime.now(),
//           });
//         }
//       }

//       await batch.commit();
//       print('Seats booked successfully for all tayangIds');
//     } catch (e) {
//       print('Error booking seats: $e');
//       rethrow;
//     }
//   }

//   // Fetch booked seats by single tayangId (optional, untuk compatibility)
//   Future<List<KursiModel>> fetchBookedSeatsByTayang(String tayangId) async {
//     try {
//       final snapshot = await _db
//           .collection('kursi')
//           .where('tayangId', arrayContains: tayangId)
//           .where('status', isEqualTo: 'terisi')
//           .get();

//       return snapshot.docs
//           .map((doc) => KursiModel.fromJson({...doc.data(), 'id': doc.id}))
//           .toList();
//     } catch (e) {
//       print('Error fetching booked seats: $e');
//       return [];
//     }
//   }

//   Future<TayangModel?> fetchHargaByTayangId(String tayangId) async {
//     try {
//       final doc = await _db
//         .collection('tayang')
//         .doc(tayangId).get();

//       if (doc.exists) {
//         return TayangModel.fromJson({...doc.data()!, 'id': doc.id});
//       }
//       return null; // difungsikan untuk mengambil harga dari tayang tertentu, bisa dipakai di halaman pilih kursi untuk menampilkan harga total
//     } catch (e) {
//       print('Error fetching harga: $e');
//       return null;
//     }
//   }

// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bixcinema/core/models/kursi_model.dart';

class KursiRepository {
  final _db = FirebaseFirestore.instance;

  // ✅ Fetch kursi booked HANYA untuk satu tayangId tertentu
  Future<Set<String>> fetchBookedSeatsByTayangId(String tayangId) async {
    try {
      if (tayangId.isEmpty) return {};

      final bookedSeats = <String>{};

      final snapshot = await _db
          .collection('kursi')
          .where('tayangId', isEqualTo: tayangId)  // ✅ isEqualTo, bukan arrayContains
          .where('status', isEqualTo: 'terisi')
          .get();

      // Tambahkan ke set dengan format "row_number"
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final row = data['row'] as String? ?? '';
        final number = data['number'] as int? ?? 0;
        if (row.isNotEmpty && number > 0) {
          bookedSeats.add('${row}_$number');
        }
      }

      return bookedSeats;
    } catch (e) {
      print('Error fetching booked seats: $e');
      return {};
    }
  }

  // ✅ HANYA disimpan setelah pembayaran berhasil
  Future<void> bookSeats({
    required String tayangId,  // ✅ Single string
    required String userId,
    required List<Map<String, dynamic>> seats,
  }) async {
    try {
      final batch = _db.batch();

      // Booking kursi HANYA untuk 1 tayangId
      for (final seat in seats) {
        final docRef = _db.collection('kursi').doc();
        batch.set(docRef, {
          'tayangId': tayangId,  // ✅ Single string
          'userId': userId,
          'row': seat['row'],
          'number': seat['number'],
          'status': 'terisi',
          'createdAt': DateTime.now(),
        });
      }

      await batch.commit();
      print('Seats booked successfully for tayangId: $tayangId');
    } catch (e) {
      print('Error booking seats: $e');
      rethrow;
    }
  }

  Future<List<KursiModel>> fetchBookedSeats(String tayangId) async {
    try {
      final snapshot = await _db
          .collection('kursi')
          .where('tayangId', isEqualTo: tayangId)
          .where('status', isEqualTo: 'terisi')
          .get();

      return snapshot.docs
          .map((doc) => KursiModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching booked seats: $e');
      return [];
    }
  }
}