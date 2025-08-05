import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  
  String _countryCode = '+855';
  bool _rememberMe = false;
  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _isVerifying = false;

  // ✅ FIX 1: Correct the base URL to the root of your API.
  final String _baseUrl = 'https://quiz-api.camtech-dev.online';

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    // We only need to validate the phone number to send an OTP
    if (_phoneController.text.trim().isEmpty) {
        _showErrorSnackBar('Please enter your phone number first.');
        return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ✅ FIX 2: Use the correct endpoint for sending OTP
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/otp/send'), 
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'countryCode': _countryCode.replaceAll('+', ''),
          'phone': _phoneController.text.trim(),
        }),
      );

      // Assuming 200 or 201 means success
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isOtpSent = true;
        });
        _showSuccessSnackBar('OTP sent successfully!');
      } else {
        final error = jsonDecode(response.body);
        _showErrorSnackBar(error['message'] ?? 'Failed to send OTP. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('Network error. Please check your connection.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill all required fields.');
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      // ✅ FIX 3: Use the correct endpoint for registration
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          
          'countryCode': _countryCode.replaceAll('+', ''),
          'phone': _phoneController.text.trim(),
          'password': _passwordController.text,
          'otp': _otpController.text.trim(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessSnackBar('Account created successfully!');
        // Navigate to login or home screen
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        final errorData = jsonDecode(response.body);
        _showErrorSnackBar(errorData['message'] ?? 'Failed to create account');
      }
    } catch (e) {
      _showErrorSnackBar('Network error. Please check your connection.');
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Title
                const Text(
                  'Create your\nAccount',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 112, 54, 249),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue to your account',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color(0xFF666666),
                  ),
                ),
      
                
                const SizedBox(height: 20),
                
                // Phone Field
                _buildPhoneField(),
                
                const SizedBox(height: 20),
                
                // Password Field
                _buildInputField(
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  hintText: 'Password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // OTP Field (shown after sending OTP)
                if (_isOtpSent) ...[
                  _buildInputField(
                    controller: _otpController,
                    icon: Icons.security,
                    hintText: 'Enter OTP',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
                
                // Send OTP or Create Account Button
                if (!_isOtpSent)
                  _buildButton(
                    text: 'Send OTP',
                    onPressed: _isLoading ? null : _sendOtp,
                    isLoading: _isLoading,
                  )
                else
                  _buildButton(
                    text: 'Create Account',
                    onPressed: _isVerifying ? null : _createAccount,
                    isLoading: _isVerifying,
                  ),
                
                const SizedBox(height: 20),
                
                // Remember me checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF6B73FF),
                    ),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Social login options
                const Text(
                  'or continue with',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialButton(Icons.facebook, Colors.blue),
                    _buildSocialButton(Icons.g_mobiledata, Colors.red),
                    _buildSocialButton(Icons.apple, Colors.black),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Color.fromARGB(255, 126, 72, 252),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent, width: 2),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.phone_outlined, color: Colors.grey),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _countryCode,
                onChanged: (String? newValue) {
                  setState(() {
                    _countryCode = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem(value: '+855', child: Text('+855')),
                  
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Phone number',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 126, 72, 252),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 36,
      ),
    );
  }
}