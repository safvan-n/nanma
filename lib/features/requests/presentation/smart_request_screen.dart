import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/service_request_model.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_button.dart';
import '../../../widgets/nanma_text_field.dart';
import '../../../widgets/voice_input_button.dart';
import '../../../providers/app_providers.dart';

class SmartRequestScreen extends ConsumerStatefulWidget {
  const SmartRequestScreen({super.key});

  @override
  ConsumerState<SmartRequestScreen> createState() => _SmartRequestScreenState();
}

class _SmartRequestScreenState extends ConsumerState<SmartRequestScreen> {
  final _textController = TextEditingController(
    text: 'Please buy medicine and deliver it to my mother in Thevara.',
  );
  RequestUrgency _urgency = RequestUrgency.urgent;
  bool _attachmentAdded = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitSmartRequest() async {
    final user = ref.read(currentUserProvider);
    final newRequest = ServiceRequestModel(
      id: 'smart_${DateTime.now().millisecondsSinceEpoch}',
      customerId: user?.id ?? 'cust_01',
      customerName: user?.fullName ?? 'Anjali Menon',
      customerPhone: user?.phoneNumber ?? '+91 98765 43210',
      serviceCategory: 'Local Errands',
      title: 'Smart Community Request',
      description: _textController.text.trim(),
      pickupAddress: 'Nearby Provider',
      deliveryAddress: user?.address ?? 'Panampilly Nagar, Kochi',
      urgency: _urgency,
      preferredTime: 'Today, within 1 hour',
      status: RequestStatus.findingWorker,
      estimatedCost: 150.0,
      finalCost: 150.0,
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
      appBar: const NanmaAppBar(
        title: 'Smart Request',
        subtitle: 'ശബ്ദം വഴിയോ കുറിപ്പ് വഴിയോ ചോദിക്കാം',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Voice Input Section with Pulsing Mic
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Column(
                children: [
                  VoiceInputButton(
                    onRecordedText: (text) {
                      setState(() {
                        _textController.text = text;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Say anything: "Buy milk and bread" or "Need plumber for leak"',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Text Description
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Request Details / Voice Transcript',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: 8),
            NanmaTextField(
              controller: _textController,
              hintText: 'Describe what you need help with...',
              maxLines: 4,
            ),
            const SizedBox(height: 18),

            // Media / Document Attachments
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
                    _attachmentAdded ? Icons.check_circle_rounded : Icons.attach_file_rounded,
                    color: _attachmentAdded ? AppColors.primaryGreen : AppColors.textLight,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _attachmentAdded ? 'Photo / Document attached ✓' : 'Add photo, audio or document',
                      style: TextStyle(
                        fontSize: 13,
                        color: _attachmentAdded ? AppColors.primaryGreen : AppColors.textMuted,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _attachmentAdded = !_attachmentAdded),
                    child: Text(_attachmentAdded ? 'Remove' : 'Attach'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Urgency
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Urgency',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Urgent (ASAP)'),
                    selected: _urgency == RequestUrgency.urgent,
                    selectedColor: AppColors.ultraLightGreen,
                    onSelected: (_) => setState(() => _urgency = RequestUrgency.urgent),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Scheduled Later'),
                    selected: _urgency == RequestUrgency.scheduled,
                    selectedColor: AppColors.ultraLightGreen,
                    onSelected: (_) => setState(() => _urgency = RequestUrgency.scheduled),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),

            // Submit Button
            NanmaButton(
              text: 'Submit Smart Request →',
              onPressed: _textController.text.trim().isEmpty ? null : _submitSmartRequest,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
