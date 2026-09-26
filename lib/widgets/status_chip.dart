import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/service_request_model.dart';

class StatusChip extends StatelessWidget {
  final RequestStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case RequestStatus.pending:
        bg = AppColors.cream;
        fg = AppColors.darkOrange;
        label = 'Pending';
        break;
      case RequestStatus.findingWorker:
        bg = AppColors.ultraLightGreen;
        fg = AppColors.primaryGreen;
        label = 'Finding Worker';
        break;
      case RequestStatus.workerAssigned:
        bg = const Color(0xFFE3F2FD);
        fg = AppColors.navyBlue;
        label = 'Worker Assigned';
        break;
      case RequestStatus.onTheWay:
        bg = AppColors.ultraLightGreen;
        fg = AppColors.leafGreen;
        label = 'On The Way';
        break;
      case RequestStatus.shoppingWorking:
        bg = const Color(0xFFFFF3E0);
        fg = AppColors.darkOrange;
        label = 'In Progress';
        break;
      case RequestStatus.delivering:
        bg = const Color(0xFFE8F5E9);
        fg = AppColors.primaryGreen;
        label = 'Out for Delivery';
        break;
      case RequestStatus.completed:
        bg = const Color(0xFFE8F5E9);
        fg = AppColors.darkGreen;
        label = 'Completed';
        break;
      case RequestStatus.cancelled:
        bg = const Color(0xFFEEEEEE);
        fg = AppColors.statusCancelled;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
