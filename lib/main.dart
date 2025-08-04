import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_final/constants/AppRouter.dart';

// Models and Services
import 'package:flutter_final/models/category_detail.dart';
import 'package:flutter_final/services/quiz_navigation_service.dart';

// Screens
import 'package:flutter_final/screens/home_screen.dart';
import 'package:flutter_final/screens/leaderboard_screen.dart';
import 'package:flutter_final/screens/profile_screen.dart';
import 'package:flutter_final/screens/quiz_screen.dart';

// Widgets
import 'package:flutter_final/navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final quizNavigationService = QuizNavigationService.instance;

  // ✅ The list of screens is now simpler. HomeScreen doesn't need a callback.
  final List<Widget> _screens = [
    const HomeScreen(),
    const LeaderboardScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    // When a user taps a different tab, always end any active quiz.
    quizNavigationService.endQuiz();
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ This builder automatically listens for changes in the service.
      body: ValueListenableBuilder<CategoryDetail?>(
        valueListenable: quizNavigationService.activeQuiz,
        builder: (context, activeCategory, child) {
          // If a category is active in the service, show the QuizScreen.
          if (activeCategory != null) {
            return QuizScreen(
              categoryDetail: activeCategory,
              language: 'en',
            );
          }
          // Otherwise, show the normal tabbed screen (Home, Leaderboard, etc.).
          return _screens[_currentIndex];
        },
      ),
      bottomNavigationBar: LayeredNavigationBar(
        currentIndex: _currentIndex,
        onTabChanged: _onTabTapped,
      ),
    );
  }
}