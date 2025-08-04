import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_final/constants/AppRouter.dart';
import 'package:flutter_final/main.dart';
import 'package:flutter_final/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('saved_phone');
    final rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe && savedPhone != null) {
      setState(() {
        _usernameController.text = savedPhone;
        _rememberMe = true;
      });
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_phone', _usernameController.text.trim());
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_phone');
      await prefs.setBool('remember_me', false);
    }
  }

  void _showAlert(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Notice'),
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

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        String cleanPhone = _usernameController.text.trim().replaceAll(RegExp(r'[^\d]'), '');

        final requestBody = {
          "countryCode": "855",
          "phone": cleanPhone,
          // "otp": null,
          "password": _passwordController.text.trim()
        };
        

        // Debug logging
        print('Login request: ${jsonEncode(requestBody)}');

        final response = await http.post(
          Uri.parse('https://quiz-api.camtech-dev.online/api/auth/login'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(requestBody),
        ).timeout(const Duration(seconds: 30));

        // Debug logging
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          try {
            final data = jsonDecode(response.body);

            if (data.containsKey('token') || data.containsKey('access_token') || data.containsKey('authToken')) {
              final prefs = await SharedPreferences.getInstance();
              String token = data['token'] ?? data['access_token'] ?? data['authToken'] ?? '';

              if (token.isNotEmpty) {
                await prefs.setString('token', token);

                if (data.containsKey('user')) {
                  await prefs.setString('user_data', jsonEncode(data['user']));
                }

                await _saveCredentials();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login successful!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );

                // Update AuthService state
                // AuthService.login();

                // Navigate to home screen and remove all previous routes
                Navigator.pushReplacementNamed(context, AppRouter.main);
              } else {
                _showErrorAlert('Login Error', 'Authentication token not received. Please try again.');
              }
            } else {
              _showErrorAlert('Login Error', 'Authentication token not received. Please try again.');
            }
          } catch (e) {
            _showErrorAlert('Login Error', 'Failed to process server response. Please try again.');
          }
        } else {
          String errorMessage = 'Login failed. Please try again.';
          try {
            final errorData = jsonDecode(response.body);
            if (errorData.containsKey('message')) {
              errorMessage = errorData['message'];
            } else if (errorData.containsKey('error')) {
              errorMessage = errorData['error'];
            } else if (errorData.containsKey('detail')) {
              errorMessage = errorData['detail'];
            }
          } catch (e) {
            // Use default error message if parsing fails
          }

          if (response.statusCode == 401) {
            errorMessage = 'Invalid phone number or password. Please check your credentials and try again.';
          } else if (response.statusCode == 400) {
            errorMessage = 'Invalid request. Please check your input and try again.';
          } else if (response.statusCode == 404) {
            errorMessage = 'Service temporarily unavailable. Please try again later.';
          } else if (response.statusCode >= 500) {
            errorMessage = 'Server error. Please try again later.';
          }

          _showErrorAlert('Login Failed', errorMessage);
        }
      } catch (e) {
        setState(() => _isLoading = false);

        String errorMessage = 'Network error. Please check your internet connection and try again.';

        if (e.toString().contains('SocketException')) {
          errorMessage = 'No internet connection. Please check your network settings.';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage = 'Connection timeout. Please check your internet connection and try again.';
        } else if (e.toString().contains('HandshakeException')) {
          errorMessage = 'Connection security error. Please try again.';
        }

        _showErrorAlert('Connection Error', errorMessage);
      }
    }
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(245, 245, 245, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                const Icon(CupertinoIcons.phone, color: Color(0xFF666666)),
                const SizedBox(width: 8),
                Text(
                  '+855',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: const Color(0xFFCCCCCC),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'Please enter your phone number';
                }
                String cleanValue = value!.replaceAll(RegExp(r'[^\d]'), '');
                if (cleanValue.length < 8) {
                  return 'Please enter a valid phone number';
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
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
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

  Widget _buildSocialButton(IconData icon, Color color, String service) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _showAlert('$service login will be available soon!'),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 36),
      ),
    );
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
                const SizedBox(height: 40),
                Text(
                  'Welcome\nBack',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B5CF6),
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
                const SizedBox(height: 40),
                _buildPhoneField(),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  placeholder: 'Password',
                  icon: CupertinoIcons.lock,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter your password';
                    }
                    if (value!.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CupertinoCheckbox(
                            value: _rememberMe,
                            onChanged: (value) => setState(() => _rememberMe = value ?? false),
                            activeColor: const Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Remember me',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.forgotPassword),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF8B5CF6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(12),
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'or continue with',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(Icons.facebook, const Color(0xFF1877F2), 'Facebook'),
                    const SizedBox(width: 16),
                    _buildSocialButton(Icons.g_mobiledata_outlined, const Color(0xFFDB4437), 'Google'),
                    const SizedBox(width: 16),
                    _buildSocialButton(Icons.apple, Colors.black, 'Apple'),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: CupertinoButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.signup),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF666666),
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Sign Up',
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
}

