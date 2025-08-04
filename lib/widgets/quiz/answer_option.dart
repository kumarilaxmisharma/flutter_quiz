import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  final int index;
  final String option;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final bool showExplanation;
  final bool isTimerActive;
  final VoidCallback onTap;

  const AnswerOption({
    Key? key,
    required this.index,
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.showExplanation,
    required this.isTimerActive,
    required this.onTap,
  }) : super(key: key);

  Color _getOptionColor(BuildContext context) {
    if (!isAnswered) {
      return isSelected ? Colors.blue.shade50 : Colors.grey.shade50;
    }
    if (showExplanation) {
      if (isCorrect) return Colors.green.shade50;
      if (isSelected && !isCorrect) return Colors.red.shade50;
    }
    return Colors.grey.shade50;
  }

  Color _getBorderColor(BuildContext context) {
    if (!isAnswered) {
      return isSelected ? Colors.blue : Colors.grey.shade300;
    }
    if (showExplanation) {
      if (isCorrect) return Colors.green;
      if (isSelected && !isCorrect) return Colors.red;
    }
    return Colors.grey.shade300;
  }

  /// Determines which icon to show based on the answer's state.
  Widget? _buildIcon() {
    // After the answer is revealed, show correctness.
    if (showExplanation) {
      if (isCorrect) {
        // This is the correct answer.
        return const Icon(Icons.check, size: 16, color: Colors.white);
      } else if (isSelected && !isCorrect) {
        // This was the user's incorrect selection.
        return const Icon(Icons.close, size: 16, color: Colors.white);
      }
    }
    // Before the answer is revealed, just show if it's selected.
    else if (isSelected) {
      return const Icon(Icons.check, size: 16, color: Colors.white);
    }
    // In all other cases (e.g., unselected), show no icon.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // The background color of the leading circle should fill if the option is
    // selected, OR if it's the correct answer being shown.
    final circleColor = isSelected || (showExplanation && isCorrect)
        ? _getBorderColor(context)
        : Colors.transparent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isTimerActive && !isAnswered ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getOptionColor(context),
            border: Border.all(
              color: _getBorderColor(context),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getBorderColor(context),
                    width: 2,
                  ),
                  color: circleColor,
                ),
                child: _buildIcon(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '${String.fromCharCode(65 + index)}. $option',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              // The trailing icons have been removed from here.
            ],
          ),
        ),
      ),
    );
  }
}