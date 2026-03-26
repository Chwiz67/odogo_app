import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/driver_repository.dart';

// 1. Provide the Repository
final driverRepositoryProvider = Provider((ref) => DriverRepository());

// 2. MODERN SYNTAX: Use NotifierProvider instead of StateNotifierProvider
final driverStatusProvider = NotifierProvider<DriverStatusController, AsyncValue<bool>>(() {
  return DriverStatusController();
});

// 3. MODERN SYNTAX: Extend Notifier
class DriverStatusController extends Notifier<AsyncValue<bool>> {
  
  // Easily grab the repository using 'ref' inside the Notifier
  DriverRepository get _repository => ref.read(driverRepositoryProvider);

  // Notifiers require a build() method to set the starting state
  @override
  AsyncValue<bool> build() {
    // Drivers start offline (false) by default
    return const AsyncValue.data(false);
  }

  Future<void> toggleStatus(String uid, bool currentlyOnline) async {
    // 1. Tell the UI we are loading (spinner appears)
    state = const AsyncValue.loading();
    
    try {
      final newStatus = !currentlyOnline; // Flip the switch
      
      // 2. Tell the database to save the new status
      await _repository.updateOnlineStatus(uid, newStatus);
      
      // 3. Update the UI state with the new status
      state = AsyncValue.data(newStatus);
    } catch (e, st) {
      // If the internet drops, revert to the old status and show an error
      state = AsyncValue.error(e, st);
    }
  }
}