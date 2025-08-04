import 'package:flutter/material.dart';
import 'package:flutter_final/main.dart';
import 'package:flutter_final/screens/auth/forgotpassword_screen.dart';
import 'package:flutter_final/screens/auth/login_screen.dart';
import 'package:flutter_final/screens/auth/signup_screen.dart';
import 'package:flutter_final/screens/onboarding_screen.dart';
import 'package:flutter_final/screens/profile_screen.dart';
import 'package:flutter_final/screens/splash_screen.dart';
import 'package:flutter_final/screens/summary_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  
  static const String summary = '/summary';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
        
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      // ✅ The '/quiz' route has been REMOVED.
      // MainScreen now handles showing the QuizScreen directly.

      case summary:
        final args = settings.arguments as Map<String, dynamic>;
        
        // ✅ This call is simpler and matches the new SummaryScreen.
        // It no longer passes onGoHome or onRestartQuiz.
        return MaterialPageRoute(
          builder: (_) => SummaryScreen(
            correctAnswers: args['correctAnswers'],
            totalQuestions: args['totalQuestions'],
            questions: args['questions'],
            selectedAnswers: args['selectedAnswers'],
            language: args['language'],
            onRestartQuiz: () {  }, 
            // onGoHome: () {  },
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}