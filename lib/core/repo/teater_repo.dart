import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bixcinema/core/models/teater_model.dart';

class TeaterRepository {
  final _db = FirebaseFirestore.instance;

  // Fetch semua teater
  Future<List<TeaterModel>> fetchAllTeaters() async {
    try {
      final snapshot = await _db.collection('teater').get();
      return snapshot.docs
          .map(
            (doc) => TeaterModel.fromJson({...doc.data(), 'teaterid': doc.id}),
          )
          .toList();
    } catch (e) {
      print('Error fetching teater: $e');
      return [];
    }
  }

  // Fetch teater berdasarkan kota
  Future<List<TeaterModel>> fetchTeaterByCity(String city) async {
    try {
      final snapshot = await _db
          .collection('teater')
          .where('kota', isEqualTo: city)
          .get();
      return snapshot.docs
          .map(
            (doc) => TeaterModel.fromJson({...doc.data(), 'teaterid': doc.id}),
          )
          .toList();
    } catch (e) {
      print('Error fetching teater by city: $e');
      return [];
    }
  }

  // Fetch daftar kota unik
  Future<List<String>> fetchUniqueCities() async {
    try {
      final snapshot = await _db.collection('teater').get();
      final cities = <String>{};
      for (var doc in snapshot.docs) {
        final kota = doc['kota'] as String?;
        if (kota != null && kota.isNotEmpty) {
          cities.add(kota);
        }
      }
      return cities.toList()..sort();
    } catch (e) {
      print('Error fetching cities: $e');
      return [];
    }
  }

  // Fetch teater detail by ID
  Future<TeaterModel?> fetchTeaterById(String teaterId) async {
    try {
      final doc = await _db.collection('teater').doc(teaterId).get();
      if (doc.exists) {
        return TeaterModel.fromJson({...doc.data()!, 'teaterid': doc.id});
      }
      return null;
    } catch (e) {
      print('Error fetching teater by id: $e');
      return null;
    }
  }
}
