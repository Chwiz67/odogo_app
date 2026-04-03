import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:odogo_app/repositories/trip_repository.dart';
import 'package:odogo_app/models/trip_model.dart';
import 'package:odogo_app/models/enums.dart';

void main() {
  late FakeFirebaseFirestore fakeDb;
  late TripRepository repository;

  // matches your exact model fields
  final tTripModel = TripModel(
    tripID: '12345',
    status: TripStatus.pending,
    commuterName: 'Archit',
    commuterID: 'user_99',
    startLocName: 'IIT Kanpur',
    endLocName: 'Hall 5',
    startTime: DateTime.now(),
    ridePIN: '1234',
    driverEnd: false,
    commuterEnd: false,
    bookingTime: DateTime.now(),
  );

  setUp(() {
    fakeDb = FakeFirebaseFirestore();
    repository = TripRepository(firestore: fakeDb);
  });

  group('TripRepository Logic Tests', () {
    test('createTrip saves data accurately to Firestore', () async {
      await repository.createTrip(tTripModel);

      final doc = await fakeDb.collection('trips').doc('12345').get();
      expect(doc.exists, true);
      expect(doc.data()?['commuterName'], 'Archit');
      expect(
        doc.data()?['startLoc'],
        'IIT Kanpur',
      ); // Your model maps startLocName to 'startLoc'
    });

    test('getTripData returns valid map from existing trip', () async {
      await fakeDb.collection('trips').doc('12345').set(tTripModel.toJson());

      final result = await repository.getTripData('12345');

      expect(result, isNotNull);
      expect(result?['status'], TripStatus.pending.name);
    });

    test(
      'streamPendingTrips correctly filters out non-pending trips',
      () async {
        // 1. Save a Pending trip
        await repository.createTrip(tTripModel);

        // 2. Save a Completed trip using copyWith
        await repository.createTrip(
          tTripModel.copyWith(tripID: '67890', status: TripStatus.completed),
        );

        final trips = await repository.streamPendingTrips().first;

        // Should only find the one pending trip
        expect(trips.length, 1);
        expect(trips.first.tripID, '12345');
      },
    );

    test('updateTripData only changes requested fields', () async {
      await repository.createTrip(tTripModel);

      // Update just the status
      await repository.updateTripData('12345', {
        'status': TripStatus.ongoing.name,
      });

      final doc = await fakeDb.collection('trips').doc('12345').get();
      expect(doc.data()?['status'], TripStatus.ongoing.name);
      // Verify other data like the PIN stayed the same
      expect(doc.data()?['ridePIN'], '1234');
    });
    test('runAcceptRideTransaction updates status atomically', () async {
      await fakeDb.collection('trips').doc('trip123').set({
        'status': 'pending',
        'driverID': null,
      });

      await repository.runAcceptRideTransaction(
        tripID: 'trip123',
        driverID: 'd_007',
        driverName: 'Bond',
        isScheduled: false,
      );

      final doc = await fakeDb.collection('trips').doc('trip123').get();
      expect(doc.data()?['status'], 'confirmed');
      expect(doc.data()?['driverID'], 'd_007');
    });

    test('cleanupOldTrips removes trips beyond 100 limit', () async {
      const userID = 'user1';
      // Create 105 "completed" trips
      for (int i = 0; i < 105; i++) {
        await fakeDb.collection('trips').doc('t_$i').set({
          'commuterID': userID,
          'status': 'completed',
          'bookingTime': DateTime.now().subtract(Duration(minutes: i)),
        });
      }

      await repository.cleanupOldTrips(userID, 'commuterID');

      final remaining = await fakeDb.collection('trips').get();
      // Should cap at 100
      expect(remaining.docs.length, 100);
    });
  });
}
