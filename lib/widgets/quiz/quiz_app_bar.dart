import 'package:flutter/material.dart';

class QuizAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String categoryName;
  final int timeRemaining;
  final VoidCallback onPause;

  const QuizAppBar({
    Key? key,
    required this.categoryName,
    required this.timeRemaining,
    required this.onPause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('$categoryName Quiz'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey.shade800,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.cancel),
        color: Colors.grey.shade800,
        onPressed: onPause,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: timeRemaining <= 10
                ? Colors.red.shade100
                : const Color.fromARGB(255, 220, 207, 247),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer,
                size: 16,
                color: timeRemaining <= 10
                    ? Colors.red
                    : const Color.fromARGB(255, 134, 86, 247),
              ),
              const SizedBox(width: 4),
              Text(
                '${timeRemaining}s',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: timeRemaining <= 10
                      ? Colors.red
                      : const Color.fromARGB(255, 134, 86, 247),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}