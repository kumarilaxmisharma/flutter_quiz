// models/question.dart
class Question {
  final int id;
  final String code;
  final String questionEn;
  final String questionKh;
  final String questionZh;
  final String answerCode;
  final List<String> optionEn;
  final List<String> optionKh;
  final List<String> optionZh;
  final int categoryId;

  Question({
    required this.id,
    required this.code,
    required this.questionEn,
    required this.questionKh,
    required this.questionZh,
    required this.answerCode,
    required this.optionEn,
    required this.optionKh,
    required this.optionZh,
    required this.categoryId,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      code: json['code'],
      questionEn: json['questionEn'],
      questionKh: json['questionKh'],
      questionZh: json['questionZh'],
      answerCode: json['answerCode'],
      optionEn: List<String>.from(json['optionEn']),
      optionKh: List<String>.from(json['optionKh']),
      optionZh: List<String>.from(json['optionZh']),
      categoryId: json['categoryId'],
    );
  }

  String getQuestion(String language) {
    switch (language) {
      case 'zh':
        return questionZh;
      case 'kh':
        return questionKh;
      default:
        return questionEn;
    }
  }

  List<String> getOptions(String language) {
    switch (language) {
      case 'zh':
        return optionZh;
      case 'kh':
        return optionKh;
      default:
        return optionEn;
    }
  }
}
