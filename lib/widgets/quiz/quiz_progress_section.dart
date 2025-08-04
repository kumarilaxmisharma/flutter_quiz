import 'package:flutter/material.dart';

class QuizProgressSection extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final Animation<double> progressAnimation;

  const QuizProgressSection({
    Key? key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progressAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question $currentQuestion of $totalQuestions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: progressAnimation.value,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 134, 86, 247)),
                minHeight: 8,
                borderRadius: BorderRadius.circular(12),
              );
            },
          ),
        ],
      ),
    );
  }
}