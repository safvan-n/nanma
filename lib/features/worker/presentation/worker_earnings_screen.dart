import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_button.dart';
import '../../../providers/app_providers.dart';

class WorkerEarningsScreen extends ConsumerStatefulWidget {
  const WorkerEarningsScreen({super.key});

  @override
  ConsumerState<WorkerEarningsScreen> createState() => _WorkerEarningsScreenState();
}

class _WorkerEarningsScreenState extends ConsumerState<WorkerEarningsScreen> {
  int _selectedFilter = 1; // 0: Today, 1: This Week, 2: This Month

  @override
  Widget build(BuildContext context) {
    final worker = ref.watch(workerRepositoryProvider).currentWorker;

    return Scaffold(
      appBar: const NanmaAppBar(
        title: 'Earnings & Payouts',
        subtitle: 'വരുമാന വിവരങ്ങൾ',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time filter pills
            Row(
              children: [
                _buildFilterPill('Today', 0),
                const SizedBox(width: 8),
                _buildFilterPill('This Week', 1),
                const SizedBox(width: 8),
                _buildFilterPill('This Month', 2),
              ],
            ),
            const SizedBox(height: 16),

            // Main Balance Card
            Container(
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
                  const Text('Available for Immediate Payout', style: TextStyle(color: Color(0xFFC8E6C9), fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(
                    '₹${worker.withdrawableBalance.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  NanmaButton(
                    text: 'Transfer to Kerala Bank Account',
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryGreen,
                    height: 44,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payout request of ₹3,200 submitted to registered bank account.'),
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Performance Statistics
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile('Gross Earnings', '₹4,920', AppColors.primaryGreen),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricTile('Tips Received', '₹380', AppColors.darkOrange),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricTile('Completed', '28 Jobs', AppColors.navyBlue),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Daily Earnings Breakdown Chart Simulation
            const Text(
              'Weekly Daily Trend',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBar('Mon', 0.5, '₹550'),
                  _buildBar('Tue', 0.7, '₹780'),
                  _buildBar('Wed', 0.9, '₹980'),
                  _buildBar('Thu', 0.6, '₹620'),
                  _buildBar('Fri', 0.85, '₹910'),
                  _buildBar('Sat', 1.0, '₹1,080'),
                  _buildBar('Sun', 0.0, 'Off'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Completed Payouts
            const Text(
              'Recent Completed Jobs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 10),
            _buildJobRow('Grocery delivery (4 items)', 'Today, 11:20 AM', '₹180 + ₹20 Tip'),
            _buildJobRow('Medicine purchase (Neethi)', 'Yesterday, 4:15 PM', '₹150 + ₹30 Tip'),
            _buildJobRow('Parcel pickup from Metro', '22 Sep 2026', '₹95'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String title, int index) {
    final isSelected = _selectedFilter == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGreen : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? AppColors.primaryGreen : AppColors.borderSubtle),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(String title, String val, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double fillRatio, String amount) {
    return Column(
      children: [
        Text(amount, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
        const SizedBox(height: 6),
        Container(
          width: 22,
          height: 90 * fillRatio + 10,
          decoration: BoxDecoration(
            color: fillRatio > 0.8 ? AppColors.primaryGreen : AppColors.secondaryGreen,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 11, color: AppColors.textDark)),
      ],
    );
  }

  Widget _buildJobRow(String title, String time, String earn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
              Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
            ],
          ),
          Text(earn, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryGreen)),
        ],
      ),
    );
  }
}
