import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DriverCancelConfirmationScreen extends StatelessWidget {
  const DriverCancelConfirmationScreen({super.key});

  final Color odogoGreen = const Color(0xFF66D2A3);

  void _confirmCancel(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    
    // Pop all the way back to the Home Dashboard
    Navigator.popUntil(context, (route) => route.isFirst);

    // Show the cancellation message on the Home Dashboard
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Ride cancelled successfully'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Live Dark Map Background (Keeps context of where they are)
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(26.5123, 80.2329),
              initialZoom: 16.5,
              interactionOptions: InteractionOptions(flags: InteractiveFlag.none), // Lock the map on this screen
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
              // Dimming overlay to make the map look faded in the background
              Container(color: Colors.black.withOpacity(0.6)),
            ],
          ),

          // 2. The Confirmation Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, -5))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
                  ),
                  const SizedBox(height: 24),
                  
                  // Text Content
                  const Text(
                    'Cancel Trip?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Are you sure you want to cancel this ride? You can cancel at most 2 rides in 15 minutes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Column(
                    children: [
                      // NO - Keep the ride (Primary visual focus)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: odogoGreen,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          onPressed: () => Navigator.pop(context), // Just dismisses the popup
                          child: const Text('No, Keep Ride', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // YES - Cancel it (Secondary visual focus)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () => _confirmCancel(context),
                          child: const Text('Yes, Cancel Trip', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}