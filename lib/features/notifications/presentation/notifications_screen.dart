import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/notification_model.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../widgets/nanma_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  final bool isEmbedded;

  const NotificationsScreen({super.key, this.isEmbedded = false});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationModel> _notifications;
  NotificationCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(MockDataService.sampleNotifications);
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _notifications.where((n) {
      if (_selectedCategory == null) return true;
      return n.category == _selectedCategory;
    }).toList();

    return Scaffold(
      appBar: NanmaAppBar(
        title: 'Notifications',
        subtitle: 'അറിയിപ്പുകൾ',
        showBackButton: !widget.isEmbedded,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text('Read all', style: TextStyle(color: AppColors.primaryGreen, fontSize: 13)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip(null, 'All'),
                const SizedBox(width: 8),
                _buildFilterChip(NotificationCategory.worker, 'Worker'),
                const SizedBox(width: 8),
                _buildFilterChip(NotificationCategory.request, 'Requests'),
                const SizedBox(width: 8),
                _buildFilterChip(NotificationCategory.family, 'Family'),
                const SizedBox(width: 8),
                _buildFilterChip(NotificationCategory.safety, 'Safety'),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Notification List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No notifications right now', style: TextStyle(color: AppColors.textMuted)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: item.isRead ? Colors.white : const Color(0xFFF1F8F1),
                          borderRadius: AppDimensions.roundedMd,
                          border: Border.all(
                            color: item.isRead ? AppColors.borderSubtle : AppColors.lightGreen,
                            width: 1,
                          ),
                          boxShadow: AppDimensions.cardShadow,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              final idx = _notifications.indexWhere((n) => n.id == item.id);
                              if (idx != -1) {
                                _notifications[idx] = _notifications[idx].copyWith(isRead: true);
                              }
                            });
                            if (item.actionRoute != null) {
                              context.push(item.actionRoute!);
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: item.isRead ? AppColors.cream : AppColors.ultraLightGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getCategoryIcon(item.category),
                                  size: 20,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        ),
                                        if (!item.isRead)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primaryGreen,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.message,
                                      style: const TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(NotificationCategory? cat, String label) {
    final isSelected = _selectedCategory == cat;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.ultraLightGreen,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? AppColors.primaryGreen : AppColors.textDark,
      ),
      onSelected: (_) => setState(() => _selectedCategory = cat),
    );
  }

  IconData _getCategoryIcon(NotificationCategory cat) {
    switch (cat) {
      case NotificationCategory.worker:
        return Icons.moped_rounded;
      case NotificationCategory.request:
        return Icons.shopping_basket_rounded;
      case NotificationCategory.payment:
        return Icons.account_balance_wallet_rounded;
      case NotificationCategory.safety:
        return Icons.shield_rounded;
      case NotificationCategory.family:
        return Icons.family_restroom_rounded;
      case NotificationCategory.promotion:
        return Icons.local_offer_rounded;
      case NotificationCategory.system:
        return Icons.notifications_active_rounded;
    }
  }
}
