// models/category_detail.dart
import 'package:flutter_final/models/question.dart';

class CategoryDetail {
  final int id;
  final String nameEn;
  final String nameZh;
  final String nameKh;
  final String iconUrl;
  final List<Question> questions;

  CategoryDetail({
    required this.id,
    required this.nameEn,
    required this.nameZh,
    required this.nameKh,
    required this.iconUrl,
    required this.questions,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) {
    return CategoryDetail(
      id: json['id'],
      nameEn: json['nameEn'],
      nameZh: json['nameZh'],
      nameKh: json['nameKh'],
      iconUrl: json['iconUrl'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }

  String getName(String language) {
    switch (language) {
      case 'zh':
        return nameZh;
      case 'kh':
        return nameKh;
      default:
        return nameEn;
    }
  }
}