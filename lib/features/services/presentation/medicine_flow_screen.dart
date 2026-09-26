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

class MedicineFlowScreen extends ConsumerStatefulWidget {
  const MedicineFlowScreen({super.key});

  @override
  ConsumerState<MedicineFlowScreen> createState() => _MedicineFlowScreenState();
}

class _MedicineFlowScreenState extends ConsumerState<MedicineFlowScreen> {
  final _medicineNameController = TextEditingController(text: 'Telma 40mg (1 strip), Glycomet 500 (1 strip)');
  final _doctorNotesController = TextEditingController(text: 'Check manufacturing date, prefer Sun Pharma brand.');
  String _selectedPharmacy = 'Neethi Medical Store (Government Subsidized)';
  bool _prescriptionAttached = true;
  RequestUrgency _urgency = RequestUrgency.urgent;

  @override
  void dispose() {
    _medicineNameController.dispose();
    _doctorNotesController.dispose();
    super.dispose();
  }

  void _submitMedicineRequest() async {
    final user = ref.read(currentUserProvider);
    final newRequest = ServiceRequestModel(
      id: 'med_${DateTime.now().millisecondsSinceEpoch}',
      customerId: user?.id ?? 'cust_01',
      customerName: user?.fullName ?? 'Anjali Menon',
      customerPhone: user?.phoneNumber ?? '+91 98765 43210',
      serviceCategory: 'Medicines',
      title: 'Prescription Medicine Delivery',
      description: _medicineNameController.text.trim(),
      items: [
        RequestItem(name: _medicineNameController.text.trim(), quantity: '1 order', estimatedPrice: 245),
      ],
      pickupAddress: _selectedPharmacy,
      deliveryAddress: user?.address ?? 'Panampilly Nagar, Kochi',
      urgency: _urgency,
      preferredTime: 'Immediate (Within 45m)',
      status: RequestStatus.findingWorker,
      estimatedCost: 285.0,
      finalCost: 285.0,
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
        title: 'Medicine Request',
        subtitle: 'മരുന്നുകൾ വാങ്ങൽ',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prescription Upload Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _prescriptionAttached ? const Color(0xFFF1F8F1) : AppColors.cream,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(
                  color: _prescriptionAttached ? AppColors.primaryGreen : const Color(0xFFFFE082),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _prescriptionAttached ? Icons.task_alt_rounded : Icons.camera_alt_outlined,
                    size: 40,
                    color: _prescriptionAttached ? AppColors.primaryGreen : AppColors.darkOrange,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _prescriptionAttached ? 'Doctor\'s Prescription Attached ✓' : 'Upload Doctor\'s Prescription',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _prescriptionAttached ? AppColors.primaryGreen : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Clear photo helps worker procure exact dosage & brands',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() => _prescriptionAttached = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Prescription image attached successfully!'),
                              backgroundColor: AppColors.primaryGreen,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryGreen),
                        ),
                        icon: const Icon(Icons.camera_alt_rounded, size: 16),
                        label: const Text('Camera'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() => _prescriptionAttached = true);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryGreen),
                        ),
                        icon: const Icon(Icons.photo_library_rounded, size: 16),
                        label: const Text('Gallery'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Medicine Details
            const Text(
              'Medicine Names & Dosage',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            NanmaTextField(
              controller: _medicineNameController,
              hintText: 'e.g. Telma 40mg (1 strip), Paracetamol 650mg...',
              maxLines: 3,
            ),
            const SizedBox(height: 18),

            // Doctor / Special instructions
            const Text(
              'Doctor / Storage Instructions',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            NanmaTextField(
              controller: _doctorNotesController,
              hintText: 'e.g. Keep in cooling bag, check expiry...',
              maxLines: 2,
            ),
            const SizedBox(height: 18),

            // Pharmacy Preference
            const Text(
              'Pharmacy Preference',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedPharmacy,
                  items: [
                    'Neethi Medical Store (Government Subsidized)',
                    'Jan Aushadhi Medical Store',
                    'Apollo Pharmacy',
                    'Maveli Medical Store',
                    'Any nearest licensed pharmacy',
                  ].map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13)))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedPharmacy = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),

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
                    label: const Text('Urgent (Emergency)'),
                    selected: _urgency == RequestUrgency.urgent,
                    selectedColor: AppColors.ultraLightGreen,
                    onSelected: (_) => setState(() => _urgency = RequestUrgency.urgent),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Routine Today'),
                    selected: _urgency == RequestUrgency.normal,
                    selectedColor: AppColors.ultraLightGreen,
                    onSelected: (_) => setState(() => _urgency = RequestUrgency.normal),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Price estimate card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Estimated Medicine Cost & Delivery:', style: TextStyle(fontSize: 13, color: AppColors.textDark)),
                  Text('~ ₹285', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Submit Button
            NanmaButton(
              text: 'Find Nanma Worker to Procure →',
              onPressed: _submitMedicineRequest,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
