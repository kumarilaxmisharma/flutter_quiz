// lib/services/report_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'auth_service.dart';
import '../models/top_player.dart';

class ReportService {
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Fetches the top 10 players for the leaderboard.
  static Future<List<TopPlayer>> getTopPlayers() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/report/top10/player'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => TopPlayer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }

  /// Submits a report after a quiz is completed.
  /// NOTE: Based on your API, the body might need more fields like score, categoryId, etc.
  
static Future<void> submitQuizReport({required int score}) async {
  final response = await http.post(
    Uri.parse('${ApiConstants.baseUrl}/report/submit'),
    headers: await _getHeaders(),
    // IMPORTANT: We now send the score in the body.
    // The key is likely 'score', but check your API docs if it's different.
    body: json.encode({
      'score': score,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Failed to submit quiz report');
  }
}
}
