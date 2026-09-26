import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/user_model.dart';
import '../../../models/worker_model.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_button.dart';
import '../../../providers/app_providers.dart';
import 'worker_tasks_screen.dart';
import 'worker_earnings_screen.dart';
import 'worker_verification_screen.dart';

class WorkerDashboardScreen extends ConsumerStatefulWidget {
  const WorkerDashboardScreen({super.key});

  @override
  ConsumerState<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends ConsumerState<WorkerDashboardScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final worker = ref.watch(workerRepositoryProvider).currentWorker;

    final tabs = [
      _buildWorkerHomeContent(worker),
      const WorkerTasksScreen(),
      const WorkerEarningsScreen(),
      const WorkerVerificationScreen(),
    ];

    return Scaffold(
      body: tabs[_tabIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
          boxShadow: AppDimensions.cardShadow,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard_rounded, 'Dashboard'),
                _buildNavItem(1, Icons.assignment_rounded, 'Tasks (2)'),
                _buildNavItem(2, Icons.account_balance_wallet_rounded, 'Earnings'),
                _buildNavItem(3, Icons.verified_user_rounded, 'Verify ID'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _tabIndex == index;
    final color = isSelected ? AppColors.primaryGreen : AppColors.textLight;

    return InkWell(
      onTap: () => setState(() => _tabIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerHomeContent(WorkerModel worker) {
    return Scaffold(
      appBar: NanmaAppBar(
        title: 'Nanma Worker Hub',
        subtitle: 'തൊഴിലാളി ഡാഷ്‌ബോർഡ്',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.primaryGreen),
            tooltip: 'Switch to Customer View',
            onPressed: () {
              ref.read(currentRoleProvider.notifier).state = UserRole.customer;
              context.go('/home');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Online/Offline Status Switch Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: worker.isOnline ? const Color(0xFFF1F8F1) : const Color(0xFFFAFAFA),
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(
                  color: worker.isOnline ? AppColors.secondaryGreen : AppColors.borderSubtle,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: worker.isOnline ? AppColors.primaryGreen : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.isOnline ? 'You are ONLINE' : 'You are OFFLINE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: worker.isOnline ? AppColors.primaryGreen : AppColors.textMuted,
                          ),
                        ),
                        Text(
                          worker.isOnline
                              ? 'Receiving nearby delivery & errand requests'
                              : 'Toggle on to start receiving jobs',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: worker.isOnline,
                    activeThumbColor: AppColors.primaryGreen,
                    onChanged: (val) {
                      setState(() {
                        ref.read(workerRepositoryProvider).toggleOnlineStatus(val);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Performance / Earnings Snapshot
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard('Today\'s Pay', '₹${worker.todayEarnings.toStringAsFixed(0)}', Icons.payments_rounded, AppColors.primaryGreen),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildKpiCard('Jobs Done', '${worker.completedJobs}', Icons.check_circle_rounded, AppColors.navyBlue),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildKpiCard('Rating', '${worker.rating} ⭐', Icons.star_rounded, AppColors.accentOrange),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Weekly summary banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navyBlue, Color(0xFF1B3B5F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppDimensions.roundedMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weekly Payout Balance',
                        style: TextStyle(fontSize: 12, color: Color(0xFFB0BEC5)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${worker.weeklyEarnings.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => _tabIndex = 2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: const Text('Withdraw', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Active Task Section
            const Text(
              'Active Assignment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.ultraLightGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Grocery Delivery', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                      ),
                      const Text('₹180 Payout', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Anjali Menon (Flat 4B, Panampilly Nagar)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 4),
                  const Text('4 items: Milma Milk, Jaya Rice, Oil, Curry leaves', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.push('/chat/req_101'),
                          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                          label: const Text('Chat'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/tracking/req_101'),
                          icon: const Icon(Icons.navigation_rounded, size: 16),
                          label: const Text('Navigate'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Available Tasks prompt
            NanmaButton(
              text: 'View Available Nearby Jobs (2) →',
              onPressed: () => setState(() => _tabIndex = 1),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: AppDimensions.cardShadow,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
