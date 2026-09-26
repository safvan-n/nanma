import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class DecorativeLeafBackground extends StatelessWidget {
  final Widget child;
  final bool showBottomLeaves;

  const DecorativeLeafBackground({
    super.key,
    required this.child,
    this.showBottomLeaves = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background soft gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF2F8ED),
                AppColors.appBackground,
                Color(0xFFFAFCF8),
              ],
            ),
          ),
        ),

        // Top decorative organic soft shapes
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lightGreen.withValues(alpha: 0.18),
            ),
          ),
        ),
        Positioned(
          top: -40,
          left: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondaryGreen.withValues(alpha: 0.12),
            ),
          ),
        ),

        // Optional bottom decorative shapes
        if (showBottomLeaves) ...[
          Positioned(
            bottom: -60,
            right: -40,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGreen.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -50,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightGreen.withValues(alpha: 0.15),
              ),
            ),
          ),
        ],

        // Main content
        child,
      ],
    );
  }
}
