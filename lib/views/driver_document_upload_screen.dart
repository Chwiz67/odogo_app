// import 'package:flutter/material.dart';
// // import 'sign_in_page.dart'; // We will route them back to sign in pending approval
// import 'driver_home_screen.dart';

// class DriverDocumentUploadScreen extends StatefulWidget {
//   const DriverDocumentUploadScreen({super.key});

//   @override
//   State<DriverDocumentUploadScreen> createState() => _DriverDocumentUploadScreenState();
// }

// class _DriverDocumentUploadScreenState extends State<DriverDocumentUploadScreen> {
//   // Keeps track of which documents the user has "uploaded"
//   final Set<String> _uploadedDocs = {};

//   final List<String> _requiredDocs = [
//     'Aadhaar Card',
//     'Driving License',
//     'Registration Certificate',
//     'Pollution Certificate',
//     'Insurance Certificate',
//   ];

//   void _toggleUpload(String title) {
//     setState(() {
//       if (_uploadedDocs.contains(title)) {
//         _uploadedDocs.remove(title);
//       } else {
//         _uploadedDocs.add(title);
//       }
//     });
//   }

//   void _submitDocuments() {
//     if (_uploadedDocs.length < _requiredDocs.length) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please upload all required documents first.'),
//           backgroundColor: Colors.red
//         ),
//       );
//       return;
//     }

//     // Show Success Message
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Registration Complete! Welcome to OdoGo.'),
//         backgroundColor: Color(0xFF66D2A3), // OdoGo Green
//       ),
//     );

//     // Clear the whole signup stack and drop them straight into the Driver Home map!
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const DriverHomeScreen()),
//       (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool allDocsUploaded = _uploadedDocs.length == _requiredDocs.length;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Driver Registration', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 32),
//             const Text(
//               'Upload the required\ndocuments here',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Tap a document below to upload',
//               style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
//             ),

//             // Document List
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//                 itemCount: _requiredDocs.length,
//                 itemBuilder: (context, index) {
//                   return _buildUploadItem(_requiredDocs[index]);
//                 },
//               ),
//             ),

//             // Continue Button
//             Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: allDocsUploaded ? _submitDocuments : null, // Disables button if not ready
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF66D2A3),
//                     disabledBackgroundColor: Colors.grey[200],
//                     foregroundColor: Colors.black,
//                     disabledForegroundColor: Colors.grey[500],
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     elevation: 0,
//                   ),
//                   child: const Text('Submit Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUploadItem(String title) {
//     bool isUploaded = _uploadedDocs.contains(title);

//     return GestureDetector(
//       onTap: () => _toggleUpload(title),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         decoration: BoxDecoration(
//           color: isUploaded ? const Color(0xFF66D2A3).withOpacity(0.1) : Colors.grey[50],
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isUploaded ? const Color(0xFF66D2A3) : Colors.grey[300]!,
//             width: isUploaded ? 2.0 : 1.5,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 color: isUploaded ? Colors.black : Colors.grey[800],
//                 fontSize: 16,
//                 fontWeight: isUploaded ? FontWeight.bold : FontWeight.w600,
//               ),
//             ),
//             Icon(
//               isUploaded ? Icons.check_circle : Icons.upload_file,
//               color: isUploaded ? const Color(0xFF66D2A3) : Colors.grey[400],
//               size: 26,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Added Riverpod
import '../controllers/auth_controller.dart';
import '../models/vehicle_model.dart';

// 2. Upgraded to ConsumerStatefulWidget
class DriverDocumentUploadScreen extends ConsumerStatefulWidget {
  const DriverDocumentUploadScreen({super.key});

  @override
  ConsumerState<DriverDocumentUploadScreen> createState() =>
      _DriverDocumentUploadScreenState();
}

class _DriverDocumentUploadScreenState
    extends ConsumerState<DriverDocumentUploadScreen> {
  final Set<String> _uploadedDocs = {};
  bool _isSubmitting = false;

  final List<String> _requiredDocs = [
    'Aadhaar Card',
    'Driving License',
    'Registration Certificate',
    'Pollution Certificate',
    'Insurance Certificate',
  ];

  void _toggleUpload(String title) {
    setState(() {
      if (_uploadedDocs.contains(title)) {
        _uploadedDocs.remove(title);
      } else {
        _uploadedDocs.add(title);
      }
    });
  }

  Future<void> _submitDocuments() async {
    if (_uploadedDocs.length < _requiredDocs.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload all required documents first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception("User not found");

      // THE BACKEND LINK:
      // In reality, you would upload the files to Firebase Storage here and get the URLs back.
      // For now, we populate your VehicleModel with placeholder URLs.
      final vehicleData = VehicleModel(
        registrationNum:
            'PENDING-REG-NUM', // You could add a TextField for this later!
        rcDoc: 'https://firebase.storage.com/.../rc.pdf',
        pucDoc: 'https://firebase.storage.com/.../puc.pdf',
        insuranceDoc: 'https://firebase.storage.com/.../insurance.pdf',
      );

      // Update the user's document in Firestore
      await ref.read(userRepositoryProvider).updateUser(user.userID, {
        'aadharCard': 'https://firebase.storage.com/.../aadhar.pdf',
        'license': 'https://firebase.storage.com/.../license.pdf',
        'vehicle': vehicleData.toJson(),
        'verificationStatus': false, // Keeps them pending admin approval
      });

      // Refresh the active state so the app knows we have a vehicle now
      await ref.read(authControllerProvider.notifier).refreshUser();

      // We DO NOT use Navigator.push here.
      // GoRouter will see the refreshed user has vehicle data and teleport them to the Home Screen!
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading docs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool allDocsUploaded = _uploadedDocs.length == _requiredDocs.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // Removed the back button so they can't escape until they upload!
        automaticallyImplyLeading: false,
        title: const Text(
          'Driver Registration',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Text(
              'Upload the required\ndocuments here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap a document below to upload',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                itemCount: _requiredDocs.length,
                itemBuilder: (context, index) {
                  return _buildUploadItem(_requiredDocs[index]);
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (allDocsUploaded && !_isSubmitting)
                      ? _submitDocuments
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66D2A3),
                    disabledBackgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    disabledForegroundColor: Colors.grey[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'Submit Documents',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadItem(String title) {
    bool isUploaded = _uploadedDocs.contains(title);

    return GestureDetector(
      onTap: () => _toggleUpload(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: isUploaded
              ? const Color(0xFF66D2A3).withOpacity(0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUploaded ? const Color(0xFF66D2A3) : Colors.grey[300]!,
            width: isUploaded ? 2.0 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isUploaded ? Colors.black : Colors.grey[800],
                fontSize: 16,
                fontWeight: isUploaded ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            Icon(
              isUploaded ? Icons.check_circle : Icons.upload_file,
              color: isUploaded ? const Color(0xFF66D2A3) : Colors.grey[400],
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
