import 'package:cloud_firestore/cloud_firestore.dart';

class DriverRepository {
  final FirebaseFirestore _firestore;

  DriverRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _users => _firestore.collection('users');

  /// Updates the driver's online/offline status in the database
  Future<void> updateOnlineStatus(String uid, bool isOnline) async {
    try {
      await _users.doc(uid).update({'isOnline': isOnline});
    } catch (e) {
      throw Exception('Failed to update online status: $e');
    }
  }
}