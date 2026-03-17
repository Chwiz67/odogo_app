import 'package:flutter/material.dart';

class LocationSharingScreen extends StatefulWidget {
  const LocationSharingScreen({super.key});

  @override
  State<LocationSharingScreen> createState() => _LocationSharingScreenState();
}

class _LocationSharingScreenState extends State<LocationSharingScreen> {
  // Toggle state for location sharing
  bool _isSharingLocation = true;

  void _saveSettings() {
    print("Location Sharing set to: $_isSharingLocation");
    
    // Show a quick success popup
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location settings saved successfully!'), 
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
        backgroundColor: Colors.black, // Matched to your standard theme
        elevation: 0,
        toolbarHeight: 80,
        // The essential Back Button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF66D2A3), // Standard OdoGo Green
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Inesh',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location Sharing',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SwitchListTile(
                  value: _isSharingLocation,
                  activeThumbColor: const Color.fromARGB(255, 0, 0, 0), // Kept your orange accent
                  onChanged: (bool value) {
                    setState(() => _isSharingLocation = value);
                  },
                  title: const Text('Share my Location', style: TextStyle(fontWeight: FontWeight.bold)),
                  secondary: const Icon(Icons.my_location, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Kept your orange accent
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Save Settings', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}