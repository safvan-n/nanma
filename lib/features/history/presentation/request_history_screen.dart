import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/service_request_model.dart';
import '../../../widgets/request_card.dart';
import '../../../widgets/state_feedback_widgets.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../providers/app_providers.dart';

class RequestHistoryScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const RequestHistoryScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<RequestHistoryScreen> createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends ConsumerState<RequestHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allRequests = ref.watch(requestsProvider);

    final activeList = allRequests
        .where((r) =>
            r.status != RequestStatus.completed &&
            r.status != RequestStatus.cancelled)
        .toList();

    final completedList =
        allRequests.where((r) => r.status == RequestStatus.completed).toList();

    final cancelledList =
        allRequests.where((r) => r.status == RequestStatus.cancelled).toList();

    return Scaffold(
      appBar: NanmaAppBar(
        title: 'My Requests',
        subtitle: 'എന്റെ സേവനങ്ങൾ',
        showBackButton: !widget.isEmbedded,
      ),
      body: Column(
        children: [
          // Tab selector
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textMuted,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                Tab(text: 'Active (${activeList.length})'),
                Tab(text: 'Completed (${completedList.length})'),
                Tab(text: 'Cancelled (${cancelledList.length})'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(activeList, 'No active requests', 'When you request a service, it will show up here.'),
                _buildList(completedList, 'No completed requests', 'Completed community assistance tasks will appear here.'),
                _buildList(cancelledList, 'No cancelled requests', 'Cancelled service requests will be archived here.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<ServiceRequestModel> list, String emptyTitle, String emptyDesc) {
    if (list.isEmpty) {
      return EmptyState(
        icon: Icons.assignment_outlined,
        title: emptyTitle,
        message: emptyDesc,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final req = list[index];
        return RequestCard(
          request: req,
          onTap: () {
            context.push('/tracking/${req.id}');
          },
          onReorder: () {
            context.push('/services/grocery');
          },
        );
      },
    );
  }
}
