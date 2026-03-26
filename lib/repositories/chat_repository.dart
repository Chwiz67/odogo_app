import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Saves a new message to the specific ride's sub-collection
  Future<void> sendMessage(String rideId, Map<String, dynamic> messageData) async {
    try {
      await _firestore
          .collection('rides')
          .doc(rideId)
          .collection('messages')
          .add(messageData);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Opens a real-time stream of messages for a specific ride
  Stream<List<Map<String, dynamic>>> watchMessages(String rideId) {
    return _firestore
        .collection('rides')
        .doc(rideId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}