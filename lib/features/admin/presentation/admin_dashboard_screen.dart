import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/user_model.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../providers/app_providers.dart';
import 'admin_users_screen.dart';
import 'admin_workers_screen.dart';
import 'admin_requests_screen.dart';
import 'admin_complaints_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final contentPages = [
      _buildOverviewContent(),
      const AdminUsersScreen(),
      const AdminWorkersScreen(),
      const AdminRequestsScreen(),
      const AdminComplaintsScreen(),
    ];

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            // Desktop Sidebar
            Container(
              width: 250,
              color: AppColors.navyBlue,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Nanma Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Central Operations Hub',
                    style: TextStyle(color: Color(0xFFB0BEC5), fontSize: 12),
                  ),
                  const SizedBox(height: 32),
                  _buildSidebarItem(0, Icons.dashboard_rounded, 'Dashboard'),
                  _buildSidebarItem(1, Icons.people_alt_rounded, 'Users (1,420)'),
                  _buildSidebarItem(2, Icons.handyman_rounded, 'Workers (86)'),
                  _buildSidebarItem(3, Icons.assignment_rounded, 'Requests (19)'),
                  _buildSidebarItem(4, Icons.report_problem_rounded, 'Complaints (2)'),
                  const Spacer(),
                  ListTile(
                    leading: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    title: const Text('Exit to App', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      ref.read(currentRoleProvider.notifier).state = UserRole.customer;
                      context.go('/home');
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Main content
            Expanded(child: contentPages[_selectedNavIndex]),
          ],
        ),
      );
    }

    // Mobile / Tablet Drawer Layout
    return Scaffold(
      appBar: NanmaAppBar(
        title: 'Nanma Operations Admin',
        subtitle: 'അഡ്മിൻ പാനൽ',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded, color: AppColors.primaryGreen),
            tooltip: 'Return to Customer View',
            onPressed: () {
              ref.read(currentRoleProvider.notifier).state = UserRole.customer;
              context.go('/home');
            },
          ),
        ],
      ),
      body: contentPages[_selectedNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) => setState(() => _selectedNavIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.handyman_rounded), label: 'Workers'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: 'Requests'),
          BottomNavigationBarItem(icon: Icon(Icons.report_problem_rounded), label: 'Issues'),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String label) {
    final isSelected = _selectedNavIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? AppColors.secondaryGreen : Colors.white70),
        title: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () => setState(() => _selectedNavIndex = index),
      ),
    );
  }

  Widget _buildOverviewContent() {
    final adminRepo = ref.watch(adminRepositoryProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Community Operations Overview',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 6),
          const Text(
            'Live monitoring across Kochi, Thiruvananthapuram and Kozhikode hubs',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),

          // KPI Cards Grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildMetricCard('Total Users', '${adminRepo.totalUsers}', Icons.people_outline_rounded, AppColors.primaryGreen),
              _buildMetricCard('Active Workers', '${adminRepo.activeWorkers}', Icons.handyman_outlined, AppColors.navyBlue),
              _buildMetricCard('Active Tasks', '${adminRepo.activeRequests}', Icons.bolt_rounded, AppColors.darkOrange),
              _buildMetricCard('Completed Jobs', '${adminRepo.completedRequests}', Icons.task_alt_rounded, AppColors.primaryGreen),
              _buildMetricCard('Total Revenue', '₹${adminRepo.totalRevenue.toStringAsFixed(0)}', Icons.currency_rupee_rounded, AppColors.darkGreen),
              _buildMetricCard('Avg Satisfaction', '${adminRepo.averageRating} ⭐', Icons.star_rounded, AppColors.accentOrange),
            ],
          ),
          const SizedBox(height: 28),

          // Recent Complaints Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Open Complaints Requiring Action',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedNavIndex = 4),
                child: const Text('View All', style: TextStyle(color: AppColors.primaryGreen)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...adminRepo.complaints.map((c) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.cream,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.report_problem_rounded, color: AppColors.darkOrange, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${c.customerName} vs ${c.workerName}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 2),
                        Text(c.issue, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: c.status.name == 'resolved' ? AppColors.ultraLightGreen : AppColors.cream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      c.status.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: c.status.name == 'resolved' ? AppColors.primaryGreen : AppColors.darkOrange,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String val, IconData icon, Color color) {
    return Container(
      width: 160,
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
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 10),
          Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
