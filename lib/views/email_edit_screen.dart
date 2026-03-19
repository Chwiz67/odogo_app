import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailEditScreen extends StatefulWidget {
  const EmailEditScreen({super.key});

  @override
  State<EmailEditScreen> createState() => _EmailEditScreenState();
}

class _EmailEditScreenState extends State<EmailEditScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmailFromDatabase();
  }

  // The new function to pull the email from your database
  Future<void> _fetchEmailFromDatabase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Option 1: Try pulling it directly from the Firestore 'users' collection
        // (Assumes your document ID is the user's UID)
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists && userDoc.data()!.containsKey('email')) {
          setState(() {
            _controller.text = userDoc.data()!['email'];
            _isLoading = false;
          });
          return;
        } 
        
        // Option 2: Fallback to the email stored directly in Firebase Auth
        if (user.email != null && user.email!.isNotEmpty) {
          setState(() {
            _controller.text = user.email!;
            _isLoading = false;
          });
          return;
        }
      }
      
      // If no email is found anywhere
      setState(() {
        _controller.text = "No email linked";
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _controller.text = "Error loading email";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        title: const Text('Inesh', style: TextStyle(color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF66D2A3), // OdoGo Green
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.email_outlined, size: 40, color: Colors.black87),
                  SizedBox(width: 12),
                  Text(
                    'Email', 
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // Show a loading spinner while fetching, then show the read-only TextField
              _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF66D2A3)))
                  : TextField(
                      controller: _controller,
                      readOnly: true, // This locks the keyboard from opening
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      style: const TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    
              // The Send OTP button has been completely removed!
            ],
          ),
        ),
      ),
    );
  }
}