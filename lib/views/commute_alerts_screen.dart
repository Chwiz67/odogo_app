import 'package:flutter/material.dart';

class CommuteAlertsScreen extends StatefulWidget {
  const CommuteAlertsScreen({super.key});

  @override
  State<CommuteAlertsScreen> createState() => _CommuteAlertsScreenState();
}

class _CommuteAlertsScreenState extends State<CommuteAlertsScreen> {
  // Toggle state for daily route updates
  bool _notificationsEnabled = true;

  void _saveSettings() {
    print("Commute Alerts enabled: $_notificationsEnabled");
    
    // Show a quick success popup
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alert settings updated successfully!'), 
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
              backgroundColor: Color(0xFF66D2A3), // Standard OdoGo Green
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
                  Icon(Icons.notification_important, size: 36, color: Color.fromARGB(255, 0, 0, 0)), // Your orange highlight
                  SizedBox(width: 12),
                  Text('Commute Alerts', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 32),
              
              // Notification Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SwitchListTile(
                  title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: const Text('Enable daily route updates'),
                  value: _notificationsEnabled,
                  activeThumbColor: const Color.fromARGB(255, 0, 0, 0), // Matches the icon
                  onChanged: (bool value) {
                    setState(() => _notificationsEnabled = value);
                  },
                ),
              ),
              
              const Spacer(), // Pushes the save button to the bottom
              
              // Full-width save button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _saveSettings,
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