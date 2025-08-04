import 'package:flutter/material.dart';
import 'package:flutter_final/models/profile.dart'; // 1. ADD THIS IMPORT
import 'package:flutter_final/services/profile_service.dart';

class SettingsScreen extends StatefulWidget {
  final Profile profile;
  final VoidCallback onProfileUpdated;

  // 2. REMOVE the profileService parameter
  const SettingsScreen({
    super.key,
    required this.profile,
    required this.onProfileUpdated,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool _isSavingProfile = false;
  bool _isSavingPassword = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.profile.firstName);
    lastNameController = TextEditingController(text: widget.profile.lastName);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }
  
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    setState(() => _isSavingProfile = true);
    try {
      // 3. CALL the method statically
      bool success = await ProfileService.updateProfileInfo(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
      );
      if (mounted) {
        if (success) {
          widget.onProfileUpdated();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green));
        } else {
          throw Exception('Failed to update profile.');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingProfile = false);
      }
    }
  }

  void _changePassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match!'), backgroundColor: Colors.red));
      return;
    }
    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password cannot be empty!'), backgroundColor: Colors.red));
      return;
    }
    
    setState(() => _isSavingPassword = true);
    try {
      // 4. CALL the method statically
      bool success = await ProfileService.changePassword(newPassword: passwordController.text);
      if (mounted) {
        if (success) {
          // No need to call onProfileUpdated here as password change doesn't affect profile data display
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed successfully!'), backgroundColor: Colors.green));
        } else {
          throw Exception('Failed to change password.');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingPassword = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // The build method itself requires no changes
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black87),
        title: const Text('Settings', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Profile Information',
              children: [
                _buildTextField('First Name', firstNameController),
                _buildTextField('Last Name', lastNameController),
                const SizedBox(height: 16),
                _buildSaveButton(
                  'Save Profile',
                  _isSavingProfile ? null : _updateProfile,
                  _isSavingProfile,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Change Password',
              children: [
                _buildTextField('New Password', passwordController, isPassword: true),
                _buildTextField('Confirm Password', confirmPasswordController, isPassword: true),
                const SizedBox(height: 16),
                _buildSaveButton(
                  'Update Password', 
                  _isSavingPassword ? null : _changePassword,
                  _isSavingPassword,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF673AB7), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(String text, VoidCallback? onPressed, bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF673AB7),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}