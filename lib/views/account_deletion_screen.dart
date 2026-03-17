import 'package:flutter/material.dart';
import 'account_deletion_otp_screen.dart'; // <-- ADDED THE OTP IMPORT

class AccountDeletionScreen extends StatelessWidget {
  const AccountDeletionScreen({super.key});

  // --- NEW OTP ROUTING LOGIC ---
  void _requestDeletionOtp(BuildContext context) {
    // In a real app, you would fetch their registered phone/email from your backend here
    const String userPhone = "+91 98765 43210"; 

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AccountDeletionOtpScreen(contactInfo: userPhone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221610), // Your deep dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // The essential Back Button
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
              backgroundColor: Color(0xFF2ECC71), // Matched to your new green
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.delete_forever, size: 80, color: Color(0xFF2ECC71)), // New bright green
              const SizedBox(height: 24),
              const Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: const Text(
                  'Are you sure? Once deleted, the account cannot be recovered',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71), // New bright green
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _requestDeletionOtp(context), // <-- NOW ROUTES TO THE SECURE OTP SCREEN!
                child: const Text('YES, DELETE ACCOUNT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white54, width: 2),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context), // Safely closes the popup
                child: const Text('NO, CANCEL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}