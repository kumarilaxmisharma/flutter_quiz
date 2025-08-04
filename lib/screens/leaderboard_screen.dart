import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
// import '../models/top_player.dart';
// import '../services/report_service.dart';

// Mock TopPlayer class for demonstration
class TopPlayer {
  final int userId;
  final String fullName;
  final String? firstName;
  final String? lastName;
  final int totalScore;

  TopPlayer({
    required this.userId,
    required this.fullName,
    this.firstName,
    this.lastName,
    required this.totalScore,
  });
}

// Mock ReportService for demonstration
class ReportService {
  static Future<List<TopPlayer>> getTopPlayers() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      TopPlayer(userId: 1, fullName: 'Player 10', firstName: 'Player', lastName: '10', totalScore: 380),
      TopPlayer(userId: 2, fullName: 'Sodina Bin', firstName: 'Sodina', lastName: 'Bin', totalScore: 34),
      TopPlayer(userId: 3, fullName: 'Laxmi Sharma', firstName: 'Laxmi', lastName: 'Sharma', totalScore: 12),
      TopPlayer(userId: 4, fullName: 'Player 17', firstName: 'Player', lastName: '17', totalScore: 4),
      TopPlayer(userId: 5, fullName: 'Theary Name', firstName: 'Theary', lastName: 'Name', totalScore: 2),
    ];
  }
}

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Future<List<TopPlayer>> _leaderboardFuture;
  int _selectedTabIndex = 1; // 0 for Weekly, 1 for All Time

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  void _fetchLeaderboard() {
    setState(() {
      _leaderboardFuture = ReportService.getTopPlayers();
    });
  }

  Future<void> _refresh() async {
    _fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 8),
              _buildTabs(),
              const SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  color: Colors.white,
                  backgroundColor: const Color(0xFF7C4DFF),
                  child: FutureBuilder<List<TopPlayer>>(
                    future: _leaderboardFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingShimmer();
                      }
                      if (snapshot.hasError) {
                        return _buildErrorWidget(snapshot.error);
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No players on the leaderboard yet.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }

                      final players = snapshot.data!;
                      final topThree = players.take(3).toList();
                      final restOfPlayers = players.skip(3).toList();

                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            if (topThree.isNotEmpty) _buildPodium(topThree),
                            const SizedBox(height: 20),
                            if (restOfPlayers.isNotEmpty) _buildPlayerList(restOfPlayers),
                            const SizedBox(height: 100), // Bottom padding for navigation
                          ],
                        ),
                      ).animate().fade(duration: 500.ms).slideY(begin: 0.2);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Leaderboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
           // Balance the back button
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            _buildTabItem('Weekly', 0),
            _buildTabItem('All Time', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Weekly leaderboard is coming soon!'),
                backgroundColor: const Color.fromARGB(255, 246, 161, 57),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
            return;
          }
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.25) : Colors.transparent,
            borderRadius: BorderRadius.circular(21),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPodium(List<TopPlayer> topThree) {
    final first = topThree.isNotEmpty ? topThree[0] : null;
    final second = topThree.length > 1 ? topThree[1] : null;
    final third = topThree.length > 2 ? topThree[2] : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Player info section
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (second != null) 
                  Expanded(child: _buildPodiumPlayer(second, 2)),
                if (first != null) 
                  Expanded(child: _buildPodiumPlayer(first, 1)),
                if (third != null) 
                  Expanded(child: _buildPodiumPlayer(third, 3)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Podium bases section
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (second != null) 
                  Expanded(child: _buildPodiumBase(2, 75)),
                if (first != null) 
                  Expanded(child: _buildPodiumBase(1, 100)),
                if (third != null) 
                  Expanded(child: _buildPodiumBase(3, 75)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlayer(TopPlayer player, int rank) {
    final Color rankColor = _getRankColor(rank);
    final double avatarSize = rank == 1 ? 70 : 60;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (rank == 1) ...[
          const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
          const SizedBox(height: 4),
        ],
        _buildAvatar(player, size: avatarSize, borderColor: rankColor),
        const SizedBox(height: 8),
        Flexible(
          child: Text(
            _getDisplayName(player),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: rank == 1 ? 14 : 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${player.totalScore} pts',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumBase(int rank, double height) {
    final Color rankColor = _getRankColor(rank);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.15),
          ],
        ),
      ),
      child: Center(
        child: Text(
          '$rank',
          style: TextStyle(
            fontSize: rank == 1 ? 48 : 40,
            fontWeight: FontWeight.bold,
            color: rankColor,
            shadows: [
              Shadow(
                blurRadius: 8.0,
                color: rankColor.withOpacity(0.5),
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerList(List<TopPlayer> players) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          ...players.asMap().entries.map((entry) {
            final index = entry.key;
            final player = entry.value;
            final rank = index + 4;
            return _buildPlayerListItem(player, rank)
                .animate()
                .fade(delay: (100 * index).ms, duration: 400.ms)
                .slideX(begin: 0.2);
          }).toList(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPlayerListItem(TopPlayer player, int rank) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          _buildAvatar(player, size: 45),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.fullName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${player.totalScore} Points',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey.shade400,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(TopPlayer player, {double size = 50, Color? borderColor}) {
    String initials = _getInitials(player);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getAvatarColor(player.userId),
        border: borderColor != null ? Border.all(color: borderColor, width: 3) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.35,
          ),
        ),
      ),
    );
  }

  String _getInitials(TopPlayer player) {
    String initials = '';
    if (player.firstName?.isNotEmpty == true) {
      initials += player.firstName![0];
    }
    if (player.lastName?.isNotEmpty == true) {
      initials += player.lastName![0];
    }
    if (initials.isEmpty && player.fullName.isNotEmpty) {
      final nameParts = player.fullName.split(' ');
      initials = nameParts.length > 1 
          ? '${nameParts[0][0]}${nameParts[1][0]}'
          : player.fullName[0];
    }
    return initials.isEmpty ? '?' : initials;
  }

  String _getDisplayName(TopPlayer player) {
    if (player.fullName.length > 12) {
      final nameParts = player.fullName.split(' ');
      if (nameParts.length > 1) {
        return '${nameParts[0]} ${nameParts[1][0]}.';
      }
      return '${player.fullName.substring(0, 10)}...';
    }
    return player.fullName;
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.grey;
    }
  }

  Color _getAvatarColor(int userId) {
    final colors = [
      Colors.redAccent,
      Colors.green,
      Colors.blueAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
    ];
    return colors[userId % colors.length];
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.3),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Podium shimmer
            Container(
              height: 250,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShimmerPodiumPlayer(),
                        _buildShimmerPodiumPlayer(),
                        _buildShimmerPodiumPlayer(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: _buildShimmerPodiumBase(75)),
                        Expanded(child: _buildShimmerPodiumBase(100)),
                        Expanded(child: _buildShimmerPodiumBase(75)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // List shimmer
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: List.generate(
                  5,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerPodiumPlayer() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 60,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerPodiumBase(double height) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Failed to load Leaderboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF7C4DFF),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}