import 'package:flutter/material.dart';
import 'package:flutter_final/models/profile.dart';


class ProfileDetailsCard extends StatelessWidget {
  final Profile profile;
  
  // Mock data, as it was not part of the Profile model
  final int totalTests = 5;
  // final int totalScore = 2847;

  const ProfileDetailsCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // 1. REMOVED the Expanded and SingleChildScrollView widgets
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20), // Added bottom padding
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsRow(),
          const SizedBox(height: 24),
          const Text('Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.phone, 'Phone', profile.phone),
          _buildInfoRow(Icons.person_outline, 'Status', profile.status ?? 'Not set'),
          const SizedBox(height: 24),
          _buildRecentActivity(),
        ],
      ),
    );
  }
  
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard(Icons.emoji_events, totalTests.toString(), 'Total Tests', const [Color(0xFF8B5CF6), Color(0xFF4e3fa0)])),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(Icons.star, profile.totalScore ?? '0', 'Total Score', const [Color(0xFF3F51B5), Color(0xFF2196F3)])),
      ],
    );
  }
  
  Widget _buildStatCard(IconData icon, String value, String label, List<Color> gradientColors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 16),
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }
  
  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!)
          ),
          child: Row(
            children: [
              const Icon(Icons.quiz, color: Color(0xFF673AB7)),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mathematics Quiz', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text('Completed successfully', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const Text('85', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ),
      ],
    );
  }
}