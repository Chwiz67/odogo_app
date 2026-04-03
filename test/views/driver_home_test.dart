import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odogo_app/views/driver_home_screen.dart';
import 'package:odogo_app/controllers/trip_controller.dart';
import 'package:odogo_app/controllers/auth_controller.dart';
import 'package:odogo_app/models/user_model.dart';
import 'package:odogo_app/models/enums.dart';

class DummyAuthController extends Notifier<AuthState>
    implements AuthController {
  @override
  AuthState build() => AuthInitial();
  @override
  Future<void> refreshUser() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter.baseflow.com/geolocator'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'checkPermission') return 1;
            if (methodCall.method == 'isLocationServiceEnabled') return true;
            return null;
          },
        );
  });

  testWidgets(
    'DriverHomeScreen renders Online/Offline toggle and Map successfully',
    (WidgetTester tester) async {
      // 1. ARRANGE: Create a fake driver who is currently online
      final mockDriver = UserModel(
        userID: 'driver_456',
        emailID: 'driver@test.com',
        name: 'Test Driver',
        phoneNo: '0987654321',
        gender: 'Female',
        dob: Timestamp.now(),
        role: UserRole.driver,
        mode: DriverMode.online,
      );

      // 2. ACT: Pump the screen
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(mockDriver),
            authControllerProvider.overrideWith(() => DummyAuthController()),
            driverTripsProvider.overrideWith((ref) => Stream.value([])),
            pendingTripsProvider.overrideWith(
              (ref) => Stream.value([]),
            ), // No incoming requests
            timeTickerProvider.overrideWith(
              (ref) => Stream.value(DateTime.now()),
            ),
          ],
          child: const MaterialApp(home: DriverHomeScreen()),
        ),
      );

      await tester.pump();

      // 3. ASSERT: Verify the UI rendered
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('OdoGo'), findsWidgets); // Logo text

      // Because mode is DriverMode.online, the UI should display "Offline" as the toggle option
      expect(find.text('Offline'), findsOneWidget);

      // Verify the empty state searching text rendered
      expect(find.text('Searching for rides...'), findsOneWidget);
    },
  );
}
