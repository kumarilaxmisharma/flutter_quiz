import 'package:flutter/material.dart';

// ✅ Import your navigation service
import 'package:flutter_final/services/quiz_navigation_service.dart';

class SummaryActions extends StatelessWidget {
  // ✅ The onGoHome callback is no longer needed.
  final VoidCallback onRestartQuiz;

  const SummaryActions({
    Key? key,
    required this.onRestartQuiz,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              // ✅ FINAL, SIMPLIFIED FIX:
              onPressed: () {
                // 1. Tell the service the quiz session is over. This prepares
                //    the MainScreen to show the correct content.
                QuizNavigationService.instance.endQuiz();

                // 2. Simply pop the current SummaryScreen. The MainScreen is
                //    waiting underneath and will now show the home tabs.
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text('Go Home'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                onRestartQuiz();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Play Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}