import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:odogo_app/controllers/trip_controller.dart';
import 'package:odogo_app/repositories/trip_repository.dart';
import 'package:odogo_app/models/trip_model.dart';

// 1. CREATE THE MOCKS
class MockTripRepository extends Mock implements TripRepository {}

// We create a "Fake" TripModel so Mocktail knows how to handle custom objects
class FakeTripModel extends Fake implements TripModel {}

void main() {
  late MockTripRepository mockTripRepo;
  late ProviderContainer container;

  setUpAll(() {
    // Register the fake so mocktail's any() function works with TripModel
    registerFallbackValue(FakeTripModel());
  });

  setUp(() {
    mockTripRepo = MockTripRepository();

    container = ProviderContainer(
      overrides: [
        tripRepositoryProvider.overrideWithValue(mockTripRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TripController - Point 4: Confirm Booking (requestRide)', () {
    test('requestRide successfully calls repository to create a trip', () async {
      // --- ARRANGE ---
      // Tell the mock database to just return a successful empty future when asked to create a trip
      when(() => mockTripRepo.createTrip(any())).thenAnswer((_) async {});

      final controller = container.read(tripControllerProvider.notifier);
      final dummyTrip = FakeTripModel();

      // --- ACT ---
      // Call the exact method from your trip_controller.dart
      await controller.requestRide(dummyTrip);

      // --- ASSERT ---
      // 1. Verify the controller successfully passed the trip to the repository
      verify(() => mockTripRepo.createTrip(any())).called(1);
      
      // 2. Verify the controller state went back to Data (not loading/error) after finishing
      final state = container.read(tripControllerProvider);
      expect(state.isLoading, false);
      expect(state.hasError, false);
    });
    // ------------------------------------------------------------------
    // POINT 4 EDGE CASE: Booking Fails (No Internet / DB Error)
    // ------------------------------------------------------------------
    test('requestRide sets state to AsyncError when database throws an exception', () async {
    
      final dbError = Exception('No Internet Connection or Database Timeout');
      
     
      when(() => mockTripRepo.createTrip(any())).thenThrow(dbError);

      final controller = container.read(tripControllerProvider.notifier);
      final dummyTrip = FakeTripModel();

      
      await controller.requestRide(dummyTrip);

      final state = container.read(tripControllerProvider);
      
      expect(state.isLoading, false);
      
      expect(state.hasError, true);
      expect(state.error, dbError);
    });
  });
}