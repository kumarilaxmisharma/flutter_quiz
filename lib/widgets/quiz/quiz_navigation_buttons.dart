import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizNavigationButtons extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final bool isAnswered;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const QuizNavigationButtons({
    Key? key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.isAnswered,
    required this.onPrevious,
    required this.onNext,
    required this.onFinish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = currentQuestionIndex == totalQuestions - 1;

    // --- LOGIC FIX ---
    // Determine the button text based on the answered state for better UX.
    String buttonText;
    if (!isAnswered) {
      buttonText = 'Select an Answer';
    } else {
      buttonText = isLastQuestion ? 'Finish Quiz' : 'Next Question';
    }
    // --- END FIX ---

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPrevious,
                icon: const Icon(CupertinoIcons.back),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          if (currentQuestionIndex > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isAnswered ? (isLastQuestion ? onFinish : onNext) : null,
              icon: Icon(
                isLastQuestion ? Icons.done : CupertinoIcons.forward,
              ),
              label: Text(buttonText), // Use the dynamic button text here
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
                // Make the disabled text more readable
                disabledForegroundColor: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}