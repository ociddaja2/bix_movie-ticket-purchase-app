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
            (doc) => TeaterModel.fromJson({...doc.data(), 'teaterId': doc.id}),
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
    print('Querying teater collection for city: $city');
    final snapshot = await _db
        .collection('teater')
        .where('kota', isEqualTo: city)
        .get();
    
    print('Found ${snapshot.docs.length} teater(s) for city: $city');
    
    return snapshot.docs
        .map((doc) {
          print('Teater doc: ${doc.data()}');
          return TeaterModel.fromJson({...doc.data(), 'teaterId': doc.id});
        })
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
    print('Total docs in teater collection: ${snapshot.docs.length}');
    
    final cities = <String>{};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      print('Doc data: $data');
      
      final kota = data['kota'] as String?;
      if (kota != null && kota.isNotEmpty) {
        cities.add(kota);
      }
    }
    print('Unique cities found: $cities');
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
        return TeaterModel.fromJson({...doc.data()!, 'teaterId': doc.id});
      }
      return null;
    } catch (e) {
      print('Error fetching teater by id: $e');
      return null;
    }
  }

  // Future<TayangModel?> fetchTeaterByCity(String city) async {
  //     final snapshot = await _db
  //         .collection('tayang')
  //         .where('kota', isEqualTo: city)
  //         .limit(1)
  //         .get();

  //     if (snapshot.docs.isNotEmpty) {
  //       return TayangModel.fromJson({
  //         ...snapshot.docs.first.data(),
  //         'tayangId': snapshot.docs.first.id
  //         });
  //     } 
  //     return null;
  //   }
  // }
}