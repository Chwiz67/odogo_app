import 'package:flutter_test/flutter_test.dart';
import 'package:odogo_app/models/driver_telemetry_model.dart';
import 'package:odogo_app/repositories/telemetry_repository.dart';
import 'package:firebase_database/firebase_database.dart';

// --- MANUAL FAKES (No libraries needed) ---

class FakeDatabaseReference extends Fake implements DatabaseReference {
  String? lastPath;
  dynamic lastData;
  bool removed = false;

  @override
  DatabaseReference child(String path) => this;

  @override
  Future<void> set(Object? value, {Object? priority}) async {
    lastData = value;
  }

  @override
  Future<void> remove() async {
    removed = true;
  }
}

class FakeFirebaseDatabase extends Fake implements FirebaseDatabase {
  final fakeRef = FakeDatabaseReference();

  @override
  DatabaseReference ref([String? path]) {
    fakeRef.lastPath = path;
    return fakeRef;
  }
}

// --- THE TEST ---

void main() {
  late TelemetryRepository repository;
  late FakeFirebaseDatabase fakeDb;

  setUp(() {
    fakeDb = FakeFirebaseDatabase();
    repository = TelemetryRepository(database: fakeDb);
  });

  group('TelemetryRepository Tests', () {
    test('updateDriverLocation correctly sanitizes dots to commas', () async {
      final telemetry = DriverTelemetry(
        driverID: 'archit.test@iitk.ac.in',
        latitude: 26.4499,
        longitude: 80.3319,
        timestampMs: 1712160000,
      );

      await repository.updateDriverLocation(telemetry);

      // Verify the path was sanitized by your repository logic
      expect(
        fakeDb.fakeRef.lastPath,
        'drivers_locations/archit,test@iitk,ac,in',
      );

      // Verify data mapping matches your model fields
      final data = fakeDb.fakeRef.lastData as Map;
      expect(data['latitude'], 26.4499);
    });

    test('removeDriverLocation target the right path', () async {
      await repository.removeDriverLocation('driver_99');

      expect(fakeDb.fakeRef.lastPath, 'drivers_locations/driver_99');
      expect(fakeDb.fakeRef.removed, isTrue);
    });
  });
}
