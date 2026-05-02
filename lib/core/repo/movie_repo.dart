import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bixcinema/core/models/movie_model.dart';
import 'package:bixcinema/core/models/tayang_model.dart';

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

  // ✅ Fetch single movie by ID
  Future<MovieModel?> fetchMovieById(String movieId) async {
    if (movieId.isEmpty) return null;
    try {
      final doc = await _db.collection('movies').doc(movieId).get();
      if (doc.exists) {
        return MovieModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error fetching movie by id: $e');
      return null;
    }
  }

  // Fetch multiple movies by array of IDs
  Future<List<MovieModel>> fetchMoviesById(List<String> movieId) async {
    if (movieId.isEmpty) return [];
    
    final snapshot = await _db
        .collection('movies')
        .where(FieldPath.documentId, whereIn: movieId)
        .get();
    
    return snapshot.docs
        .map((doc) => MovieModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }
  
  // Ambil semua tayang yang menampilkan film dengan ID ini
  Future<List<TayangModel>> fetchTayangByMovieId(String movieId) async {
  try {
    final snapshot = await _db
        .collection('tayang')
        .where('movieId', arrayContains: movieId)
        .get();

    return snapshot.docs
        .map((doc) => TayangModel.fromJson({...doc.data(), 'tayangId': doc.id}))
        .toList();
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

// Ambil semua film dalam satu tayang tertentu
Future<List<String>> getMovieIdsFromTayang(String tayangId) async {
  try {
    final doc = await _db.collection('tayang').doc(tayangId).get();
    if (doc.exists) {
      return List<String>.from(doc['movieId'] ?? []);
    }
    return [];
  } catch (e) {
    print('Error: $e');
    return [];
  }
}
}