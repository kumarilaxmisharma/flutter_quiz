import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:flutter_final/constants/AppRouter.dart'; 
import 'package:flutter_final/models/profile.dart';
import 'package:flutter_final/services/profile_service.dart';
import 'package:flutter_final/widgets/profile/loading_shimmer.dart';
import 'package:flutter_final/widgets/profile/error_display.dart';
import 'package:flutter_final/widgets/profile/profile_header.dart';
import 'package:flutter_final/widgets/profile/profile_details_card.dart';
import 'package:flutter_final/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Profile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _profileFuture = ProfileService.getProfileInfo();
    });
  }

  // ✅ 4. Add the logout handler function
  Future<void> _handleLogout() async {
    // Show a confirmation dialog before logging out for better UX
    final didRequestLogout = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Logout'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    // If the user confirmed the logout
    if (didRequestLogout == true) {
      // Clear saved data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user_data');

      // Check if the widget is still mounted before navigating
      if (!mounted) return;

      // Navigate to the login screen and remove all other routes
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.login,
        (Route<dynamic> route) => false,
      );
    }
  }

  void _navigateToSettings(Profile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          profile: profile,
          onProfileUpdated: _fetchProfile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Profile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const ProfileLoadingShimmer();
          } else if (snapshot.hasError) {
            return ErrorDisplay(error: snapshot.error, onRetry: _fetchProfile);
          } else if (snapshot.hasData) {
            final profile = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _fetchProfile,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF8B5CF6), Color(0xFF4e3fa0)],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SafeArea(
                    child: Column(
                      children: [
                        ProfileHeader(
                          profile: profile,
                          onSettingsTap: () => _navigateToSettings(profile),
                          // ✅ 5. Pass the new logout function to the header
                          onLogoutTap: _handleLogout,
                        ),
                        ProfileDetailsCard(profile: profile),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const ProfileLoadingShimmer();
        },
      ),
    );
  }
}