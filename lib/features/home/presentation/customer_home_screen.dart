import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/service_category_model.dart';
import '../../../models/service_request_model.dart';
import '../../../models/user_model.dart';
import '../../../widgets/nanma_search_bar.dart';
import '../../../widgets/service_card.dart';
import '../../../widgets/request_card.dart';
import '../../../widgets/emergency_button.dart';
import '../../../widgets/custom_bottom_nav.dart';
import '../../../providers/app_providers.dart';
import '../../history/presentation/request_history_screen.dart';
import '../../help/presentation/help_center_screen.dart';
import '../../notifications/presentation/notifications_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(customerNavIndexProvider);
    final user = ref.watch(currentUserProvider) ??
        const UserModel(
          id: 'guest',
          phoneNumber: '+91 98765 43210',
          fullName: 'Anjali Menon',
          address: 'Flat 4B, Palm Grove, Panampilly Nagar',
          pincode: '682036',
          district: 'Ernakulam',
        );

    final pages = [
      _buildHomeContent(user),
      const RequestHistoryScreen(isEmbedded: true),
      const HelpCenterScreen(isEmbedded: true),
      const NotificationsScreen(isEmbedded: true),
      const ProfileScreen(isEmbedded: true),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(customerNavIndexProvider.notifier).state = index;
        },
        unreadNotifications: 2,
      ),
    );
  }

  Widget _buildHomeContent(UserModel user) {
    final allRequests = ref.watch(requestsProvider);
    final activeRequests = allRequests
        .where((r) =>
            r.status != RequestStatus.completed &&
            r.status != RequestStatus.cancelled)
        .toList();

    final categories = ServiceCategoryModel.defaultCategories.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.titleMalayalam.contains(_searchQuery) ||
          c.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: () async {
          ref.read(requestsProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with greeting, location & role switcher
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Good Morning 👋',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMuted.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Role switcher pill (Customer, Worker, Admin)
                  PopupMenuButton<String>(
                    onSelected: (val) {
                      if (val == 'worker') {
                        ref.read(currentRoleProvider.notifier).state = UserRole.worker;
                        context.go('/worker/home');
                      } else if (val == 'admin') {
                        ref.read(currentRoleProvider.notifier).state = UserRole.admin;
                        context.go('/admin/dashboard');
                      } else if (val == 'elderly') {
                        context.push('/elderly');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.swap_horiz_rounded, size: 16, color: AppColors.darkGreen),
                          SizedBox(width: 4),
                          Text(
                            'Switch View',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'worker',
                        child: Row(
                          children: [
                            Icon(Icons.handyman_rounded, color: AppColors.primaryGreen, size: 18),
                            SizedBox(width: 8),
                            Text('Worker App Flow'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'admin',
                        child: Row(
                          children: [
                            Icon(Icons.admin_panel_settings_rounded, color: AppColors.navyBlue, size: 18),
                            SizedBox(width: 8),
                            Text('Admin Dashboard'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'elderly',
                        child: Row(
                          children: [
                            Icon(Icons.accessibility_new_rounded, color: AppColors.accentOrange, size: 18),
                            SizedBox(width: 8),
                            Text('Simplified Elderly Mode'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Location chip
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Delivery location: Panampilly Nagar, Ernakulam'),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on_rounded, size: 16, color: AppColors.primaryGreen),
                    const SizedBox(width: 4),
                    Text(
                      '${user.district} • ${user.address}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textMuted),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Search Bar
              NanmaSearchBar(
                hintText: 'Search groceries, medicines, plumber...',
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                },
              ),
              const SizedBox(height: 16),

              // Emergency Assistance SOS & WhatsApp Help Quick Row
              Row(
                children: [
                  Expanded(
                    child: EmergencyButton(
                      compact: true,
                      onTap: () => context.push('/emergency'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () => context.push('/whatsapp-assist'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F8EE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.whatsAppGreen.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_rounded, size: 16, color: AppColors.whatsAppGreen),
                            SizedBox(width: 6),
                            Text(
                              'WhatsApp Assist',
                              style: TextStyle(
                                color: Color(0xFF1E7E34),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Elderly Mode Quick Button
                  InkWell(
                    onTap: () => context.push('/elderly'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.accentOrange.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.elderly_rounded, size: 18, color: AppColors.darkOrange),
                          SizedBox(width: 4),
                          Text(
                            'Elderly',
                            style: TextStyle(
                              color: AppColors.darkOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Active Request Banner (if any)
              if (activeRequests.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Active Request',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(customerNavIndexProvider.notifier).state = 1;
                      },
                      child: const Text('View All', style: TextStyle(color: AppColors.primaryGreen)),
                    ),
                  ],
                ),
                RequestCard(
                  request: activeRequests.first,
                  onTap: () => context.push('/tracking/${activeRequests.first.id}'),
                ),
                const SizedBox(height: 14),
              ],

              // Service Categories Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Community Services',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/requests/smart-request'),
                    icon: const Icon(Icons.mic_rounded, size: 16, color: AppColors.primaryGreen),
                    label: const Text('Smart Request', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Service Grid (15+ services, rounded cards, Malayalam + English)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.88,
                ),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return ServiceCard(
                    category: cat,
                    onTap: () {
                      context.push(cat.routePath);
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Help Points & Community Impact Card
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppDimensions.roundedMd,
                  boxShadow: AppDimensions.cardShadow,
                ),
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.volunteer_activism_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Help Points',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Earn points every time you help or request services',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFE8F5E9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 16, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                '${user.helpPoints}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: Color(0x33FFFFFF), height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCol('24', 'People Helped'),
                        Container(width: 1, height: 28, color: const Color(0x33FFFFFF)),
                        _buildStatCol('4.9', 'Rating ⭐'),
                        Container(width: 1, height: 28, color: const Color(0x33FFFFFF)),
                        _buildStatCol('₹340', 'Saved'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Kerala Community message card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: AppDimensions.roundedMd,
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.eco_rounded, color: AppColors.primaryGreen, size: 28),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'നന്മ എന്നത് ഒരു പ്രവൃത്തി മാത്രമല്ല...',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'ഒരു വലിയ മാറ്റമാണ്. Small Help, Big Change.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCol(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFC8E6C9),
          ),
        ),
      ],
    );
  }
}
