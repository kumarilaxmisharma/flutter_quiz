import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// This is the missing StatefulWidget class
class LayeredNavigationBar extends StatefulWidget {
  final Function(int) onTabChanged;
  final int currentIndex;

  const LayeredNavigationBar({
    super.key,
    required this.onTabChanged,
    this.currentIndex = 0,
  });

  @override
  State<LayeredNavigationBar> createState() => _LayeredNavigationBarState();
}

// This is the State class you already have
class _LayeredNavigationBarState extends State<LayeredNavigationBar> {
  // CHANGED: The 'Quiz' item has been removed from this list.
  final List<NavigationItem> _items = [
    NavigationItem(icon: CupertinoIcons.house_fill, label: 'Home'),
    NavigationItem(icon: CupertinoIcons.chart_bar_fill, label: 'Leaderboard'),
    NavigationItem(icon: CupertinoIcons.person_fill, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = widget.currentIndex == index;

          return AnimatedScale(
            scale: isSelected ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: GestureDetector(
              onTap: () {
                widget.onTabChanged(index);
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF4F7CFF)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(
                      item.icon,
                      size: 22,
                      color: isSelected ? Colors.white : Colors.white54,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.label,
  });
}