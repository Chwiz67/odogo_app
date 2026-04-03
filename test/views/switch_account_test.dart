import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odogo_app/views/switch_account_screen.dart';
import 'package:odogo_app/controllers/auth_controller.dart';
import 'package:odogo_app/models/user_model.dart';
import 'package:odogo_app/models/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Create a dummy controller that returns fake linked accounts
class DummyAuthController extends Notifier<AuthState>
    implements AuthController {
  @override
  AuthState build() => AuthInitial();
  @override
  Future<List<String>> getLinkedAccounts() async => [
    'primary@test.com',
    'alt@test.com',
  ];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('SwitchAccountScreen renders and displays linked accounts', (
    WidgetTester tester,
  ) async {
    // 1. ARRANGE
    final mockUser = UserModel(
      userID: '123',
      emailID: 'primary@test.com',
      name: 'Test User',
      phoneNo: '1234567890',
      gender: 'Male',
      dob: Timestamp.now(),
      role: UserRole.commuter,
      mode: DriverMode.offline,
    );

    // 2. ACT
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(mockUser),
          authControllerProvider.overrideWith(() => DummyAuthController()),
        ],
        child: const MaterialApp(home: SwitchAccountScreen()),
      ),
    );

    // Pump to clear the initial loading state (CircularProgressIndicator)
    await tester.pumpAndSettle();

    // 3. ASSERT: Verify the UI rendered our fake data!
    expect(find.text('Switch Account'), findsOneWidget);
    expect(find.text('primary@test.com'), findsOneWidget);
    expect(find.text('alt@test.com'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
