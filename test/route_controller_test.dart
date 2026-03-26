import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odogo_app/controllers/route_controller.dart';
import 'package:odogo_app/repositories/location_repository.dart';

// Create a fake Google Maps muscle
class MockLocationRepository extends Mock implements LocationRepository {}

// Since we are passing custom objects (LocationPoint) into our mocked methods,
// we have to register "dummy" versions of them so mocktail knows how to handle them.
class FakeLocationPoint extends Fake implements LocationPoint {}

void main() {
  late MockLocationRepository mockRepo;
  late ProviderContainer container;

  // Run once before all tests
  setUpAll(() {
    registerFallbackValue(FakeLocationPoint());
  });

  setUp(() {
    mockRepo = MockLocationRepository();
    container = ProviderContainer(
      overrides: [
        locationRepositoryProvider.overrideWithValue(mockRepo),
        routeControllerProvider.overrideWith(() => RouteController()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('calculateRoute fetches details from Map API and updates state', () async {
    // --- ARRANGE ---
    final pickup = LocationPoint(lat: 26.4499, lng: 80.3319, address: 'Kanpur Central');
    final dropoff = LocationPoint(lat: 26.5123, lng: 80.2329, address: 'IIT Kanpur');
    
    // The fake response we expect from our fake Map API
    final fakeRoute = RouteDetails(
      distanceKm: 15.5,
      durationMins: 35,
      estimatedFare: 250.00,
    );

    // Program the fake database to return our fake route
    when(() => mockRepo.getRoute(any(), any()))
        .thenAnswer((_) async => fakeRoute);

    final controller = container.read(routeControllerProvider.notifier);

    // --- ACT ---
    await controller.calculateRoute(pickup, dropoff);

    // --- ASSERT ---
    // 1. Did it ask the Map API for the route?
    verify(() => mockRepo.getRoute(pickup, dropoff)).called(1);
    
    // 2. Did the state update with the correct fare and distance?
    final state = container.read(routeControllerProvider);
    expect(state.value?.distanceKm, 15.5);
    expect(state.value?.estimatedFare, 250.00);
  });

  test('clearRoute resets the state to null', () {
    final controller = container.read(routeControllerProvider.notifier);
    
    controller.clearRoute();
    
    final state = container.read(routeControllerProvider);
    expect(state, const AsyncValue<RouteDetails?>.data(null));
  });
}