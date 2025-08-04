import 'package:flutter/material.dart';
import 'package:flutter_final/models/profile.dart'; // 1. ADD THIS IMPORT
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
  // 2. REMOVE the service instance
  // final ProfileService _apiService = ProfileService();
  late Future<Profile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  // Make this method return a Future for the RefreshIndicator
  Future<void> _fetchProfile() async {
    setState(() {
      // 3. CALL the service method statically
      _profileFuture = ProfileService.getProfileInfo();
    });
  }

  void _navigateToSettings(Profile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // The SettingsScreen can also call the static service methods directly
        builder: (context) => SettingsScreen(
          profile: profile,
          onProfileUpdated: _fetchProfile, // Callback to refresh profile
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
            // This is the Container from line 64
            child: Container(
              width: double.infinity,
              // DO NOT add 'height: double.infinity' here
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