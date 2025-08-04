import 'package:flutter/foundation.dart';
import 'package:flutter_final/models/category_detail.dart';

/// A simple service to manage the global state of the active quiz.
/// This avoids the need to pass callback functions between screens.
class QuizNavigationService {
  // A private constructor to ensure this class can't be instantiated normally.
  QuizNavigationService._();

  // The single, shared instance of this service used throughout the app.
  static final instance = QuizNavigationService._();

  /// This is the core of the service.
  /// It holds the currently active quiz category. If the value is `null`, no quiz is active.
  /// A `ValueNotifier` automatically tells any listening widgets (like your MainScreen)
  /// to rebuild whenever its `value` changes.
  final ValueNotifier<CategoryDetail?> activeQuiz = ValueNotifier<CategoryDetail?>(null);

  /// Call this method to start a quiz.
  /// It sets the active quiz category, which will cause MainScreen to show the QuizScreen.
  void startQuiz(CategoryDetail category) {
    activeQuiz.value = category;
  }

  /// Call this method to end a quiz.
  /// It sets the active quiz back to `null`, which will cause MainScreen to hide
  /// the QuizScreen and show the home/tabs view.
  void endQuiz() {
    activeQuiz.value = null;
  }
}