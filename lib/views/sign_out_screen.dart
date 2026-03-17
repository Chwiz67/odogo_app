import 'package:flutter/material.dart';
// 1. Update this import to match your landing page file path
import 'landing_page.dart'; 

class SignOutScreen extends StatelessWidget {
  const SignOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Inesh', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF66D2A3),
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign Out', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(width: 8),
                  Icon(Icons.power_settings_new, size: 36, color: Colors.black),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Are you Sure?', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _buildButton(context, 'NO', color: const Color(0xFF1E293B))),
                  const SizedBox(width: 20),
                  Expanded(child: _buildButton(context, 'YES', color: const Color(0xFF22C55E))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, {required Color color}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: () {
        if (text == 'YES') {
          // 2. Clear the entire stack and go to Landing Page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LandingPage()),
            (route) => false, // This condition removes all previous routes
          );
        } else {
          Navigator.pop(context);
        }
      },
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}