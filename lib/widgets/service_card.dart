import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../models/service_category_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceCategoryModel category;
  final VoidCallback onTap;
  final bool compact;

  const ServiceCard({
    super.key,
    required this.category,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimensions.roundedMd,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppDimensions.roundedMd,
            border: Border.all(color: AppColors.borderSubtle, width: 1),
            boxShadow: AppDimensions.cardShadow,
          ),
          padding: EdgeInsets.all(compact ? 10 : 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: compact ? 44 : 52,
                height: compact ? 44 : 52,
                decoration: BoxDecoration(
                  color: category.bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  category.iconData,
                  color: category.iconColor,
                  size: compact ? 24 : 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                category.titleMalayalam,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
