import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bixcinema/core/models/movie_model.dart';

class MovieRepository {
  final _db = FirebaseFirestore.instance;

  Future<List<MovieModel>> fetchAllMovies() async {
    final snapshot = await _db.collection('movies').get();
    return snapshot.docs
        .map((doc) => MovieModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  // Filter langsung dari Firestore
  Future<List<MovieModel>> fetchNowShowing() async {
    final snapshot = await _db
        .collection('movies')
        .where('status', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => MovieModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<List<MovieModel>> fetchComingSoon() async {
    final snapshot = await _db
        .collection('movies')
        .where('status', isEqualTo: false)
        .get();
    return snapshot.docs
        .map((doc) => MovieModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }
}