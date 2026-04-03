import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odogo_app/views/commuter_home.dart';
import 'package:odogo_app/controllers/trip_controller.dart';
import 'package:odogo_app/controllers/auth_controller.dart';
import 'package:odogo_app/models/user_model.dart';
import 'package:odogo_app/models/enums.dart';

// Create a safe dummy Auth Controller so the UI can refresh safely
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

    // Intercept the native Geolocator channel so it doesn't crash the headless test!
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter.baseflow.com/geolocator'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'checkPermission')
              return 1; // 1 = LocationPermission.whileInUse
            if (methodCall.method == 'isLocationServiceEnabled') return true;
            return null;
          },
        );
  });

  testWidgets(
    'CommuterHomeScreen renders Map and BottomNavigationBar successfully',
    (WidgetTester tester) async {
      //  Create a fake commuter
      final mockCommuter = UserModel(
        userID: 'commuter_123',
        emailID: 'commuter@test.com',
        name: 'Test Commuter',
        phoneNo: '1234567890',
        gender: 'Male',
        dob: Timestamp.now(),
        role: UserRole.commuter,
        mode: DriverMode.offline,
      );

      // Pump the screen wrapped in Riverpod overrides
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(mockCommuter),
            authControllerProvider.overrideWith(() => DummyAuthController()),
            commuterTripsProvider.overrideWith(
              (ref) => Stream.value([]),
            ), // Empty trip list
            timeTickerProvider.overrideWith(
              (ref) => Stream.value(DateTime.now()),
            ),
          ],
          child: const MaterialApp(home: CommuterHomeScreen()),
        ),
      );

      // Wait a frame for the UI to settle
      await tester.pump();

      // Verify the massive layout actually built!
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Bookings'), findsWidgets);
      expect(find.text('Profile'), findsWidgets);

      // Verify the Custom Map Overlays rendered
      expect(find.text('Schedule\nbookings'), findsOneWidget);
    },
  );
}
