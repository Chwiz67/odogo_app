import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileOtpVerificationScreen extends StatefulWidget {
  final String contactInfo; // This will hold the new email or phone number

  const ProfileOtpVerificationScreen({super.key, required this.contactInfo});

  @override
  State<ProfileOtpVerificationScreen> createState() => _ProfileOtpVerificationScreenState();
}

class _ProfileOtpVerificationScreenState extends State<ProfileOtpVerificationScreen> {
  final Color odogoGreen = const Color(0xFF66D2A3);

  // Focus nodes and controllers for the 4 PIN boxes
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) { node.dispose(); }
    for (var controller in _controllers) { controller.dispose(); }
    super.dispose();
  }

  void _verifyAndSave() {
    String otp = _controllers.map((c) => c.text).join();
    
    if (otp.length == 4) {
      FocusScope.of(context).unfocus(); // Hide keyboard

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification successful! Profile updated.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Pop twice: First closes this OTP screen, Second closes the Edit screen 
      // This drops them perfectly back onto the main Profile tab!
      Navigator.of(context)..pop()..pop(); 
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 4-digit code.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Verification', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Enter Verification Code',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Text(
                'We have sent a 4-digit code to:\n${widget.contactInfo}',
                style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 40),

              // The 4-Digit OTP Input Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _buildOtpBox(index)),
              ),
              
              const SizedBox(height: 40),

              // Verify Button
              ElevatedButton(
                onPressed: _verifyAndSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Sleek black to match profile theme
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Verify & Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              
              const SizedBox(height: 24),
              
              // Resend Code Option
              Center(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('New code sent!'), backgroundColor: odogoGreen),
                    );
                  },
                  child: Text(
                    'Didn\'t receive a code? Resend',
                    style: TextStyle(color: odogoGreen, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // The premium auto-shifting PIN box UI
  Widget _buildOtpBox(int index) {
    return Container(
      width: 65, 
      height: 75,
      decoration: BoxDecoration(
        color: Colors.grey[100], 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: Colors.grey.shade300, width: 2)
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < 3) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else {
                FocusScope.of(context).unfocus(); // Close keyboard on last digit
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