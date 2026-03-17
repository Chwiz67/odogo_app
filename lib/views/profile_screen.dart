import 'package:flutter/material.dart';
import 'phone_number_edit_screen.dart';
import 'gender_selection_screen.dart';
import 'email_edit_screen.dart';
import 'home_address_edit_screen.dart';
import 'edit_work_address_screen.dart';
import 'location_sharing_screen.dart';
import 'edit_date_of_birth_screen.dart';
import 'commute_alerts_screen.dart';
import 'switch_account_screen.dart';
import 'account_deletion_screen.dart';
import 'sign_out_screen.dart';
import 'edit_name_screen.dart';

class BoundedBouncingScrollPhysics extends BouncingScrollPhysics {
  const BoundedBouncingScrollPhysics({super.parent});

  final double maxOverscroll = 25.0; 

  @override
  BoundedBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BoundedBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.minScrollExtent - maxOverscroll) {
      return value - (position.minScrollExtent - maxOverscroll);
    }
    if (value > position.maxScrollExtent + maxOverscroll) {
      return value - (position.maxScrollExtent + maxOverscroll);
    }
    
    // Allow normal scrolling everywhere else
    return super.applyBoundaryConditions(position, value);
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- UPDATED HEADER SECTION ---
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.black,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF66D2A3),
                    child: Icon(Icons.person, color: Colors.white, size: 35),
                  ),
                  const SizedBox(width: 16),
                  
                  // Expanded ensures long names don't break the layout
                  const Expanded(
                    child: Text(
                      'Inesh',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), // Subtle background
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF66D2A3), size: 20), // OdoGo Green
                      onPressed: () {
                        // THIS NOW WORKS!
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const EditNameScreen())
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // --- SCROLLABLE LIST SECTION ---
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  physics: const BoundedBouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      
                      // Profile Options
                      _buildTile(
                        context, 
                        Icons.phone, 
                        'Phone Number',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PhoneNumberEditScreen()),
                          );
                        }
                      ),
                      const Divider(height: 30, thickness: 1, color: Colors.black12),
                      _buildTile(
                        context, 
                        Icons.person_outline, 
                        'Gender',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GenderSelectionScreen()),
                          );
                        }
                      ),
                      const Divider(height: 30, thickness: 1, color: Colors.black12),
                      _buildTile(
                        context, 
                        Icons.email_outlined, 
                        'Email',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EmailEditScreen()),
                          );
                        }
                      ),
                      const Divider(height: 30, thickness: 1, color: Colors.black12),
                      _buildTile(
                        context, 
                        Icons.home_outlined, 
                        'Add home',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeAddressEditScreen()),
                          );
                        }
                      ),
                      const Divider(height: 30, thickness: 1, color: Colors.black12),
                      _buildTile(
                        context, 
                        Icons.work_outline, 
                        'Add work',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditWorkAddressScreen()),
                          );
                        }
                      ),
                      const Divider(height: 30, thickness: 1, color: Colors.black12),
                      _buildTile(
                        context, 
                        Icons.location_on_outlined, 
                        'Location Sharing',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LocationSharingScreen()),
                          );
                        }
                      ),
                      const Divider(height: 30, thickness: 1, color: Colors.black12),
                      _buildTile(
                        context, 
                        Icons.calendar_today, 
                        'Date of Birth',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditDateOfBirthScreen()),
                          );
                        }
                      ),
                      const Divider(height: 30, thickness: 1, color: Colors.black12),
                      _buildTile(
                        context, 
                        Icons.notifications_none, 
                        'Commute Alerts',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CommuteAlertsScreen()),
                          );
                        }
                      ),
                      const Divider(height: 30, thickness: 1, color: Colors.black12),
                      _buildTile(
                        context, 
                        Icons.swap_horiz, 
                        'Switch Account',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SwitchAccountScreen()),
                          );
                        }
                      ),
                      const Divider(height: 30, thickness: 1, color: Colors.black12),
                      _buildTile(
                        context, 
                        Icons.delete_outline, 
                        'Account Deletion', 
                        isDestructive: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AccountDeletionScreen()),
                          );
                        }
                      ),
                      const Divider(height: 30, thickness: 1, color: Colors.black12),
                      _buildTile(
                        context, 
                        Icons.power_settings_new, 
                        'Sign out', 
                        isDestructive: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignOutScreen()),
                          );
                        }
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // The missing helper function that makes your tiles clickable!
  Widget _buildTile(BuildContext context, IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black26),
      onTap: onTap ?? () {
        // Default action if no specific onTap is provided
        print("$title clicked");
      },
    );
  }
}