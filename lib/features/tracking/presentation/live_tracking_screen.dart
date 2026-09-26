import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/service_request_model.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_button.dart';
import '../../../widgets/worker_card.dart';
import '../../../providers/app_providers.dart';

class LiveTrackingScreen extends ConsumerStatefulWidget {
  final String requestId;

  const LiveTrackingScreen({super.key, required this.requestId});

  @override
  ConsumerState<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends ConsumerState<LiveTrackingScreen> {
  void _advanceTaskStatus(ServiceRequestModel request) async {
    RequestStatus nextStatus;
    switch (request.status) {
      case RequestStatus.pending:
      case RequestStatus.findingWorker:
        nextStatus = RequestStatus.workerAssigned;
        break;
      case RequestStatus.workerAssigned:
        nextStatus = RequestStatus.onTheWay;
        break;
      case RequestStatus.onTheWay:
        nextStatus = RequestStatus.shoppingWorking;
        break;
      case RequestStatus.shoppingWorking:
        nextStatus = RequestStatus.delivering;
        break;
      case RequestStatus.delivering:
        nextStatus = RequestStatus.completed;
        context.push('/payment/${request.id}');
        return;
      case RequestStatus.completed:
      case RequestStatus.cancelled:
        return;
    }

    await ref.read(requestsProvider.notifier).updateStatus(widget.requestId, nextStatus);
  }

  @override
  Widget build(BuildContext context) {
    final allRequests = ref.watch(requestsProvider);
    final request = allRequests.firstWhere(
      (r) => r.id == widget.requestId,
      orElse: () => MockDataService.sampleRequests.first,
    );

    final worker = request.assignedWorker ?? MockDataService.primaryWorker;

    return Scaffold(
      appBar: NanmaAppBar(
        title: 'Live Tracking',
        subtitle: 'തത്സമയ നിരീക്ഷണം',
        onBack: () => context.go('/home'),
      ),
      body: Column(
        children: [
          // Simulated Map Screen with Route & Markers
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                // Kerala Map simulation with grid lines and roads
                Container(
                  color: const Color(0xFFE5EDE0),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _MapRoutePainter(),
                  ),
                ),

                // ETA Badge
                Positioned(
                  top: 16,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppDimensions.cardShadow,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined, size: 18, color: AppColors.primaryGreen),
                        const SizedBox(width: 6),
                        Text(
                          'ETA: ${worker.etaMinutes} mins • ${worker.distanceKm} km away',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Recenter map button
                Positioned(
                  top: 16,
                  right: 20,
                  child: FloatingActionButton.small(
                    heroTag: 'map_recenter',
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryGreen,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Centered on worker location')),
                      );
                    },
                    child: const Icon(Icons.my_location_rounded),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Task Details & Progress Sheet
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Worker Card
                    WorkerCard(
                      worker: worker,
                      onCall: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Calling ${worker.fullName} (${worker.phoneNumber})...')),
                        );
                      },
                      onChat: () {
                        context.push('/chat/${request.id}');
                      },
                    ),
                    const SizedBox(height: 20),

                    // Task Progress Timeline Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Task Progress',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        TextButton(
                          onPressed: () => _advanceTaskStatus(request),
                          child: const Text('Simulate Next Step →', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 5-Step Timeline
                    _buildTimelineStep('Requested', 'Request placed successfully', _isStepActive(request.status, 1)),
                    _buildTimelineStep('Accepted', 'Worker assigned and acknowledged', _isStepActive(request.status, 2)),
                    _buildTimelineStep('On the way', 'Helper heading to store / location', _isStepActive(request.status, 3)),
                    _buildTimelineStep('Shopping / Working', 'Inspecting & buying items', _isStepActive(request.status, 4)),
                    _buildTimelineStep('Out for Delivery', 'Heading to your address', _isStepActive(request.status, 5)),
                    _buildTimelineStep('Completed', 'Delivered & task finished', request.status == RequestStatus.completed, isLast: true),

                    const SizedBox(height: 20),

                    // Action Button (Pay or Contact)
                    if (request.status == RequestStatus.delivering || request.status == RequestStatus.completed)
                      NanmaButton(
                        text: 'Proceed to Payment (₹${request.finalCost.toStringAsFixed(0)}) →',
                        onPressed: () => context.push('/payment/${request.id}'),
                      )
                    else
                      NanmaButton(
                        text: 'Chat with Worker →',
                        backgroundColor: AppColors.primaryGreen,
                        icon: Icons.chat_rounded,
                        onPressed: () => context.push('/chat/${request.id}'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isStepActive(RequestStatus status, int step) {
    final order = [
      RequestStatus.pending,
      RequestStatus.workerAssigned,
      RequestStatus.onTheWay,
      RequestStatus.shoppingWorking,
      RequestStatus.delivering,
      RequestStatus.completed,
    ];
    final currentIndex = order.indexOf(status);
    return currentIndex >= (step - 1);
  }

  Widget _buildTimelineStep(String title, String desc, bool isDone, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? AppColors.primaryGreen : Colors.white,
                border: Border.all(
                  color: isDone ? AppColors.primaryGreen : AppColors.borderSubtle,
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: isDone ? AppColors.primaryGreen : AppColors.borderSubtle,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDone ? AppColors.textDark : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12,
                  color: isDone ? AppColors.textMuted : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final roadBorder = Paint()
      ..color = const Color(0xFFD0DCD0)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;

    final routePaint = Paint()
      ..color = AppColors.primaryGreen
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.75)
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.55,
        size.width * 0.65,
        size.height * 0.45,
        size.width * 0.72,
        size.height * 0.25,
      );

    canvas.drawPath(path, roadBorder);
    canvas.drawPath(path, roadPaint);
    canvas.drawPath(path, routePaint);

    // Customer Marker (House Pin)
    final customerPoint = Offset(size.width * 0.72, size.height * 0.25);
    final custPaint = Paint()..color = AppColors.darkOrange;
    canvas.drawCircle(customerPoint, 14, custPaint);
    final custInner = Paint()..color = Colors.white;
    canvas.drawCircle(customerPoint, 6, custInner);

    // Worker Marker (Motorbike / Green Helper Pin)
    final workerPoint = Offset(size.width * 0.25, size.height * 0.75);
    final workerPaint = Paint()..color = AppColors.primaryGreen;
    canvas.drawCircle(workerPoint, 16, workerPaint);
    final workerInner = Paint()..color = Colors.white;
    canvas.drawCircle(workerPoint, 7, workerInner);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
