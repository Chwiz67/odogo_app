import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:odogo_app/views/waiting_for_driver_screen.dart';
import 'package:odogo_app/controllers/trip_controller.dart';
import 'package:odogo_app/models/trip_model.dart';
import 'package:odogo_app/models/enums.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter.baseflow.com/geolocator'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'checkPermission') return 2;
            if (methodCall.method == 'isLocationServiceEnabled') return true;
            return null;
          },
        );
  });

  testWidgets('WaitingForDriverScreen renders waiting state correctly', (
    WidgetTester tester,
  ) async {
    // 1. ARRANGE

    // Create a fake trip that is still looking for a driver
    final dummyTrip = TripModel(
      tripID: 'trip_waiting_1',
      commuterName: 'Test Commuter',
      commuterID: 'c1',
      commuterEnd: false,
      driverEnd: false,
      startLocName: 'Main Gate',
      endLocName: 'Library',
      status: TripStatus.pending,
      ridePIN: '1234',
      bookingTime: DateTime.now(),
      startTime: DateTime.now(),
    );

    // 2. ACT
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Feed the fake trip into the screen's listener
          activeTripStreamProvider(
            'trip_waiting_1',
          ).overrideWith((ref) => Stream.value(dummyTrip)),
        ],
        child: const MaterialApp(
          home: WaitingForDriverScreen(
            tripID: 'trip_waiting_1',
            pickupPoint: LatLng(26.5108, 80.2466),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    // 3. ASSERT
    expect(find.text('WAITING FOR DRIVER'), findsOneWidget);
    expect(find.text('Cancel Ride'), findsOneWidget);
    expect(find.text('TRIP STATUS'), findsOneWidget);

    // 4. CLEANUP
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
