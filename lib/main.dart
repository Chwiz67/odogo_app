import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'views/landing_page.dart'; // Importing your new UI file

void main() async {
  // Ensure the Flutter environment is ready before doing anything else
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the auto-generated config from FlutterFire CLI
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const OdoGoApp());
}

class OdoGoApp extends StatelessWidget {
  const OdoGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OdoGo',
      // This tells the app to load the LandingPage first
      home: LandingPage(), 
    );
  }
}