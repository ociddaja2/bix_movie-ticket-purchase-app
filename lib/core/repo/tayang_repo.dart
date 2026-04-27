// lib/core/repo/tayang_repo.dart
// import 'package:bixcinema/core/models/movie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bixcinema/core/models/tayang_model.dart';


class TayangRepository {
  final _db = FirebaseFirestore.instance;

  // Ambil semua tayang untuk film tertentu
  Future<List<TayangModel>> fetchTayangByMovieId(String movieId, String selectedTeaterId) async {
    try {
      final snapshot = await _db
          .collection('tayang')
          .where('movieId', arrayContains: movieId)
          .get();

      final List<TayangModel> tayangList = [];

      for (var doc in snapshot.docs) {
        final data = {...doc.data(), 'tayangId' : doc.id}; 
        final teaterId = data['teaterId'] as String? ?? '';

        if (teaterId != '') {
          final teaterDoc = await _db.collection('teater').doc(teaterId).get();
          if (teaterDoc.exists) {
            data['namaTeater'] = {...teaterDoc.data()!, 'teaterId': teaterDoc.id};
          }
        }

        tayangList.add(TayangModel.fromJson(data));
      }
      return tayangList;
    


      // return snapshot.docs
      //     .map(
      //       (doc) => TayangModel.fromJson({...doc.data(), 'tayangId': doc.id}),
      //     )
      //     .toList();
    } catch (e) {
      print('Error fetching tayang: $e');
      return [];
    }
  }

  // Ambil tayang untuk film tertentu pada tanggal spesifik
  Future<List<TayangModel>> fetchTayangByDate(
    String movieId,
    String tanggal,
  ) async {
    try {
      final snapshot = await _db
          .collection('tayang')
          .where('movieId', isEqualTo: movieId)
          .where('tanggal', isEqualTo: tanggal)
          .get();

      return snapshot.docs
          .map(
            (doc) => TayangModel.fromJson({...doc.data(), 'tayangId': doc.id}),
          )
          .toList();
    } catch (e) {
      print('Error fetching tayang by date: $e');
      return [];
    }
  }

  // Ambil tayang untuk film tertentu di teater tertentu
  Future<List<TayangModel>> fetchTayangByMovieAndTeater(
    String movieId,
    String teaterId,
  ) async {
    try {
      final snapshot = await _db
          .collection('tayang')
          .where('movieId', arrayContains: movieId)
          .where('teaterId', isEqualTo: teaterId)
          .get();

      return snapshot.docs
          .map(
            (doc) => TayangModel.fromJson({...doc.data(), 'tayangId': doc.id}),
          )
          .toList();
    } catch (e) {
      print('Error fetching tayang by movie and teater: $e');
      return [];
    }
  }

  // Ambil semua tayang untuk teater tertentu
  Future<List<TayangModel>> fetchTayangByTeater(String teaterId) async {
    try {
      final snapshot = await _db
          .collection('tayang')
          .where('teaterId', isEqualTo: teaterId)
          .get();

      return snapshot.docs
          .map(
            (doc) => TayangModel.fromJson({...doc.data(), 'tayangId': doc.id}),
          )
          .toList();
    } catch (e) {
      print('Error fetching tayang by teater: $e');
      return [];
    }
  }

  // Ambil semua tayang
  Future<List<TayangModel>> fetchAllTayang() async {
    try {
      final snapshot = await _db.collection('tayang').get();

      return snapshot.docs
          .map(
            (doc) => TayangModel.fromJson({...doc.data(), 'tayangId': doc.id}),
          )
          .toList();
    } catch (e) {
      print('Error fetching all tayang: $e');
      return [];
    }
  }

  // Ambil tayang berdasarkan ID
  // Future<TayangModel?> fetchTayangById(String tayangId) async {
  //   try {
  //     final doc = await _db.collection('tayang').doc(tayangId).get();
  //     if (doc.exists) {
  //       return TayangModel.fromJson({...doc.data()!, 'tayangId': doc.id});
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error fetching tayang by id: $e');
  //     return null;
  //   }
  // }

  // // fetch film yang tayang di teater tertentu
  // Future<List<MovieModel>> fetchMoviesByTeater(String teaterId) async {
  //   try {

  //     final tayangSnapshot = await _db
  //         .collection('tayang')
  //         .where('teaterId', isEqualTo: teaterId)
  //         .get();

  //     Set<String> movieId = {};
  //     for (var doc in tayangSnapshot.docs) {
  //       final data = doc.data();
  //       final movieId = data['movieId'] as String? ?? '';
  //       movieId.addAll(movie);
  //     }

  //     if (movieId.isEmpty) return [];

  //     final moviesSnapshot = await _db
  //         .collection('movies')
  //         .where(FieldPath.documentId, whereIn: movieId.toList())
  //         .get();

  //     return moviesSnapshot.docs
  //         .map((doc) => MovieModel.fromJson({...doc.data(), 'id': doc.id}))
  //         .toList();
  //   } catch (e) {
  //     print('Error fetching movies by teater: $e');
  //     return [];
  //   }
  // }

  
    

}
