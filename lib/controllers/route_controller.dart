import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/location_repository.dart';

// 1. Provide the Repository
final locationRepositoryProvider = Provider((ref) => LocationRepository());

// 2. The Controller Provider (Manages the RouteDetails state)
// It returns null if no route is calculated yet.
final routeControllerProvider = NotifierProvider<RouteController, AsyncValue<RouteDetails?>>(() {
  return RouteController();
});

class RouteController extends Notifier<AsyncValue<RouteDetails?>> {
  
  LocationRepository get _repository => ref.read(locationRepositoryProvider);

  @override
  AsyncValue<RouteDetails?> build() {
    return const AsyncValue.data(null); // Initial state: No route selected
  }

  /// Calculates the route and updates the state with distance, time, and fare
  Future<void> calculateRoute(LocationPoint pickup, LocationPoint dropoff) async {
    // 1. Show a loading state (e.g., "Calculating route..." spinner)
    state = const AsyncValue.loading();
    
    try {
      // 2. Ask the repository (eventually Google Maps) for the route details
      final route = await _repository.getRoute(pickup, dropoff);
      
      // 3. Update the UI with the successful route and fare!
      state = AsyncValue.data(route);
    } catch (e, st) {
      // If the map API fails or internet drops, show an error
      state = AsyncValue.error(e, st);
    }
  }

  /// Clears the route if the user cancels their selection
  void clearRoute() {
    state = const AsyncValue.data(null);
  }
}