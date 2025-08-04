import 'package:flutter/material.dart';

class ExplanationWidget extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;

  const ExplanationWidget({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        border: Border.all(color: Colors.amber.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: Colors.amber.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isCorrect
                  ? 'Correct! Well done!'
                  : 'The correct answer is: $correctAnswer',
              style: TextStyle(
                color: Colors.amber.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}