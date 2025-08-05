import 'package:flutter/material.dart';
import 'package:flutter_final/models/profile.dart';


class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final VoidCallback onSettingsTap;
  // ✅ 1. Add a callback for the logout action
  final VoidCallback onLogoutTap;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onSettingsTap,
    // ✅ 2. Make the logout callback a required parameter
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    String initials = (profile.firstName?.isNotEmpty == true ? profile.firstName![0] : '') +
                      (profile.lastName?.isNotEmpty == true ? profile.lastName![0] : '');
    if (initials.isEmpty) {
      initials = profile.username?.isNotEmpty == true ? profile.username![0] : '?';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ 3. Replace the invisible placeholder with the new logout button
              _buildHeaderButton(Icons.logout, onLogoutTap),

              // Title that expands to fill the center
              const Expanded(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Existing Settings button
              _buildHeaderButton(Icons.settings, onSettingsTap),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 2, blurRadius: 10),
              ],
            ),
            child: Center(
              child: Text(
                initials.toUpperCase(),
                style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            profile.fullName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            profile.username ?? 'No username',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}