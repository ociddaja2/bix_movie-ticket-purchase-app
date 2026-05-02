import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bixcinema/core/models/kursi_model.dart';

class KursiRepository {
  final _db = FirebaseFirestore.instance;

  // ✅ Fetch kursi booked HANYA untuk satu tayangId, movieId, tanggal, dan jam tertentu
  Future<Set<String>> fetchBookedSeatsByTayangId(
    String tayangId,
    String movieId,
    String tanggal,  // ✅ Tambah tanggal parameter (format: yyyy-MM-dd)
    String jam,  // ✅ Tambah jam parameter
  ) async {
    try {
      if (tayangId.isEmpty || movieId.isEmpty || tanggal.isEmpty || jam.isEmpty) return {};

      final bookedSeats = <String>{};

      final snapshot = await _db
          .collection('kursi')
          .where('tayangId', isEqualTo: tayangId)  // ✅ isEqualTo
          .where('movieId', isEqualTo: movieId)   // ✅ Filter by movieId
          .where('tanggal', isEqualTo: tanggal)   // ✅ Filter by tanggal juga
          .where('jam', isEqualTo: jam)           // ✅ Filter by jam juga
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
    required String movieId,   // ✅ Tambah movieId
    required String tanggal,   // ✅ Tambah tanggal
    required String jam,       // ✅ Tambah jam
    required String userId,
    required List<Map<String, dynamic>> seats,
  }) async {
    try {
      final batch = _db.batch();

      // Booking kursi HANYA untuk 1 tayangId + movieId + tanggal + jam
      for (final seat in seats) {
        final docRef = _db.collection('kursi').doc();
        batch.set(docRef, {
          'tayangId': tayangId,  // ✅ Single string
          'movieId': movieId,    // ✅ Simpan movieId
          'tanggal': tanggal,    // ✅ Simpan tanggal
          'jam': jam,            // ✅ Simpan jam
          'userId': userId,
          'row': seat['row'],
          'number': seat['number'],
          'status': 'terisi',
          'createdAt': DateTime.now(),
        });
      }

      await batch.commit();
      print('Seats booked successfully for tayangId: $tayangId, movieId: $movieId, tanggal: $tanggal, jam: $jam');
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