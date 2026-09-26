import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/decorative_leaf_background.dart';
import '../../../providers/app_providers.dart';

class ElderlyModeScreen extends ConsumerWidget {
  const ElderlyModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCF7),
      body: DecorativeLeafBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with Exit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'നന്മ • NANMA',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        Text(
                          'എളുപ്പമുള്ള സഹായ മോഡ് (Elderly Mode)',
                          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        ref.read(elderlyModeProvider.notifier).state = false;
                        context.go('/home');
                      },
                      icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textDark),
                      label: const Text('Exit', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Large Action Buttons (Requirement 35)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 1. REQUEST HELP
                      _buildLargeElderlyButton(
                        context: context,
                        title: AppStrings.elderlyRequestHelp,
                        subtitle: 'സഹായം ആവശ്യപ്പെടുക (Groceries, Medicines)',
                        icon: Icons.volunteer_activism_rounded,
                        bgColor: AppColors.primaryGreen,
                        fgColor: Colors.white,
                        onTap: () => context.push('/requests/smart-request'),
                      ),

                      // 2. CALL NANMA
                      _buildLargeElderlyButton(
                        context: context,
                        title: AppStrings.elderlyCallNanma,
                        subtitle: 'നന്മ ഹെൽപ്പ്‌ലൈനിലേക്ക് വിളിക്കുക',
                        icon: Icons.phone_in_talk_rounded,
                        bgColor: AppColors.navyBlue,
                        fgColor: Colors.white,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Calling Nanma Senior Assistance Desk: 1800-425-NANMA'),
                              backgroundColor: AppColors.navyBlue,
                            ),
                          );
                        },
                      ),

                      // 3. WHATSAPP
                      _buildLargeElderlyButton(
                        context: context,
                        title: AppStrings.elderlyWhatsApp,
                        subtitle: 'വാട്ട്സ്ആപ്പ് വഴി സന്ദേശം അയക്കുക',
                        icon: Icons.chat_rounded,
                        bgColor: const Color(0xFF25D366),
                        fgColor: Colors.white,
                        onTap: () => context.push('/whatsapp-assist'),
                      ),

                      // 4. MY REQUESTS
                      _buildLargeElderlyButton(
                        context: context,
                        title: AppStrings.elderlyMyRequests,
                        subtitle: 'നിലവിലെ സേവനങ്ങൾ കാണുക',
                        icon: Icons.assignment_turned_in_rounded,
                        bgColor: Colors.white,
                        fgColor: AppColors.textDark,
                        borderColor: AppColors.borderSubtle,
                        onTap: () {
                          ref.read(customerNavIndexProvider.notifier).state = 1;
                          context.go('/home');
                        },
                      ),

                      // 5. EMERGENCY (RED ONLY)
                      _buildLargeElderlyButton(
                        context: context,
                        title: AppStrings.elderlyEmergency,
                        subtitle: 'അടിയന്തര സഹായം / ആംബുലൻസ് (SOS)',
                        icon: Icons.warning_rounded,
                        bgColor: AppColors.emergencyRed,
                        fgColor: Colors.white,
                        onTap: () => context.push('/emergency'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeElderlyButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color bgColor,
    required Color fgColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 76,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null ? Border.all(color: borderColor, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: fgColor, size: 34),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: fgColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: fgColor.withValues(alpha: 0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: fgColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
