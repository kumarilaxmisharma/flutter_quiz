// lib/services/category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'auth_service.dart';
import '../models/category.dart';
import '../models/category_detail.dart';

class CategoryService {
  /// Fetches the list of all quiz categories.
  static Future<List<Category>> getCategories() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/category/list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  /// Fetches the details for a single category, including its questions.
  static Future<CategoryDetail> getCategoryDetail(int categoryId) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/category/$categoryId/detail'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return CategoryDetail.fromJson(data);
    } else {
      throw Exception('Failed to load category details');
    }
  }
}