import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final/constants/AppRouter.dart';
import 'dart:async';
import 'package:flutter_final/models/category_detail.dart';
import 'package:flutter_final/services/report_service.dart';
import 'package:flutter_final/services/quiz_navigation_service.dart';

// Importing all the separated UI widgets
import 'package:flutter_final/widgets/quiz/quiz_app_bar.dart';
import 'package:flutter_final/widgets/quiz/quiz_gradient_background.dart';
import 'package:flutter_final/widgets/quiz/quiz_progress_section.dart';
import 'package:flutter_final/widgets/quiz/quiz_question_card.dart';
import 'package:flutter_final/widgets/quiz/quiz_navigation_buttons.dart';
import 'package:flutter_final/widgets/quiz/quiz_pause_dialog.dart';
import 'package:flutter_final/widgets/quiz/quiz_result_dialog.dart';

class QuizScreen extends StatefulWidget {
  final CategoryDetail categoryDetail;
  final String language;

  const QuizScreen({
    Key? key,
    required this.categoryDetail,
    required this.language,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  List<String?> selectedAnswers = [];
  String selectedLanguage = '';

  Timer? _timer;
  int _timeRemaining = 30;
  bool _isTimerActive = true;

  late AnimationController _progressAnimationController;
  late AnimationController _questionAnimationController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showExplanation = false;
  DateTime? _quizStartTime;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.language;
    selectedAnswers = List.filled(widget.categoryDetail.questions.length, null);
    _quizStartTime = DateTime.now();
    _initializeAnimations();
    _startTimer();
    _animateProgress();
    _questionAnimationController.forward();
  }

  void _initializeAnimations() {
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _questionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressAnimationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _questionAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressAnimationController.dispose();
    _questionAnimationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timeRemaining = 30;
    _isTimerActive = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _isTimerActive = false;
          timer.cancel();
          _autoNextQuestion();
        }
      });
    });
  }

  void _animateProgress() {
    if (widget.categoryDetail.questions.isEmpty) {
      _progressAnimationController.animateTo(0);
      return;
    }
    final progress =
        (currentQuestionIndex + 1) / widget.categoryDetail.questions.length;
    _progressAnimationController.animateTo(progress);
  }

  void _autoNextQuestion() {
    if (selectedAnswers[currentQuestionIndex] == null) {
      setState(() {
         final currentQuestion = widget.categoryDetail.questions[currentQuestionIndex];
        final options = currentQuestion.getOptions(selectedLanguage);
        final wrongAnswer = options.firstWhere(
          (option) => option.replaceAll('u00b0', '°') != currentQuestion.answerCode,
          orElse: () => options.first,
        );
        selectedAnswers[currentQuestionIndex] = wrongAnswer.replaceAll('u00b0', '°');
      });
    }

    // Using a Timer so it can be cancelled if the user navigates manually
    _timer = Timer(const Duration(milliseconds: 500), () {
      if (currentQuestionIndex < widget.categoryDetail.questions.length - 1) {
        _nextQuestion();
      } else {
        _finishQuiz();
      }
    });
  }

  void _selectAnswer(String answer) {
    if (!_isTimerActive && selectedAnswers[currentQuestionIndex] != null) return;
    
    // Always cancel any existing timer before starting a new one
    _timer?.cancel();

    setState(() {
      selectedAnswers[currentQuestionIndex] = answer;
      _isTimerActive = false;
      _showExplanation = true;
    });

    // Use a cancellable Timer instead of Future.delayed
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        if (currentQuestionIndex < widget.categoryDetail.questions.length - 1) {
          _nextQuestion();
        } else {
          _finishQuiz();
        }
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.categoryDetail.questions.length - 1) {
      // ✅ FIX: Cancel any pending auto-advance timer to prevent race conditions
      _timer?.cancel();
      _questionAnimationController.reset();
      setState(() {
        currentQuestionIndex++;
        // ✅ FIX: Reset the explanation state for the new question
        _showExplanation = false;
      });
      _startTimer();
      _animateProgress();
      _questionAnimationController.forward();
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      // ✅ FIX: Cancel any pending auto-advance timer
      _timer?.cancel();
      _questionAnimationController.reset();
      setState(() {
        currentQuestionIndex--;
        _showExplanation = false;
      });
      _startTimer();
      _animateProgress();
      _questionAnimationController.forward();
    }
  }

  Future<void> _finishQuiz() async {
    if (!mounted) return;
    _timer?.cancel();

    final quizEndTime = DateTime.now();
    final totalTime = quizEndTime.difference(_quizStartTime!);
    int correctAnswers = 0;
    for (int i = 0; i < widget.categoryDetail.questions.length; i++) {
      if (selectedAnswers[i] == widget.categoryDetail.questions[i].answerCode) {
        correctAnswers++;
      }
    }

    try {
      await ReportService.submitQuizReport(score: correctAnswers);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save result: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    _showResultDialog(correctAnswers, totalTime);
  }

  void _showResultDialog(int correctAnswers, Duration totalTime) {
    final minutes = totalTime.inMinutes;
    final seconds = totalTime.inSeconds % 60;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => QuizResultDialog(
        correctAnswers: correctAnswers,
        totalQuestions: widget.categoryDetail.questions.length,
        minutes: minutes,
        seconds: seconds,
        onViewSummary: () {
          Navigator.of(dialogContext).pop();
          
          Navigator.pushNamed(
            context,
            AppRouter.summary,
            arguments: {
              'correctAnswers': correctAnswers,
              'totalQuestions': widget.categoryDetail.questions.length,
              'questions': widget.categoryDetail.questions,
              'selectedAnswers': selectedAnswers,
              'language': selectedLanguage,
            },
          );
        },
        onRetryQuiz: () {
          Navigator.of(dialogContext).pop();
          _retryQuiz();
        },
      ),
    );
  }

  void _retryQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedAnswers = List.filled(widget.categoryDetail.questions.length, null);
      _quizStartTime = DateTime.now();
    });
    _progressAnimationController.reset();
    _questionAnimationController.reset();
    _startTimer();
    _animateProgress();
    _questionAnimationController.forward();
  }

  void _pauseQuiz() {
    _timer?.cancel();
    showDialog(
      context: context,
      builder: (context) => QuizPauseDialog(
        onContinue: () {
          Navigator.of(context).pop();
          _startTimer();
        },
        onExit: () {
          Navigator.of(context).pop();
          QuizNavigationService.instance.endQuiz();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryDetail.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: Text('No questions available for this category.')),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        _pauseQuiz();
        return false;
      },
      child: Scaffold(
        appBar: QuizAppBar(
          categoryName: widget.categoryDetail.getName(selectedLanguage),
          timeRemaining: _timeRemaining,
          onPause: _pauseQuiz,
        ),
        body: QuizGradientBackground(
          child: Column(
            children: [
              QuizProgressSection(
                currentQuestion: currentQuestionIndex + 1,
                totalQuestions: widget.categoryDetail.questions.length,
                progressAnimation: _progressAnimation,
              ),
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: QuizQuestionCard(
                      question: widget.categoryDetail.questions[currentQuestionIndex],
                      selectedLanguage: selectedLanguage,
                      selectedAnswer: selectedAnswers[currentQuestionIndex],
                      showExplanation: _showExplanation,
                      isTimerActive: _isTimerActive,
                      onSelectAnswer: _selectAnswer,
                    ),
                  ),
                ),
              ),
              QuizNavigationButtons(
                currentQuestionIndex: currentQuestionIndex,
                totalQuestions: widget.categoryDetail.questions.length,
                isAnswered: selectedAnswers[currentQuestionIndex] != null,
                onPrevious: _previousQuestion,
                onNext: _nextQuestion,
                onFinish: _finishQuiz,
              ),
            ],
          ),
        ),
      ),
    );
  }
}