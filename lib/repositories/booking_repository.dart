import 'package:cloud_firestore/cloud_firestore.dart';

class BookingRepository {
  final FirebaseFirestore _firestore;

  BookingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Updates the status of a ride (e.g., 'timeout', 'accepted', 'cancelled')
  Future<void> updateRideStatus(String rideId, String status) async {
    try {
      await _firestore.collection('rides').doc(rideId).update({'status': status});
    } catch (e) {
      throw Exception('Failed to update ride status: $e');
    }
  }
}