import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/nanma_button.dart';
import '../../../widgets/decorative_leaf_background.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecorativeLeafBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                // Location Pin Visual with Pulsing Halo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.ultraLightGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 64,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                const Text(
                  'Allow location access',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Nanma uses your location to discover verified community helpers nearby, provide precise delivery estimates, and enable live tracking of tasks.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Security / Trust note
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: AppColors.leafGreen, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Your location is only shared with your assigned worker during an active request.',
                          style: TextStyle(fontSize: 12, color: AppColors.textDark),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Buttons
                NanmaButton(
                  text: 'Allow Location Access',
                  icon: Icons.my_location_rounded,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Location permission granted. Nearest helpers loaded.'),
                        backgroundColor: AppColors.primaryGreen,
                      ),
                    );
                    context.go('/home');
                  },
                ),
                const SizedBox(height: 14),
                NanmaOutlinedButton(
                  text: 'Enter Address Manually',
                  onPressed: () {
                    // Manual entry allowed, doesn't block the app
                    context.go('/home');
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
