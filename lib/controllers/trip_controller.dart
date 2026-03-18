import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odogo_app/controllers/auth_controller.dart';
import 'package:odogo_app/models/enums.dart';
import '../models/trip_model.dart';
import '../repositories/trip_repository.dart';

final tripRepositoryProvider = Provider((ref) => TripRepository());

// Stream for Drivers to see available rides
final pendingTripsProvider = StreamProvider<List<TripModel>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  // If the driver is currently busy, cut off the broadcast stream so they do not receive any more pending ride requests.
  if (currentUser?.mode == DriverMode.busy) {
    return Stream.value([]);
  }
  return ref.watch(tripRepositoryProvider).streamPendingTrips();
});

// Stream for Commuters to watch their specific active ride
final activeTripStreamProvider = StreamProvider.family<TripModel?, String>((
  ref,
  tripID,
) {
  // Changed to ref.watch for better reactivity
  return ref.watch(tripRepositoryProvider).streamTrip(tripID);
});

final tripControllerProvider =
    NotifierProvider<TripController, AsyncValue<void>>(() {
      return TripController();
    });

// 2. UPDATED to Notifier
class TripController extends Notifier<AsyncValue<void>> {
  // 3. Notifiers use build() to set the initial state instead of super()
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  // Getter to access the repository using the internal 'ref'
  TripRepository get _repository => ref.read(tripRepositoryProvider);

  Future<void> requestRide(TripModel trip) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createTrip(trip);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Driver: Accepts a pending ride
  Future<void> acceptRide(String tripID, String driverID) async {
    state = const AsyncValue.loading();
    try {
      // 1. Assign driver and confirm trip
      await _repository.updateTripData(tripID, {
        'status': TripStatus.confirmed.name,
        'driverID': driverID,
      });

      // Set the driver's mode to busy
      await ref.read(userRepositoryProvider).updateUser(driverID, {
        'mode': DriverMode.busy.name,
      });

      // Refresh local user state so the pendingTripsProvider instantly cuts off
      await ref.read(authControllerProvider.notifier).refreshUser();

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Driver: Marks the ride as picked up / in progress
  Future<void> startRide(String tripID) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateTripData(tripID, {
        'status': 'ongoing',
      });
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// User: Cancels the ride (while ensuring max 2 cancels in 15 mins)
  Future<void> cancelRide(String tripID) async {
    state = const AsyncValue.loading();
    try {
      // 1. Grab the current user's data
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception("User not authenticated.");

      // 2. Check the 15-minute rule
      final now = DateTime.now();
      final fifteenMinsAgo = now.subtract(const Duration(minutes: 15));
      
      // Filter the history to only count cancellations within the last 15 mins
      final recentCancels = currentUser.cancelHistory?.where((timestamp) {
        return timestamp.toDate().isAfter(fifteenMinsAgo);
      }).toList() ?? [];

      // Enforce the rule
      if (recentCancels.length >= 2) {
        throw Exception("You can cancel a maximum of 2 rides in 15 minutes.");
      }

      // 3. If they pass the check, update the trip status
      await _repository.updateTripData(tripID, {
        'status': TripStatus.cancelled.name,
      });

      final tripDoc = await FirebaseFirestore.instance.collection('trips').doc(tripID).get();
      if (!tripDoc.exists) throw Exception("Trip not found");
      final tripData = tripDoc.data() as Map<String, dynamic>;

      final assignedDriverID = tripData['driverID'];
      if (assignedDriverID != null) {
        await ref.read(userRepositoryProvider).updateUser(assignedDriverID, {
          'mode': DriverMode.online.name,
        });
      }

      // 4. Record this new cancellation timestamp to the user's profile
      recentCancels.add(Timestamp.fromDate(now));
      await ref.read(userRepositoryProvider).updateUser(currentUser.userID, {
        'cancelHistory': recentCancels,
      });

      // Refresh the local user state
      await ref.read(authControllerProvider.notifier).refreshUser();

      state = const AsyncValue.data(null);
    } catch (e, st) {
      // The UI will catch this error and show the "Please wait 15 minutes" message
      state = AsyncValue.error(e, st);
    }
  }

  /// User: Marks their side of the ride as complete
  Future<void> completeRide({required String tripID, required bool isDriver}) async {
    state = const AsyncValue.loading();
    try {
      // Updates either 'driverEnd' or 'commuterEnd' to true based on who called it
      await _repository.updateTripData(tripID, {
        isDriver ? 'driverEnd' : 'commuterEnd': true,
      });
      // RULE 3: Fetch the trip to check if BOTH parties have marked it as completed
      final tripDoc = await FirebaseFirestore.instance.collection('trips').doc(tripID).get();
      final tripData = tripDoc.data() as Map<String, dynamic>;
      
      final driverEnd = tripData['driverEnd'] ?? false;
      final commuterEnd = tripData['commuterEnd'] ?? false;

      // If both are true, finalize the ride and free the driver
      if (driverEnd && commuterEnd) {
        await _repository.updateTripData(tripID, {
          'status': TripStatus.completed.name,
        });

        // Revert the driver back to online so they can accept new rides
        final assignedDriverID = tripData['driverID'];
        if (assignedDriverID != null) {
          await ref.read(userRepositoryProvider).updateUser(assignedDriverID, {
            'mode': DriverMode.online.name,
          });
        }
      }

      // Sync the state (especially critical if this user is the driver transitioning back to online)
      await ref.read(authControllerProvider.notifier).refreshUser();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
