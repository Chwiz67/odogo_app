import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'landing_page.dart';

class AccountDeletionOtpScreen extends StatefulWidget {
  final String contactInfo;

  const AccountDeletionOtpScreen({super.key, required this.contactInfo});

  @override
  State<AccountDeletionOtpScreen> createState() => _AccountDeletionOtpScreenState();
}

class _AccountDeletionOtpScreenState extends State<AccountDeletionOtpScreen> {
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) { node.dispose(); }
    for (var controller in _controllers) { controller.dispose(); }
    super.dispose();
  }

  void _verifyAndDelete() {
    String otp = _controllers.map((c) => c.text).join();
    
    if (otp.length == 4) {
      FocusScope.of(context).unfocus(); 

      // 1. Grab messenger before wiping the navigation stack
      final messenger = ScaffoldMessenger.of(context);

      // 2. NUKE THE STACK AND PUSH THE LANDING PAGE
      // This ensures they are completely logged out and cannot hit the "back" button
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()), // <-- Routes directly to your LandingPage class!
        (route) => false,
      );

      // 3. Show the final confirmation
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Account permanently deleted.'),
          backgroundColor: Colors.red, // Keeps the red warning theme for the popup
          duration: Duration(seconds: 4),
        ),
      );
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 4-digit code.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221610), // Matched to your dark theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Final Verification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.security, size: 64, color: Color(0xFF2ECC71)), // Matched green
              const SizedBox(height: 24),
              const Text(
                'Verify Deletion',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Enter the 4-digit code sent to:\n${widget.contactInfo}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.redAccent, height: 1.5, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),

              // The 4-Digit OTP Input Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _buildOtpBox(index)),
              ),
              
              const SizedBox(height: 40),

              // Final Destructive Button
              ElevatedButton(
                onPressed: _verifyAndDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71), // Matched your green button
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('CONFIRM DELETION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 65, height: 75,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1), // Dark red tint
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: Colors.red.withOpacity(0.5), width: 2)
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), // White text for dark mode
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < 3) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else {
                FocusScope.of(context).unfocus(); 
              }
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
        ),
      ),
    );
  }
}