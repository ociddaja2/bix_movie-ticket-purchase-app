import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bixcinema/core/models/user_model.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<void> updateUserName(String userId, String name) async {
    try {
      await _db.collection('users').doc(userId).update({'name': name});
    } catch (e) {
      print('Error updating user name: $e');
      rethrow;
    }
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    });
  }
}