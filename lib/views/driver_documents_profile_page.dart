import 'package:flutter/material.dart';

class DriverDocumentsScreen extends StatelessWidget {
  const DriverDocumentsScreen({super.key});

  final Color odogoGreen = const Color(0xFF66D2A3);

  // The required driver documents
  final List<Map<String, dynamic>> documents = const [
    {'title': 'Aadhar Card', 'icon': Icons.badge_outlined},
    {'title': 'Driving License', 'icon': Icons.contact_mail_outlined},
    {'title': 'Registration Certificate (RC)', 'icon': Icons.assignment_outlined},
    {'title': 'Pollution Certificate (PUC)', 'icon': Icons.eco_outlined},
    {'title': 'Insurance Certificate', 'icon': Icons.security_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // EXACT same AppBar as your EmailEditScreen
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
        child: Column(
          children: [
            // Body Header to match the Email page's style
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Icon(Icons.description_outlined, size: 40, color: Colors.black87),
                  SizedBox(width: 12),
                  Text(
                    'Documents', 
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            
            // The Document List
            Expanded(child: _buildDocumentList()),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              // Styled icon
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(documents[index]['icon'], color: Colors.black87),
              ),
              title: Text(
                documents[index]['title'], 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)
              ),
              // View AND Update options
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility, color: odogoGreen),
                    tooltip: 'View Document',
                    onPressed: () {
                      print("Viewing ${documents[index]['title']}");
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    tooltip: 'Update Document',
                    onPressed: () {
                      print("Updating ${documents[index]['title']}");
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 24, thickness: 1, color: Colors.black12),
          ],
        );
      },
    );
  }
}