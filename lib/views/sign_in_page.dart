import 'package:flutter/material.dart';
import '../services/email_link_auth_service.dart';
import 'otp_page.dart';

class SignInPage extends StatefulWidget {
  final bool isDriver;
  final bool isSignUp; // We added this flag!

  const SignInPage({super.key, required this.isDriver, required this.isSignUp});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  String _extractErrorMessage(Object error) {
    if (error is StateError) {
      return error.message;
    }

    final raw = error.toString();
    if (raw.startsWith('Exception: ')) {
      return raw.replaceFirst('Exception: ', '').trim();
    }

    return raw;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Helper function to keep the validation logic clean
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _handleContinue() async {
    final email = _emailController.text.trim();

    // 1. Check if empty
    if (email.isEmpty) {
      _showError('Please enter an email address.');
      return;
    }

    // 2. Check for accidental spaces
    if (email.contains(' ')) {
      _showError('Email cannot contain spaces.');
      return;
    }

    // 3. Check for the @ symbol
    if (!email.contains('@')) {
      _showError('Email must contain an "@" symbol.');
      return;
    }

    // 4. Strict check for allowed domains
    if (!email.endsWith('.com') && !email.endsWith('.ac.in')) {
      _showError('Email must end with .com or .ac.in');
      return;
    }

    // 5. Final Regex check to ensure structural validity
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|ac\.in)$');
    if (!emailRegex.hasMatch(email)) {
      _showError('Please enter a valid email format.');
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      await EmailOtpAuthService.instance.sendOtp(email: email);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpPage(
            isDriver: widget.isDriver,
            email: email,
            isSignUp: widget.isSignUp,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showError(_extractErrorMessage(e));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Updated to your official black background logo with rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/images/odogo_logo.png', height: 80),
              ),
              const SizedBox(height: 10),
              const Text(
                'OdoGo',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 10),
              // Dynamic text based on the flow
              Text(
                widget.isSignUp 
                    ? (widget.isDriver ? 'Driver Sign Up' : 'Commuter Sign Up')
                    : (widget.isDriver ? 'Driver Sign In' : 'Commuter Sign In'),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Continue', style: TextStyle(fontSize: 18)),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}