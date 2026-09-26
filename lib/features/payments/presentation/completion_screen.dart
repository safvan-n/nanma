import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/nanma_button.dart';
import '../../../widgets/decorative_leaf_background.dart';

class CompletionScreen extends StatelessWidget {
  final String requestId;
  final String? total;

  const CompletionScreen({
    super.key,
    required this.requestId,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecorativeLeafBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Green checkmark badge with glow
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 54),
                ),
                const SizedBox(height: 24),

                const Text(
                  '✓ Request Completed',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'സേവനം വിജയകരമായി പൂർത്തിയായി',
                  style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                ),
                const SizedBox(height: 32),

                // Summary Receipt Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppDimensions.roundedMd,
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: AppDimensions.cardShadow,
                  ),
                  child: Column(
                    children: [
                      _buildReceiptRow('Worker', 'Ravi Kumar (Verified)'),
                      const Divider(height: 16, color: AppColors.divider),
                      _buildReceiptRow('Total Paid', '₹${total != null ? double.tryParse(total!)?.toStringAsFixed(0) ?? '500' : '500'}'),
                      const Divider(height: 16, color: AppColors.divider),
                      _buildReceiptRow('Payment Status', 'Paid via UPI (Success)', isSuccess: true),
                      const Divider(height: 16, color: AppColors.divider),
                      _buildReceiptRow('Help Points Earned', '+50 Nanma Points ⭐', isPoints: true),
                    ],
                  ),
                ),
                const Spacer(),

                // Buttons
                NanmaButton(
                  text: 'Rate Worker & Experience ⭐',
                  onPressed: () => context.push('/rating/$requestId'),
                ),
                const SizedBox(height: 12),
                NanmaOutlinedButton(
                  text: 'Back to Home',
                  onPressed: () => context.go('/home'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isSuccess = false, bool isPoints = false}) {
    Color color = AppColors.textDark;
    if (isSuccess) color = AppColors.primaryGreen;
    if (isPoints) color = AppColors.darkOrange;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
