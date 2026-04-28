import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bixcinema/core/models/kursi_model.dart';

class KursiRepository {
  final _db = FirebaseFirestore.instance;

  // Ambil kursi yang sudah di-booking untuk tayang tertentu
  Future<List<KursiModel>> fetchBookedSeatsByTayang(String tayangId) async {
    try {
      final snapshot = await _db
          .collection('kursi')
          .where('tayangId', isEqualTo: tayangId)
          .where('status', isEqualTo: 'booked') // Hanya booked seats
          .get();

      return snapshot.docs
          .map((doc) => KursiModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching booked seats: $e');
      return [];
    }
  }

  // Simpan booking ke Firebase
  Future<void> bookSeats(String tayangId, String userId, List<String> seatNames) async {
    try {
      final batch = _db.batch();
      
      for (final seatName in seatNames) {
        final docRef = _db.collection('kursi').doc();
        batch.set(docRef, {
          'tayangId': tayangId,
          'userId': userId,
          'namaKursi': seatName,
          'status': 'booked',
          'createdAt': DateTime.now(),
        });
      }
      
      await batch.commit();
      print('Seats booked successfully');
    } catch (e) {
      print('Error booking seats: $e');
      rethrow;
    }
  }
}