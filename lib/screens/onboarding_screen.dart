// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth/signup_screen.dart'; // Import your existing signup screen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<OnboardingData> onboardingData = [
    OnboardingData(
      title: "Test your brain \nwith fun daily quizzes",
      image: 'assets/images/brain.png', // Use your own icon or image
    ),
    OnboardingData(
      title: "Learn new facts \nand boost your knowledge",
      image: 'assets/images/learn.png',
    ),
    OnboardingData(
      title: "Challenge friends \nand climb the leaderboard!",
      image: 'assets/images/win.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                        // iOS-like haptic feedback
                        HapticFeedback.lightImpact();
                      },
                      itemCount: onboardingData.length,
                      itemBuilder: (context, index) {
                        return OnboardingPage(
                          data: onboardingData[index],
                          constraints: constraints,
                        );
                      },
                    ),
                  ),
                  
                  // Page indicator
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentPage == index ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? Color(0xFF8B5CF6)
                                : Color(0xFF8B5CF6).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Navigation buttons
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentPage < onboardingData.length - 1)
                          TextButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _pageController.animateToPage(
                                onboardingData.length - 1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              minimumSize: const Size(60, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Color(0xff8757f7),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 60),
                        
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: currentPage == onboardingData.length - 1 ? 140 : 120,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              if (currentPage < onboardingData.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                // Navigate to your existing signup screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B5CF6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              ),
                              elevation: 0,
                              shadowColor: Colors.black.withOpacity(0.1),
                            ),
                            child: Text(
                              currentPage < onboardingData.length - 1
                                  ? 'Next'
                                  : 'Get Started',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final BoxConstraints constraints;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = constraints.maxHeight;
    final screenWidth = constraints.maxWidth;
    
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenHeight),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.08),
              
              // Illustration container with iOS-like design
              Container(
                width: screenWidth * 0.9,
                height: screenWidth * 0.9,
                constraints: const BoxConstraints(
                  minWidth: 280,
                  minHeight: 280,
                  maxWidth: 360,
                  maxHeight: 360,
                ),
               
                child: Center(

                    child: Image.asset(
                      data.image,
                      width: screenWidth * 1,
                      height: screenWidth * 1,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            
              
              SizedBox(height: screenHeight * 0.08),
              
              // Title with responsive font size
              Text(
                data.title,
                style: TextStyle(
                  fontSize: screenWidth * 0.065,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 119, 62, 252),
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: screenHeight * 0.025),
              
              SizedBox(height: screenHeight * 0.3),
            ],
          ),
        ),
      ),
    );
  }
}
class OnboardingData {
  final String title;
  final String image;

  OnboardingData({
    required this.title,
    required this.image,
  });
}