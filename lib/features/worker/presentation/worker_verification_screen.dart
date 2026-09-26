import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_button.dart';
import '../../../providers/app_providers.dart';

class WorkerVerificationScreen extends ConsumerWidget {
  const WorkerVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worker = ref.watch(workerRepositoryProvider).currentWorker;

    return Scaffold(
      appBar: const NanmaAppBar(
        title: 'Worker Verification',
        subtitle: 'തിരിച്ചറിയൽ പരിശോധന',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verified Badge Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8F1),
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: AppColors.primaryGreen),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Nanma Verified Partner',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryGreen),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Badge ID: NM-KL-2026-8841',
                          style: TextStyle(fontSize: 11, color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Verification Checkpoints
            const Text(
              'Verification Documents',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),

            _buildDocItem('Government Identity (Aadhaar Card)', 'XXXX-XXXX-4819', isVerified: true),
            _buildDocItem('Police Verification & Background', 'Passed clean record check', isVerified: true),
            _buildDocItem('Driving License & Vehicle', 'Two Wheeler: KL-07-CF-4210', isVerified: true),
            _buildDocItem('Bank Account & IFSC', 'State Bank of India (Panampilly Branch)', isVerified: true),
            _buildDocItem('Community Reference / Guarantor', 'Ward Councillor Endorsement', isVerified: true),
            const SizedBox(height: 20),

            // Safety standards commitment card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_rounded, color: AppColors.primaryGreen, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All Nanma workers commit to neighborhood safety, polite communication, and transparent billing.',
                      style: TextStyle(fontSize: 12, color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            NanmaButton(
              text: 'Update Bank or Vehicle Details',
              backgroundColor: AppColors.navyBlue,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document update modal opened.')),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDocItem(String title, String detail, {required bool isVerified}) {
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
          Icon(
            isVerified ? Icons.check_circle_rounded : Icons.pending_rounded,
            color: isVerified ? AppColors.primaryGreen : AppColors.darkOrange,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(detail, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isVerified ? AppColors.ultraLightGreen : AppColors.cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isVerified ? 'Verified' : 'Pending',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isVerified ? AppColors.primaryGreen : AppColors.darkOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
