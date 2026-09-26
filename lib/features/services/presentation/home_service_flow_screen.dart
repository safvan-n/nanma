import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/service_request_model.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_button.dart';
import '../../../widgets/nanma_text_field.dart';
import '../../../providers/app_providers.dart';

class HomeServiceFlowScreen extends ConsumerStatefulWidget {
  final String categoryName;

  const HomeServiceFlowScreen({super.key, this.categoryName = 'Plumbing'});

  @override
  ConsumerState<HomeServiceFlowScreen> createState() => _HomeServiceFlowScreenState();
}

class _HomeServiceFlowScreenState extends ConsumerState<HomeServiceFlowScreen> {
  final _problemController = TextEditingController();
  final _timeController = TextEditingController(text: 'Today, 3:30 PM');
  bool _photoAttached = false;
  RequestUrgency _urgency = RequestUrgency.normal;

  @override
  void dispose() {
    _problemController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submitRequest() async {
    final user = ref.read(currentUserProvider);
    final newRequest = ServiceRequestModel(
      id: 'srv_${DateTime.now().millisecondsSinceEpoch}',
      customerId: user?.id ?? 'cust_01',
      customerName: user?.fullName ?? 'Anjali Menon',
      customerPhone: user?.phoneNumber ?? '+91 98765 43210',
      serviceCategory: widget.categoryName,
      title: '${widget.categoryName} Service Request',
      description: _problemController.text.trim().isEmpty
          ? 'Need expert inspection and repair at residence.'
          : _problemController.text.trim(),
      pickupAddress: 'Customer Premises',
      deliveryAddress: user?.address ?? 'Panampilly Nagar, Kochi',
      urgency: _urgency,
      preferredTime: _timeController.text.trim(),
      status: RequestStatus.findingWorker,
      estimatedCost: 180.0,
      finalCost: 180.0,
      createdAt: DateTime.now(),
    );

    await ref.read(requestsProvider.notifier).addRequest(newRequest);
    if (mounted) {
      context.push('/matching/${newRequest.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NanmaAppBar(
        title: '${widget.categoryName} Assistance',
        subtitle: 'വിദഗ്ദ്ധ തൊഴിലാളി സേവനം',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service intro badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.ultraLightGreen,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: AppColors.lightGreen),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: AppColors.primaryGreen, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verified ${widget.categoryName} Professional',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Standard visiting & diagnostic fee: ₹180',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Problem Description
            const Text(
              'Describe the Problem',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            NanmaTextField(
              controller: _problemController,
              hintText: 'e.g. Bathroom pipe leaking under the sink, need washer replacement...',
              maxLines: 3,
            ),
            const SizedBox(height: 18),

            // Photos attach
            const Text(
              'Attach Photos or Short Video (Optional)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  Icon(
                    _photoAttached ? Icons.check_circle_rounded : Icons.photo_camera_outlined,
                    color: _photoAttached ? AppColors.primaryGreen : AppColors.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _photoAttached ? '1 Photo Attached ✓' : 'Add photo of the issue for accurate quote',
                      style: TextStyle(fontSize: 13, color: _photoAttached ? AppColors.primaryGreen : AppColors.textMuted),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _photoAttached = !_photoAttached),
                    child: Text(_photoAttached ? 'Remove' : 'Upload'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Preferred time
            const Text(
              'Preferred Date & Time',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            NanmaTextField(
              controller: _timeController,
              prefixIcon: const Icon(Icons.schedule_rounded, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 20),

            // Urgency
            const Text(
              'Urgency',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Urgent (Immediate)'),
                    selected: _urgency == RequestUrgency.urgent,
                    selectedColor: AppColors.ultraLightGreen,
                    onSelected: (_) => setState(() => _urgency = RequestUrgency.urgent),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Normal (Scheduled)'),
                    selected: _urgency == RequestUrgency.normal,
                    selectedColor: AppColors.ultraLightGreen,
                    onSelected: (_) => setState(() => _urgency = RequestUrgency.normal),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),

            // Submit Button
            NanmaButton(
              text: 'Find Verified Professional (₹180 Visit) →',
              onPressed: _submitRequest,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
