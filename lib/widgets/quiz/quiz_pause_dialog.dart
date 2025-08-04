import 'package:flutter/material.dart';

class QuizPauseDialog extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onExit;

  const QuizPauseDialog({
    Key? key,
    required this.onContinue,
    required this.onExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quiz Paused'),
      content: const Text('The timer is paused. You can continue when you are ready.'),
      actions: [
        TextButton(
          onPressed: onExit,
          child: const Text('Exit Quiz'),
        ),
        ElevatedButton(
          onPressed: onContinue,
          child: const Text('Continue'),
        ),
      ],
    );
  }
}