import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/user_model.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../providers/app_providers.dart';

class ProfileScreen extends ConsumerWidget {
  final bool isEmbedded;

  const ProfileScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider) ??
        const UserModel(
          id: 'guest',
          phoneNumber: '+91 98765 43210',
          fullName: 'Anjali Menon',
          address: 'Flat 4B, Palm Grove, Panampilly Nagar',
          pincode: '682036',
          district: 'Ernakulam',
        );

    final isElderly = ref.watch(elderlyModeProvider);

    return Scaffold(
      appBar: NanmaAppBar(
        title: 'Profile',
        subtitle: 'പ്രൊഫൈൽ',
        showBackButton: !isEmbedded,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.ultraLightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded, size: 40, color: AppColors.primaryGreen),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.phoneNumber,
                          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${user.district}, Kerala',
                          style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primaryGreen),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit profile dialog opened.')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Help Points Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: InkWell(
                onTap: () => context.push('/profile/points'),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.star_rounded, color: AppColors.accentOrange, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Help Points: ',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
                              ),
                              Text(
                                '${user.helpPoints}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryGreen),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Earned for supporting community & errands',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Navigation sections
            _buildSectionTitle('Services & Care'),
            _buildTile(
              icon: Icons.elderly_rounded,
              title: 'Simplified Elderly Mode',
              subtitle: 'Extra large buttons & simple navigation',
              trailing: Switch(
                value: isElderly,
                activeThumbColor: AppColors.primaryGreen,
                onChanged: (val) {
                  ref.read(elderlyModeProvider.notifier).state = val;
                  if (val) {
                    context.push('/elderly');
                  }
                },
              ),
            ),
            _buildTile(
              icon: Icons.family_restroom_rounded,
              title: 'Family Assist',
              subtitle: 'Manage parents & relatives care requests',
              onTap: () => context.push('/family'),
            ),
            _buildTile(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'WhatsApp Assistance',
              subtitle: 'Message Nanma via WhatsApp bot',
              onTap: () => context.push('/whatsapp-assist'),
            ),
            const SizedBox(height: 14),

            _buildSectionTitle('Preferences & System'),
            _buildTile(
              icon: Icons.translate_rounded,
              title: 'App Language',
              subtitle: user.language == 'ml' ? 'മലയാളം (Malayalam)' : 'English',
              onTap: () {
                final newLang = user.language == 'ml' ? 'en' : 'ml';
                ref.read(currentUserProvider.notifier).state = user.copyWith(language: newLang);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language switched to ${newLang == 'ml' ? 'Malayalam' : 'English'}'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
            ),
            _buildTile(
              icon: Icons.pin_drop_outlined,
              title: 'Saved Addresses',
              subtitle: 'Panampilly Nagar, Thevara Villa',
              onTap: () {},
            ),
            _buildTile(
              icon: Icons.security_rounded,
              title: 'Privacy & Safety',
              subtitle: 'Verified workers and permissions',
              onTap: () {},
            ),
            _buildTile(
              icon: Icons.swap_horiz_rounded,
              title: 'Switch to Worker Mode',
              subtitle: 'Earn by helping people in your community',
              onTap: () {
                ref.read(currentRoleProvider.notifier).state = UserRole.worker;
                context.go('/worker/home');
              },
            ),
            const SizedBox(height: 24),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(authRepositoryProvider).signOut();
                  context.go('/login');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderSubtle),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout_rounded, color: AppColors.textMuted, size: 18),
                label: const Text('Log Out', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.ultraLightGreen,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
      ),
    );
  }
}
