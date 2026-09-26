import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/nanma_button.dart';
import '../../../widgets/decorative_leaf_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': AppStrings.onbTitle1,
      'description': AppStrings.onbDesc1,
      'icon': Icons.shopping_basket_rounded,
      'bannerColor': const Color(0xFFE8F5E9),
      'badges': [
        {'icon': Icons.shopping_cart_outlined, 'label': 'Groceries & Essentials'},
        {'icon': Icons.medication_outlined, 'label': 'Medicines Delivery'},
        {'icon': Icons.local_shipping_outlined, 'label': 'Parcel Pickup'},
        {'icon': Icons.build_outlined, 'label': 'Home Services'},
      ],
    },
    {
      'title': AppStrings.onbTitle2,
      'description': AppStrings.onbDesc2,
      'icon': Icons.location_on_rounded,
      'bannerColor': const Color(0xFFE3F2FD),
      'badges': [
        {'icon': Icons.navigation_outlined, 'label': 'Track in Real Time'},
        {'icon': Icons.verified_user_outlined, 'label': 'Secure Payments'},
        {'icon': Icons.star_border_rounded, 'label': 'Tips & Ratings'},
        {'icon': Icons.chat_outlined, 'label': 'WhatsApp Support'},
      ],
    },
    {
      'title': AppStrings.onbTitle3,
      'description': AppStrings.onbDesc3,
      'icon': Icons.volunteer_activism_rounded,
      'bannerColor': const Color(0xFFFFF8E1),
      'badges': [
        {'icon': Icons.elderly_rounded, 'label': 'Elderly Friendly'},
        {'icon': Icons.translate_rounded, 'label': 'Local Languages'},
        {'icon': Icons.touch_app_outlined, 'label': 'Easy Access'},
        {'icon': Icons.shield_outlined, 'label': 'Safe & Reliable'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecorativeLeafBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with Official Logo
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      AppAssets.logo,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                    if (_currentPage < 2)
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),

              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          // Title
                          Text(
                            page['title'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Description
                          Text(
                            page['description'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textMuted,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Illustration Card with Warm Community Visual
                          Container(
                            height: 210,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: page['bannerColor'] as Color,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.borderSubtle),
                              boxShadow: AppDimensions.cardShadow,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  top: -20,
                                  right: -20,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: AppDimensions.cardShadow,
                                      ),
                                      child: Icon(
                                        page['icon'] as IconData,
                                        size: 54,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Nanma Community Service',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 4 Feature Badges Grid
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: (page['badges'] as List<Map<String, dynamic>>).map((b) {
                              return Container(
                                width: (MediaQuery.of(context).size.width - 64) / 2,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.borderSubtle),
                                ),
                                child: Row(
                                  children: [
                                    Icon(b['icon'] as IconData, size: 18, color: AppColors.primaryGreen),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        b['label'] as String,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Actions: Indicators & Next/Get Started Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primaryGreen
                                : AppColors.borderSubtle,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Primary Button
                    NanmaButton(
                      text: _currentPage == 2 ? 'Get Started →' : 'Next →',
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.go('/login');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
