import 'package:flutter/material.dart';

// Definining the brand colors from the image
const Color odoGoGreen = Color(0xFF66D2A3);
const Color appBarColor = Colors.black;
const Color scaffoldColor = Colors.white;

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  // Toggle state for booking categories (0 = Past, 1 = Upcoming)
  int _selectedTab = 0;

  // Placeholder data matching the image
  final List<BookingData> _pastBookingsData = [
    const BookingData(
      location: 'Academic Area Gate 3 -> HC',
      dateTime: '22 January, 2026, 1:06 P.M.',
      driverName: 'Avtansh',
      rikshawNo: 'UP07HC1959',
      driverPhoneNo: '1234567890',
    ),
    const BookingData(
      location: 'Home -> OAT',
      dateTime: '20 January, 2026, 6:54 P.M.',
      driverName: 'Archit',
      rikshawNo: 'UP11AB2026',
      driverPhoneNo: '1111111111',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine the content based on the selected tab
    List<BookingData> currentBookings = _selectedTab == 0 ? _pastBookingsData : [];

    return Scaffold(
      backgroundColor: scaffoldColor, // Match the main background color in the image
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSegmentedControl(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: currentBookings.length,
              itemBuilder: (context, index) => _buildBookingCard(currentBookings[index]),
            ),
          ),
        ],
      ),
      // The bottom nav bar is handled by the parent shell, as requested.
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      // 1. INCREASED: Makes the black strip noticeably taller
      toolbarHeight: 80, 
      backgroundColor: appBarColor, 
      elevation: 0,
      automaticallyImplyLeading: false, 
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/odogo_logo_black_bg.jpeg',
              // 2. INCREASED: Made the logo proportionally larger
              height: 40, 
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Increased the fallback icon size to match as well
                return const Icon(Icons.electric_rickshaw, color: odoGoGreen, size: 45); 
              },
            ),
            const SizedBox(height: 3), // Added a tiny gap so it breathes better
            const Text(
              'OdoGo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                // 3. INCREASED: Made the text proportionally larger
                fontSize: 18, 
                letterSpacing: 1.2, // Added a slight letter spacing for a premium look
              ),
            ),
          ],
        ),
      ),
      centerTitle: false, 
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900], // Dark background for the whole toggle bar
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab('Past', 0),
          _buildTab('Upcoming', 1),
        ],
      ),
    );
  }

  // Makes the Past/Upcoming buttons interactive with the Green styling
  Widget _buildTab(String title, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? odoGoGreen : Colors.transparent, // Highlights green when clicked
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70, // Adjusts text color for readability
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingData booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[400]!, width: 1), // Subtle border like the image
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align icon with the top of text
          children: [
            // History icon in a circle on the left, with brand color
            Container(
              padding: const EdgeInsets.all(6), // Smaller padding for a tighter look
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: odoGoGreen, width: 2), // Full-stroke circle like the image
              ),
              child: const Icon(Icons.history_rounded, color: odoGoGreen, size: 24),
            ),
            const SizedBox(width: 16),
            // The detailed text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.location,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.black, 
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    booking.dateTime,
                    style: TextStyle(
                      color: Colors.grey[700], 
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Driver: ${booking.driverName}',
                    style: const TextStyle(
                      color: Colors.black, 
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rikshaw No: ${booking.rikshawNo}',
                    style: const TextStyle(
                      color: Colors.black, 
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Driver Phone No- ${booking.driverPhoneNo}',
                    style: const TextStyle(
                      color: Colors.black, 
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple data model for a booking
class BookingData {
  final String location;
  final String dateTime;
  final String driverName;
  final String rikshawNo;
  final String driverPhoneNo;

  const BookingData({
    required this.location,
    required this.dateTime,
    required this.driverName,
    required this.rikshawNo,
    required this.driverPhoneNo,
  });
}