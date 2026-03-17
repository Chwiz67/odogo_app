import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'commuter_cancel_confirmation_screen.dart';

class RideConfirmedScreen extends StatelessWidget {
  const RideConfirmedScreen({super.key});

  void _cancelTrip(BuildContext context) {
  // Navigate to the confirmation screen instead of instantly canceling
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CommuterCancelConfirmationScreen()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. The Real Live Map Background
          Positioned.fill(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(26.5123, 80.2329), // IIT Kanpur Coordinates
                initialZoom: 16.0,
                interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
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
                // Simulated markers for the user and the incoming Rickshaw
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(26.5123, 80.2329),
                      child: Icon(Icons.location_on, color: Color(0xFF66D2A3), size: 40),
                    ),
                    // The Incoming Rickshaw Marker
                    Marker(
                      point: LatLng(26.5150, 80.2300), 
                      width: 150,
                      height: 150,
                      child: Image.asset(
                        'assets/images/odogo_logo_without_bg.png', // <-- Put your image path here!
                        fit: BoxFit.contain,
                        // Fallback icon just in case the image path is wrong
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.electric_rickshaw, color: Color(0xFF66D2A3), size: 40),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 2. Bottom Confirmation Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 15, offset: Offset(0, -5))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Title & Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your ride is confirmed',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Meet at the pickup point',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Text('3', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('MINS', style: TextStyle(color: Color(0xFF66D2A3), fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // PIN Section
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PIN for this trip',
                          style: TextStyle(color: Colors.grey[800], fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          '8403',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 6, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Driver Info Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF66D2A3).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.person, size: 36, color: Color(0xFF66D2A3)),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Arman',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Text(
                              'UP12 WA 9363 • E-Rickshaw',
                              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                        child: IconButton(onPressed: () {}, icon: const Icon(Icons.phone_in_talk, color: Colors.black87)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                        child: IconButton(onPressed: () {}, icon: const Icon(Icons.message_rounded, color: Colors.black87)),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _cancelTrip(context),
                      child: const Text(
                        'Cancel Trip',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}