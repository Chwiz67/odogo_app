import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/booking_repository.dart';

// 1. Provide the Repository
final bookingRepositoryProvider = Provider((ref) => BookingRepository());

// 2. The Controller Provider (Manages a simple String state: 'idle', 'searching', 'accepted', 'timeout')
final scheduledBookingProvider = NotifierProvider<ScheduledBookingController, AsyncValue<String>>(() {
  return ScheduledBookingController();
});

class ScheduledBookingController extends Notifier<AsyncValue<String>> {
  BookingRepository get _repository => ref.read(bookingRepositoryProvider);
  
  Timer? _timeoutTimer; // We store the timer so we can cancel it if a driver accepts!

  @override
  AsyncValue<String> build() {
    return const AsyncValue.data('idle'); 
  }

  /// Starts the search and begins the countdown clock
  Future<void> startSearchForDriver(String rideId, {Duration timeout = const Duration(minutes: 5)}) async {
    state = const AsyncValue.data('searching');

    // Cancel any old timer just in case
    _timeoutTimer?.cancel();

    // Start the countdown
    _timeoutTimer = Timer(timeout, () async {
      // If the timer fires AND we are still searching, we hit a timeout!
      if (state.value == 'searching') {
        try {
          await _repository.updateRideStatus(rideId, 'timeout');
          state = const AsyncValue.data('timeout'); // Update UI to show "No drivers found"
        } catch (e, st) {
          state = AsyncValue.error(e, st);
        }
      }
    });
  }

  /// Call this if a driver accepts the ride BEFORE the timeout happens
  void driverAccepted() {
    _timeoutTimer?.cancel(); // Stop the countdown!
    state = const AsyncValue.data('accepted');
  }

  /// Clean up the timer to prevent memory leaks if the user leaves the screen
  void disposeTimer() {
    _timeoutTimer?.cancel();
  }
}