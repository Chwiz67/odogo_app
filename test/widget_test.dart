import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odogo_app/main.dart'; // Make sure this matches your project name

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OdoGoApp());

    // For now, we just verify the app builds without crashing.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}