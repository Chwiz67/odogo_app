import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:odogo_app/services/contact_launcher_service.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  late MockUrlLauncher mockLauncher;

  setUpAll(() {
    registerFallbackValue(FakeLaunchOptions());
  });

  setUp(() {
    mockLauncher = MockUrlLauncher();
    UrlLauncherPlatform.instance = mockLauncher;
  });

  // Helper to provide a BuildContext for SnackBar tests
  Widget createTestApp(Future<void> Function(BuildContext) action) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => action(context),
            child: const Text('Tap'),
          ),
        ),
      ),
    );
  }

  group('ContactLauncherService Exhaustive Tests', () {
    testWidgets('callNumber succeeds and sanitizes input', (tester) async {
      when(
        () => mockLauncher.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);
      await tester.pumpWidget(
        createTestApp(
          (c) => ContactLauncherService.callNumber(c, '+91 98-765 43210'),
        ),
      );
      await tester.tap(find.text('Tap'));
      await tester.pumpAndSettle();
      verify(
        () => mockLauncher.launchUrl('tel:+919876543210', any()),
      ).called(1);
    });

    testWidgets('callNumber shows SnackBar if app fails to launch', (
      tester,
    ) async {
      when(
        () => mockLauncher.launchUrl(any(), any()),
      ).thenAnswer((_) async => false);
      await tester.pumpWidget(
        createTestApp((c) => ContactLauncherService.callNumber(c, '123')),
      );
      await tester.tap(find.text('Tap'));
      await tester.pump();
      expect(find.text('Could not open phone app.'), findsOneWidget);
    });

    testWidgets('callNumber aborts on empty string', (tester) async {
      await tester.pumpWidget(
        createTestApp((c) => ContactLauncherService.callNumber(c, 'abcd')),
      );
      await tester.tap(find.text('Tap'));
      await tester.pump();
      expect(find.text('Phone number not available.'), findsOneWidget);
      verifyNever(() => mockLauncher.launchUrl(any(), any()));
    });

    testWidgets('smsNumber succeeds and sanitizes input', (tester) async {
      when(
        () => mockLauncher.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);
      await tester.pumpWidget(
        createTestApp(
          (c) => ContactLauncherService.smsNumber(c, '(123) 456 7890'),
        ),
      );
      await tester.tap(find.text('Tap'));
      await tester.pumpAndSettle();
      verify(() => mockLauncher.launchUrl('sms:1234567890', any())).called(1);
    });

    testWidgets('smsNumber shows SnackBar if app fails to launch', (
      tester,
    ) async {
      when(
        () => mockLauncher.launchUrl(any(), any()),
      ).thenAnswer((_) async => false);
      await tester.pumpWidget(
        createTestApp((c) => ContactLauncherService.smsNumber(c, '123')),
      );
      await tester.tap(find.text('Tap'));
      await tester.pump();
      expect(find.text('Could not open messages app.'), findsOneWidget);
    });
  });
}
