import 'package:flutter/material.dart';
import 'package:flutter_final/models/question.dart';

// ✅ MAKE SURE THESE IMPORTS ARE AT THE TOP
// This is the most important part of the fix.
import 'package:flutter_final/widgets/quiz/answer_option.dart';
import 'package:flutter_final/widgets/quiz/explanation_widget.dart';
import 'package:flutter_final/widgets/quiz/question_text.dart';

class QuizQuestionCard extends StatelessWidget {
  final Question question;
  final String selectedLanguage;
  final String? selectedAnswer;
  final bool showExplanation;
  final bool isTimerActive;
  final Function(String) onSelectAnswer;

  const QuizQuestionCard({
    Key? key,
    required this.question,
    required this.selectedLanguage,
    required this.selectedAnswer,
    required this.showExplanation,
    required this.isTimerActive,
    required this.onSelectAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAnswered = selectedAnswer != null;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            QuestionText(
              questionText: question.getQuestion(selectedLanguage),
            ),
            const SizedBox(height: 24),
            ...question.getOptions(selectedLanguage).asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              final cleanOption = option.replaceAll('u00b0', '°');

              return AnswerOption(
                index: index,
                option: cleanOption,
                isSelected: selectedAnswer == cleanOption,
                isCorrect: cleanOption == question.answerCode,
                isAnswered: isAnswered,
                showExplanation: showExplanation,
                isTimerActive: isTimerActive,
                onTap: () => onSelectAnswer(cleanOption),
              );
            }).toList(),
            if (showExplanation)
              ExplanationWidget(
                isCorrect: selectedAnswer == question.answerCode,
                correctAnswer: question.answerCode,
              ),
          ],
        ),
      ),
    );
  }

}