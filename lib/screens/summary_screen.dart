import 'package:flutter/material.dart';
import '../models/question.dart';

// Import the separated widget components
import '../widgets/summary/summary_app_bar.dart';
import '../widgets/summary/summary_header.dart';
import '../widgets/summary/summary_actions.dart';
import '../widgets/summary/summary_questions_list.dart';

class SummaryScreen extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final List<Question> questions;
  final List<String?> selectedAnswers;
  final String language;
  final VoidCallback onRestartQuiz;
  // final VoidCallback onGoHome;

  const SummaryScreen({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.questions,
    required this.selectedAnswers,
    required this.language,
    required this.onRestartQuiz,
    // required this.onGoHome,
  }) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _listAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _listAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _listAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scorePercentage = widget.correctAnswers / widget.totalQuestions;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SummaryAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: SummaryHeader(
                correctAnswers: widget.correctAnswers,
                totalQuestions: widget.totalQuestions,
                scorePercentage: scorePercentage,
              ),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SummaryActions(
                // onGoHome: widget.onGoHome,
                onRestartQuiz: widget.onRestartQuiz,
              ),
            ),
            const SizedBox(height: 32),
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SummaryQuestionsList(
                  questions: widget.questions,
                  selectedAnswers: widget.selectedAnswers,
                  language: widget.language,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}