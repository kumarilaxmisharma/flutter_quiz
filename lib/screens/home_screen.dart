import 'package:flutter/material.dart';
import 'package:flutter_final/models/category_detail.dart';
import 'dart:async';

// Import services, models, and widgets
import 'package:flutter_final/services/auth_service.dart';
import 'package:flutter_final/services/category_service.dart';
import 'package:flutter_final/services/profile_service.dart';
import 'package:flutter_final/models/profile.dart';
import 'package:flutter_final/constants/AppRouter.dart';
import 'package:flutter_final/models/category.dart';

// ✅ Import the new service
import 'package:flutter_final/services/quiz_navigation_service.dart';

import 'package:flutter_final/widgets/category/category_card.dart';
import 'package:flutter_final/widgets/category/error_widget.dart';
import 'package:flutter_final/widgets/category/loading_widget.dart';
import 'package:flutter_final/widgets/category/language_selector.dart';

class HomeScreen extends StatefulWidget {
  // ✅ The constructor is now simpler and doesn't need a callback.
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State for language and data fetching
  String _selectedLanguage = 'en';
  Future<Profile>? _profileFuture;
  Future<List<Category>>? _categoriesFuture;

  // Static data for UI elements
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;

  final List<BannerItem> _bannerItems = [
    BannerItem(
      title: "Play quiz together with your friends now!",
      subtitle: "Challenge",
      gradient: const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    BannerItem(
      title: "Discover new topics and expand your knowledge!",
      subtitle: "Learn",
      gradient: const LinearGradient(
        colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadData();
    _startBannerAutoSlide();
  }

  /// Checks for an auth token before loading data. Redirects to login if not found.
  Future<void> _checkAuthAndLoadData() async {
    final token = await AuthService.getToken();
    if (token == null && mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    } else {
      _loadData();
    }
  }

  /// Loads all necessary data from the API.
  void _loadData() {
    setState(() {
      _profileFuture = ProfileService.getProfileInfo();
      _categoriesFuture = CategoryService.getCategories();
    });
  }

  /// Handles refreshing the data when the user pulls down.
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _loadData();
  }

  void _onLanguageChanged(String newLanguage) {
    setState(() {
      _selectedLanguage = newLanguage;
    });
  }

  void _startBannerAutoSlide() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _currentBannerIndex = (_currentBannerIndex + 1) % _bannerItems.length;
      _bannerController.animateToPage(
        _currentBannerIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }
  
  // ✅ This method is now updated to use the new navigation service.
  void _onCategoryTapped(int categoryId) async {
    // Show a loading indicator while fetching details
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final categoryDetail = await CategoryService.getCategoryDetail(categoryId);
      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading dialog

      if (categoryDetail.questions.isEmpty) {
        // Show a message if the quiz has no questions
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('This quiz is not available yet.'),
              backgroundColor: Colors.orange),
        );
      } else {
        // Use the service to start the quiz.
        // MainScreen will listen to this and show the QuizScreen automatically.
        QuizNavigationService.instance.startQuiz(categoryDetail);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }

  /// Logs the user out and navigates back to the login screen.
  void _logout(String? message) async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.login);
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.blue),
        );
      }
    }
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildPromotionalBanner(),
                  const SizedBox(height: 30),
                  _buildDiscoverSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<Profile>(
          future: _profileFuture,
          builder: (context, snapshot) {
            final String name = snapshot.hasData ? snapshot.data!.fullName : 'Player';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Welcome Back!", style: TextStyle(color: Colors.grey)),
                Text(
                  name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
        Row(
          children: [
            LanguageSelector(
              selectedLanguage: _selectedLanguage,
              onLanguageChanged: _onLanguageChanged,
            ),
            const SizedBox(width: 8),
            
          ],
        )
      ],
    );
  }

  Widget _buildPromotionalBanner() {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: _bannerItems.length,
        onPageChanged: (index) => setState(() => _currentBannerIndex = index),
        itemBuilder: (context, index) {
          final banner = _bannerItems[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: banner.gradient,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    banner.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiscoverSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Discover",
              style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => _showAllQuizzes(),
              child: const Text(
                "View all",
                style: TextStyle(color: Color(0xFF8B5CF6), fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        FutureBuilder<List<Category>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget(message: 'Finding quizzes...');
            }
            if (snapshot.hasError) {
              return ErrorDisplayWidget(
                message: "Could not load quizzes. Please try again.",
                onRetry: _refreshData,
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No quizzes found."));
            }

            final categories = snapshot.data!;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  category: category,
                  language: _selectedLanguage,
                  onTap: () => _onCategoryTapped(category.id),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _showAllQuizzes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("All Quizzes", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Category>>(
                  future: _categoriesFuture, // Reuse the same future
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingWidget();
                    }
                    if (snapshot.hasError) {
                      return ErrorDisplayWidget(
                        message: "Could not load quizzes.",
                        onRetry: () {
                          Navigator.pop(context);
                          _refreshData();
                        },
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No quizzes available."));
                    }
                    final categories = snapshot.data!;
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryCard(
                          category: category,
                          language: _selectedLanguage,
                          onTap: () {
                            Navigator.pop(context);
                            _onCategoryTapped(category.id);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Helper class for static UI data
class BannerItem {
  final String title;
  final String subtitle;
  final Gradient gradient;
  BannerItem({required this.title, required this.subtitle, required this.gradient});
}