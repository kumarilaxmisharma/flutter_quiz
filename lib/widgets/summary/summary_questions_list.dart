import 'package:flutter/material.dart';
import '../../models/question.dart';
import './question_review_card.dart';

class SummaryQuestionsList extends StatelessWidget {
  final List<Question> questions;
  final List<String?> selectedAnswers;
  final String language;

  const SummaryQuestionsList({
    Key? key,
    required this.questions,
    required this.selectedAnswers,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.purple.shade50],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.question_mark_sharp,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Review Answers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: questions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final question = questions[index];
              final selectedAnswer = selectedAnswers[index];
              final isCorrect = selectedAnswer == question.answerCode;

              return QuestionReviewCard(
                index: index,
                question: question,
                selectedAnswer: selectedAnswer,
                isCorrect: isCorrect,
                language: language,
              );
            },
          ),
        ],
      ),
    );
  }
}