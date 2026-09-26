import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

class NanmaSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const NanmaSearchBar({
    super.key,
    this.hintText = 'Search groceries, medicines, plumber...',
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.roundedFull,
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: AppDimensions.cardShadow,
      ),
      child: TextField(
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 15, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryGreen),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.ultraLightGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune_rounded, size: 18, color: AppColors.primaryGreen),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
