import 'package:flutter/material.dart';
import 'commuter_home.dart';
import 'driver_document_upload_screen.dart';

class SignUpPage extends StatefulWidget {
  final bool isDriver;

  const SignUpPage({super.key, required this.isDriver});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  String? _selectedGender;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Helper for error messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // The validation gauntlet
  void _handleContinue() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    // 1. Name Check (Now with character validation)
    if (name.isEmpty) {
      _showError('Please enter your full name.');
      return;
    }
    
    // REGEX: Only allows uppercase, lowercase, and spaces
    final nameRegex = RegExp(r"^[a-zA-Z\s]+$");
    if (!nameRegex.hasMatch(name)) {
      _showError('Name can only contain letters and spaces.');
      return;
    }

    if (name.length < 2) {
      _showError('Name is too short.');
      return;
    }

    // 2. Phone Number Check
    if (phone.isEmpty) {
      _showError('Please enter your phone number.');
      return;
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      _showError('Please enter a valid 10-digit phone number.');
      return;
    }

    // 3. Gender Check
    if (_selectedGender == null) {
      _showError('Please select your gender.');
      return;
    }

    // 4. DOB Check
    if (_selectedDate == null) {
      _showError('Please select your date of birth.');
      return;
    }

    // --- SUCCESS: ROUTING LOGIC ---
    if (widget.isDriver) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DriverDocumentUploadScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Welcome to OdoGo.'),
          backgroundColor: Color(0xFF66D2A3),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CommuterHomeScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF66D2A3), // Using OdoGo Green for the calendar
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Official Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/images/odogo_logo_black_bg.jpeg', height: 80),
              ),
              const SizedBox(height: 10),
              const Text('OdoGo', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                widget.isDriver ? 'Driver Registration' : 'Commuter Registration',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Enter Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: 'Enter Phone Number',
                  counterText: "",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Gender',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                initialValue: _selectedGender,
                items: ['Male', 'Female', 'Other', 'Prefer not to say']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const SizedBox(height: 15),

              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Date of Birth'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDate == null ? Colors.black54 : Colors.black87,
                        ),
                      ),
                      const Icon(Icons.calendar_month, color: Colors.black54),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _handleContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}