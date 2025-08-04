import 'package:flutter/material.dart';

class SummaryHeader extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final double scorePercentage;

  const SummaryHeader({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.scorePercentage,
  }) : super(key: key);

  @override
  State<SummaryHeader> createState() => _SummaryHeaderState();
}

class _SummaryHeaderState extends State<SummaryHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.scorePercentage,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 600), () {
      _progressController.forward();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Color _getScoreColor() {
    if (widget.scorePercentage >= 0.8) return Colors.green;
    if (widget.scorePercentage >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _getScoreMessage() {
    if (widget.scorePercentage >= 0.9) return "Outstanding! 🎉";
    if (widget.scorePercentage >= 0.8) return "Excellent work! 👏";
    if (widget.scorePercentage >= 0.7) return "Good job! 👍";
    if (widget.scorePercentage >= 0.6) return "Not bad! 🙂";
    return "Keep practicing! 💪";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical:24, horizontal: 90),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Your Result',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getScoreMessage(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return CircularProgressIndicator(
                            value: _progressAnimation.value,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getScoreColor(),
                            ),
                          );
                        },
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return Text(
                                  '${(_progressAnimation.value * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: _getScoreColor(),
                                  ),
                                );
                              },
                            ),
                            Text(
                              'Score',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _getScoreColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getScoreColor().withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '${widget.correctAnswers} / ${widget.totalQuestions} Correct',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getScoreColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.scorePercentage >= 0.7 ? Icons.emoji_events : Icons.trending_up,
                color: _getScoreColor(),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}