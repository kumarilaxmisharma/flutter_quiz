import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileLoadingShimmer extends StatelessWidget {
  const ProfileLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(height: 280, color: Colors.white),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))),
                      const SizedBox(width: 16),
                      Expanded(child: Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 12),
                  Container(height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}