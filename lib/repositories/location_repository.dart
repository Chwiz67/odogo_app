import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- MODELS ---
class LocationPoint {
  final double lat;
  final double lng;
  final String address;

  LocationPoint({required this.lat, required this.lng, required this.address});
}

class RouteDetails {
  final double distanceKm;
  final int durationMins;
  final double estimatedFare;

  RouteDetails({
    required this.distanceKm,
    required this.durationMins,
    required this.estimatedFare,
  });
}

// --- REPOSITORY ---
class LocationRepository {
  /// Fetches routing data between two points. 
  /// In the future, you will put your Google Maps API call here!
  Future<RouteDetails> getRoute(LocationPoint pickup, LocationPoint dropoff) async {
    // For now, if someone calls this without mocking it, it will throw an error
    throw UnimplementedError('Google Maps API not yet integrated');
  }
}