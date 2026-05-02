import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bixcinema/core/models/pembayaran_model.dart';

class PembayaranRepository {
  final _db = FirebaseFirestore.instance;

  // ✅ Buat booking pembayaran (pending)
  Future<String> createPembayaran({
    required String userId,
    required String tayangId,
    required String movieId,  // ✅ Tambah movieId
    required String tanggal,  // ✅ Tambah tanggal (format: yyyy-MM-dd)
    required String jam,      // ✅ Tambah jam
    required List<Map<String, dynamic>> seats, // [{row, number}, ...]
    required int harga,
  }) async {
    try {
      final docRef = _db.collection('pembayaran').doc();
      
      final totalHarga = seats.length * harga;
      
      await docRef.set({
        'id': docRef.id,
        'userId': userId,
        'tayangId': tayangId,
        'movieId': movieId,  // ✅ Simpan movieId
        'tanggal': tanggal,  // ✅ Simpan tanggal
        'jam': jam,          // ✅ Simpan jam
        'biayaLayanan': 5000,  // Contoh biaya layanan tetap
        'seats': seats,  // Simpan kursi yang dipesan
        'harga': harga,
        'totalHarga': totalHarga,
        'status': 'pending',  // Status awal: pending
        'createdAt': DateTime.now(),
      });

      print('Pembayaran created: ${docRef.id}');
      return docRef.id; // Return booking ID untuk reference
    } catch (e) {
      print('Error creating pembayaran: $e');
      rethrow;
    }
  }

  // ✅ Update status pembayaran ke "paid"
  Future<void> confirmPembayaran(String pembayaranId) async {
    try {
      await _db.collection('pembayaran').doc(pembayaranId).update({
        'status': 'paid',
        'createdAt': DateTime.now(),
        'paidAt': DateTime.now(),
      });

      print('Pembayaran confirmed: $pembayaranId');
    } catch (e) {
      print('Error confirming pembayaran: $e');
      rethrow;
    }
  }

  // Fetch pembayaran by ID
  Future<Map<String, dynamic>?> getPembayaran(String pembayaranId) async {
    try {
      final doc = await _db.collection('pembayaran').doc(pembayaranId).get();
      return doc.data();


    } catch (e) {
      print('Error fetching pembayaran: $e');
      return null;
    }
  }

  Future<dynamic> getUserPaidPembayaran(String userId) async {
    try {
      final snapshot = await _db
          .collection('pembayaran')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'paid')
          .get();

      return snapshot.docs
          .map((doc) => PembayaranModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching user pembayaran: $e');
      return [];
    }
  }

}