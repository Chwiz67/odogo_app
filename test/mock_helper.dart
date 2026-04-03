import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/firebase_core',
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'Firebase#initializeCore') {
          return [
            {
              'name': '[DEFAULT]',
              'options': {
                'apiKey': '123',
                'appId': '123',
                'messagingSenderId': '123',
                'projectId': 'odogo-app-123', // Matches your project logic
              },
              'pluginConstants': {},
            },
          ];
        }
        if (methodCall.method == 'Firebase#initializeApp') {
          return {
            'name': methodCall.arguments['appName'],
            'options': methodCall.arguments['options'],
            'pluginConstants': {},
          };
        }
        return null;
      });
}
