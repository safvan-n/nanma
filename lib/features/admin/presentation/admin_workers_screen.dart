import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../providers/app_providers.dart';

class AdminWorkersScreen extends ConsumerWidget {
  const AdminWorkersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workers = ref.watch(adminRepositoryProvider).workers;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verified Worker Fleet',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 6),
          const Text('Monitor worker verification statuses, job completions and ratings', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: workers.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final worker = workers[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppDimensions.roundedMd,
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: AppDimensions.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: AppColors.ultraLightGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.handyman_rounded, color: AppColors.primaryGreen, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(worker.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark)),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified_rounded, size: 16, color: AppColors.primaryGreen),
                                  ],
                                ),
                                Text(worker.primarySkill, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, size: 14, color: AppColors.accentOrange),
                                    Text(' ${worker.rating} • ${worker.completedJobs} jobs', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Text('• ${worker.vehicleType}', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: worker.isOnline ? AppColors.ultraLightGreen : AppColors.cream,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              worker.isOnline ? 'Online' : 'Offline',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: worker.isOnline ? AppColors.primaryGreen : AppColors.darkOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: AppColors.divider),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Viewing documents for ${worker.fullName}')),
                              );
                            },
                            child: const Text('View Docs', style: TextStyle(color: AppColors.navyBlue)),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${worker.fullName} credentials verified & re-certified.')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primaryGreen),
                            ),
                            child: const Text('Re-verify', style: TextStyle(color: AppColors.primaryGreen)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
