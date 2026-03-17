import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'waiting_for_driver_screen.dart'; // Import the waiting screen!

class TripConfirmationScreen extends StatelessWidget {
  final String destination;

  // We pass the searched destination into this screen so it dynamically updates
  const TripConfirmationScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      appBar: AppBar(
        backgroundColor: Colors.black, // Synced to OdoGo theme
        elevation: 0,
        title: const Text('Trip Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Map Overview Area
          Container(
            height: 180,
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              // IgnorePointer prevents the user from panning this preview map
              child: IgnorePointer(
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(26.5123, 80.2329), // IIT Kanpur Coordinates
                    initialZoom: 14.5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.odogo_app',
                      tileBuilder: (context, tileWidget, tile) {
                        return ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            -0.2126, -0.7152, -0.0722, 0, 255,
                            -0.2126, -0.7152, -0.0722, 0, 255,
                            -0.2126, -0.7152, -0.0722, 0, 255,
                            0,       0,       0,       1, 0,
                          ]),
                          child: tileWidget,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Info Cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildLocationCard(
                  icon: Icons.location_on,
                  label: 'PICKUP',
                  address: 'Current Location (e.g. Hall 12)',
                ),
                const SizedBox(height: 16),
                _buildLocationCard(
                  icon: Icons.near_me,
                  label: 'DESTINATION',
                  address: destination, // Dynamically uses what you searched!
                ),
                const SizedBox(height: 24),
                // _buildPriceCard(),
              ],
            ),
          ),

          // Bottom Action
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Moving forward to the Waiting screen!
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WaitingForDriverScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66D2A3), // Synced to OdoGo Green
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Center(
                child: Text('Confirm Trip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Added 'required' keywords to fix syntax
  Widget _buildLocationCard({required IconData icon, required String label, required String address}) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF66D2A3), size: 28), // OdoGo Green
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Text(address, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//   Widget _buildPriceCard() {
//     return Card(
//       elevation: 2,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Estimated Fare', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
//                 Text('₹15', // Realistic campus rickshaw price
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF66D2A3))),
//               ],
//             ),
//             const Divider(height: 24),
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
//                   child: const Icon(Icons.qr_code, size: 16, color: Colors.black87),
//                 ),
//                 const SizedBox(width: 12),
//                 const Text('UPI / Cash', style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
  // }
}