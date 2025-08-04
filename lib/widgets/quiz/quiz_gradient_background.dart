import 'package:flutter/material.dart';

class QuizGradientBackground extends StatelessWidget {
  final Widget child;

  const QuizGradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF8F8F8), // A very light grey for a subtle effect
          ],
        ),
      ),
      child: child,
    );
  }
}