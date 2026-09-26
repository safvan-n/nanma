import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/service_request_model.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_button.dart';
import '../../../providers/app_providers.dart';

class WorkerMatchingScreen extends ConsumerStatefulWidget {
  final String requestId;

  const WorkerMatchingScreen({super.key, required this.requestId});

  @override
  ConsumerState<WorkerMatchingScreen> createState() => _WorkerMatchingScreenState();
}

class _WorkerMatchingScreenState extends ConsumerState<WorkerMatchingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _matchingTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Automatically assign worker after 3.5 seconds
    _matchingTimer = Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        _assignWorkerAndNavigate();
      }
    });
  }

  void _assignWorkerAndNavigate() async {
    final worker = MockDataService.primaryWorker;
    await ref.read(requestsProvider.notifier).assignWorker(widget.requestId, worker);
    await ref.read(requestsProvider.notifier).updateStatus(widget.requestId, RequestStatus.workerAssigned);

    if (mounted) {
      context.go('/tracking/${widget.requestId}');
    }
  }

  @override
  void dispose() {
    _matchingTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanmaAppBar(
        title: 'Worker Matching',
        subtitle: 'അടുത്തുള്ള സഹായിയെ കണ്ടെത്തുന്നു',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated Pulsing Radar Circle
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 180 + (_pulseController.value * 40),
                        height: 180 + (_pulseController.value * 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryGreen.withValues(alpha: 0.12 * (1 - _pulseController.value)),
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.ultraLightGreen,
                          border: Border.all(color: AppColors.secondaryGreen, width: 2),
                          boxShadow: AppDimensions.cardShadow,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.radar_rounded,
                            size: 64,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 36),

              const Text(
                'Finding a Nanma worker near you...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connecting with verified community helpers within 2 km of your location',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),

              // Nearby verified helper count indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_alt_rounded, size: 18, color: AppColors.darkOrange),
                    SizedBox(width: 8),
                    Text(
                      '3 verified workers active in Panampilly Nagar',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Quick skip button for instant prototype demonstration
              NanmaButton(
                text: 'Skip to Worker Assigned →',
                backgroundColor: AppColors.navyBlue,
                onPressed: _assignWorkerAndNavigate,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Cancel Request', style: TextStyle(color: AppColors.emergencyRed)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
