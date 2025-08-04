// lib/services/profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_final/services/api_constants.dart';
import 'package:flutter_final/services/auth_service.dart';
import 'package:flutter_final/models/profile.dart';

class ProfileService {
  /// Generic helper to create authorization headers.
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Fetches user profile information.
  static Future<Profile> getProfileInfo() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/profile/info'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Profile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile information');
    }
  }

  /// Updates the user's first and last name.
  static Future<bool> updateProfileInfo({required String firstName, required String lastName}) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/profile/info/update'),
      headers: await _getHeaders(),
      body: json.encode({
        'firstName': firstName,
        'lastName': lastName,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// Changes the user's password.
  static Future<bool> changePassword({required String newPassword}) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/profile/password/change'),
      headers: await _getHeaders(),
      body: json.encode({'password': newPassword}),
    );
    return response.statusCode == 200;
  }
}