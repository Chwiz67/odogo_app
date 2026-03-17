import 'package:flutter/material.dart';

class EditWorkAddressScreen extends StatefulWidget {
  const EditWorkAddressScreen({super.key});

  @override
  State<EditWorkAddressScreen> createState() => _EditWorkAddressScreenState();
}

class _EditWorkAddressScreenState extends State<EditWorkAddressScreen> {
  // Controller to capture the work address, pre-filled with 'OAT'
  final TextEditingController _addressController = TextEditingController(text: 'OAT');

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    print("Saving new work address: ${_addressController.text}");
    
    // Show a quick success popup
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Work address updated successfully!'), 
        backgroundColor: Colors.green,
      ),
    );
    
    // Return to the Profile Page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
              backgroundColor: Color(0xFF66D2A3), // Standardized OdoGo Green
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
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
                  Icon(Icons.work, color: Color.fromARGB(255, 0, 0, 0), size: 32), // Kept your orange highlight
                  SizedBox(width: 12),
                  Text('Work Address', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Company Name / Address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}