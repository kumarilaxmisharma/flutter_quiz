import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_final/constants/AppRouter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  // ✅ FIX: Replaced email with controllers for phone, OTP, and new password
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();

  String _countryCode = '+855';
  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // ✅ FIX: Defined correct API endpoints
  final String _baseUrl = 'https://quiz-api.camtech-dev.online/api';
  final String _sendOtpPath = '/auth/otp/send';
  final String _resetPasswordPath = '/auth/password/reset';

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _showErrorAlert(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ✅ FIX: Added function to send OTP
  Future<void> _sendOtp() async {
    if (_phoneController.text.trim().isEmpty) {
      _showErrorAlert('Input Error', 'Please enter your phone number to receive an OTP.');
      return;
    }
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_sendOtpPath'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'countryCode': _countryCode.replaceAll('+', ''),
          'phone': _phoneController.text.trim(),
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() => _isOtpSent = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent successfully!'), backgroundColor: Colors.green),
        );
      } else {
        final errorData = jsonDecode(response.body);
        _showErrorAlert('Error', errorData['message'] ?? 'Failed to send OTP.');
      }
    } catch (e) {
      _showErrorAlert('Connection Error', 'A network error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ FIX: Added function to reset password
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_resetPasswordPath'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'countryCode': _countryCode.replaceAll('+', ''),
          'phone': _phoneController.text.trim(),
          'otp': _otpController.text.trim(),
          'password': _newPasswordController.text,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Success'),
            content: const Text('Your password has been reset successfully. Please log in with your new password.'),
            actions: [CupertinoDialogAction(isDefaultAction: true, onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
          ),
        );
        Navigator.pushReplacementNamed(context, AppRouter.login);
      } else {
        final errorData = jsonDecode(response.body);
        _showErrorAlert('Reset Failed', errorData['message'] ?? 'Failed to reset password.');
      }
    } catch (e) {
      _showErrorAlert('Connection Error', 'A network error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Forgot\nPassword',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B5CF6),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                 Text(
                  !_isOtpSent 
                    ? 'Enter your phone number to receive a verification code.'
                    : 'Check your messages for the OTP and enter your new password.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 32),
                
                // ✅ FIX: Replaced Email field with Phone field
                _buildPhoneField(),
                
                if (_isOtpSent) ...[
                  const SizedBox(height: 20),
                  // ✅ FIX: Added OTP field
                  _buildInputField(
                    controller: _otpController,
                    placeholder: 'Enter OTP',
                    icon: CupertinoIcons.shield_lefthalf_fill,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter OTP';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // ✅ FIX: Added New Password field
                  _buildInputField(
                    controller: _newPasswordController,
                    placeholder: 'New Password',
                    icon: CupertinoIcons.lock,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter a new password';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                    suffixIcon: CupertinoButton(
                      padding: const EdgeInsets.only(right: 8.0),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: CupertinoButton(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(12),
                    onPressed: _isLoading ? null : (_isOtpSent ? _resetPassword : _sendOtp),
                    child: _isLoading
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(
                            _isOtpSent ? 'Reset Password' : 'Send OTP',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 40),
                Center(
                  child: CupertinoButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.login),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF666666),
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: "Remembered your password? "),
                          TextSpan(
                            text: 'Sign In',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF8B5CF6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget for TextFields
  Widget _buildInputField({
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Icon(icon, color: const Color(0xFF666666)),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              validator: validator,
              keyboardType: keyboardType,
              style: GoogleFonts.poppins(fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0xFF666666),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          if (suffixIcon != null) suffixIcon,
        ],
      ),
    );
  }

  // Helper Widget for the Phone Field
  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Icon(CupertinoIcons.phone, color: const Color(0xFF666666)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _countryCode,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 20,
            color: const Color(0xFFCCCCCC),
          ),
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'Please enter your phone number';
                }
                return null;
              },
              style: GoogleFonts.poppins(fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Phone Number',
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0xFF666666),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}