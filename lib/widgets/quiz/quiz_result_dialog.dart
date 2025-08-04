import 'package:flutter/material.dart';

class QuizResultDialog extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final int minutes;
  final int seconds;
  final VoidCallback onViewSummary;
  final VoidCallback onRetryQuiz;

  const QuizResultDialog({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.minutes,
    required this.seconds,
    required this.onViewSummary,
    required this.onRetryQuiz,
  }) : super(key: key);

  Color _getScoreColor(double score) {
    if (score >= 0.75) return Colors.green;
    if (score >= 0.4) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final double score =
        totalQuestions > 0 ? correctAnswers / totalQuestions : 0;
    final String percentage = (score * 100).toStringAsFixed(0);
    final Color scoreColor = _getScoreColor(score);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      title: const Center(
        child: Text(
          '🎉 Quiz Completed!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: score,
                  strokeWidth: 10,
                  backgroundColor: scoreColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
                Center(
                  child: Text(
                    '$correctAnswers/$totalQuestions',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your Score: $percentage%',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer_outlined, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Time: ${minutes}m ${seconds}s',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.list_alt_rounded),
              label: const Text('View Summary'),
              onPressed: onViewSummary,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry Quiz'),
              onPressed: onRetryQuiz,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF8B5CF6),
                side: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}