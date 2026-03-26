import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odogo_app/controllers/scheduled_booking_controller.dart';
import 'package:odogo_app/repositories/booking_repository.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late MockBookingRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockBookingRepository();
    container = ProviderContainer(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(mockRepo),
        scheduledBookingProvider.overrideWith(() => ScheduledBookingController()),
      ],
    );
  });

  tearDown(() {
    // Clean up the timer after every test
    container.read(scheduledBookingProvider.notifier).disposeTimer();
    container.dispose();
  });

  // --- TEST 1: The Sad Path (Timeout happens) ---
  test('startSearch triggers timeout if no driver accepts', () async {
    const rideId = 'ride_999';

    // Program the database to accept the timeout update
    when(() => mockRepo.updateRideStatus(rideId, 'timeout')).thenAnswer((_) async {});

    final controller = container.read(scheduledBookingProvider.notifier);

    // ACT: Start search with a 50 millisecond timeout
    await controller.startSearchForDriver(rideId, timeout: const Duration(milliseconds: 50));

    // The state should instantly be 'searching'
    expect(container.read(scheduledBookingProvider).value, 'searching');

    // Wait 100 milliseconds to guarantee the timer goes off
    await Future.delayed(const Duration(milliseconds: 100));

    // ASSERT: Did it tell the database it timed out?
    verify(() => mockRepo.updateRideStatus(rideId, 'timeout')).called(1);

    // ASSERT: Did the UI state update?
    expect(container.read(scheduledBookingProvider).value, 'timeout');
  });

  // --- TEST 2: The Happy Path (Driver accepts) ---
  test('driverAccepted cancels the timer and prevents timeout', () async {
    const rideId = 'ride_999';
    final controller = container.read(scheduledBookingProvider.notifier);

    // ACT: Start search
    await controller.startSearchForDriver(rideId, timeout: const Duration(milliseconds: 50));

    // Driver accepts it instantly!
    controller.driverAccepted();

    // Wait 100 milliseconds to see if the timer still fires (it shouldn't)
    await Future.delayed(const Duration(milliseconds: 100));

    // ASSERT: The database should NEVER have been told to timeout
    verifyNever(() => mockRepo.updateRideStatus(rideId, 'timeout'));

    // ASSERT: The state should safely be 'accepted'
    expect(container.read(scheduledBookingProvider).value, 'accepted');
  });
}