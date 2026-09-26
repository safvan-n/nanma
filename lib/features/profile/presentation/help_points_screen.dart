import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/help_points_model.dart';
import '../../../widgets/nanma_app_bar.dart';

class HelpPointsScreen extends StatelessWidget {
  const HelpPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const pointsData = HelpPointsModel();

    return Scaffold(
      appBar: const NanmaAppBar(
        title: 'Nanma Help Points',
        subtitle: 'നന്മ ഹെൽപ്പ് പോയിന്റുകൾ',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Points Banner Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.darkGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppDimensions.roundedMd,
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Column(
                children: [
                  const Text(
                    'Available Points',
                    style: TextStyle(color: Color(0xFFC8E6C9), fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${pointsData.currentPoints}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Equivalent to ₹120 in service discounts',
                    style: TextStyle(color: AppColors.cream, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0x33FFFFFF), height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat('Earned', '${pointsData.totalEarned} pts'),
                      Container(width: 1, height: 24, color: const Color(0x33FFFFFF)),
                      _buildHeaderStat('Redeemed', '${pointsData.totalUsed} pts'),
                      Container(width: 1, height: 24, color: const Color(0x33FFFFFF)),
                      _buildHeaderStat('Rating', '${pointsData.rating} ⭐'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Achievements
            const Text(
              'Badges & Achievements',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pointsData.achievements.map((ach) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.workspace_premium_rounded, size: 18, color: AppColors.accentOrange),
                      const SizedBox(width: 6),
                      Text(
                        ach,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Points History
            const Text(
              'Points Activity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            ...pointsData.history.map((tx) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: tx.isEarned ? AppColors.ultraLightGreen : const Color(0xFFFFEBEE),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        tx.isEarned ? Icons.add_rounded : Icons.remove_rounded,
                        color: tx.isEarned ? AppColors.primaryGreen : AppColors.emergencyRed,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark),
                          ),
                          const SizedBox(height: 2),
                          Text(tx.date, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                    Text(
                      '${tx.isEarned ? '+' : '-'}${tx.points} pts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: tx.isEarned ? AppColors.primaryGreen : AppColors.emergencyRed,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Color(0xFFC8E6C9), fontSize: 11)),
      ],
    );
  }
}
