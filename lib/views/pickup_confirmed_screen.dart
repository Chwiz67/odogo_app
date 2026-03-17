import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PickupConfirmedScreen extends StatelessWidget {
  const PickupConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // 1. Functional Dark Map
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(26.5123, 80.2329), // IITK
              initialZoom: 16.0,
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
              // Rickshaw Pin
              MarkerLayer(
                markers: [
                  Marker(
                    point: const LatLng(26.5123, 80.2329),
                    width: 46,
                    height: 46,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF66D2A3),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.electric_rickshaw, color: Colors.black, size: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 2. Back Button
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 3. The Driver Info Card
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black45)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF66D2A3), size: 18),
                      SizedBox(width: 8),
                      Text('Driver has arrived at pickup', 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30, 
                        backgroundColor: Color(0xFF66D2A3),
                        child: Icon(Icons.person, color: Colors.white, size: 35),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Arman', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            const Text('E-RICKSHAW', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF66D2A3).withOpacity(0.15), 
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('UP12 WA 9363', 
                                style: TextStyle(color: Color(0xFF66D2A3), fontWeight: FontWeight.bold, fontSize: 12)),
                            )
                          ],
                        ),
                      ),
                      // Action Buttons
                      Row(
                        children: [
                          _buildCircleAction(Icons.phone, Colors.white24),
                          const SizedBox(width: 8),
                          _buildCircleAction(Icons.chat_bubble, const Color(0xFF66D2A3)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}