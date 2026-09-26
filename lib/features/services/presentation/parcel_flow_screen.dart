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

class ParcelFlowScreen extends ConsumerStatefulWidget {
  const ParcelFlowScreen({super.key});

  @override
  ConsumerState<ParcelFlowScreen> createState() => _ParcelFlowScreenState();
}

class _ParcelFlowScreenState extends ConsumerState<ParcelFlowScreen> {
  final _pickupController = TextEditingController(text: 'House 14, Panampilly Nagar, Kochi');
  final _destinationController = TextEditingController(text: 'Edappally Toll, Near Metro Pillar 382');
  final _contactPersonController = TextEditingController(text: 'Suresh Menon');
  final _contactPhoneController = TextEditingController(text: '94471 99887');
  final _instructionsController = TextEditingController();

  String _parcelSize = 'Small (Keys, Documents, Tiffin box)';
  bool _isFragile = false;
  double _priceEstimate = 85.0;

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _submitParcel() async {
    final user = ref.read(currentUserProvider);
    final newRequest = ServiceRequestModel(
      id: 'par_${DateTime.now().millisecondsSinceEpoch}',
      customerId: user?.id ?? 'cust_01',
      customerName: user?.fullName ?? 'Anjali Menon',
      customerPhone: user?.phoneNumber ?? '+91 98765 43210',
      serviceCategory: 'Parcel & Pickup',
      title: 'Local Parcel Delivery ($_parcelSize)',
      description: 'Recipient: ${_contactPersonController.text} (${_contactPhoneController.text}). Fragile: $_isFragile. ${_instructionsController.text}',
      pickupAddress: _pickupController.text.trim(),
      deliveryAddress: _destinationController.text.trim(),
      urgency: RequestUrgency.urgent,
      preferredTime: 'Within 30-40 mins',
      status: RequestStatus.findingWorker,
      estimatedCost: _priceEstimate,
      finalCost: _priceEstimate,
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
        title: 'Parcel Pickup & Drop',
        subtitle: 'പാഴ്സൽ കൊറിയർ',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Addresses
            const Text(
              'Route & Locations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            NanmaTextField(
              controller: _pickupController,
              label: 'Pickup Address',
              prefixIcon: const Icon(Icons.my_location_rounded, color: AppColors.primaryGreen, size: 20),
            ),
            const SizedBox(height: 14),
            NanmaTextField(
              controller: _destinationController,
              label: 'Destination Address',
              prefixIcon: const Icon(Icons.location_on_rounded, color: AppColors.darkOrange, size: 20),
            ),
            const SizedBox(height: 20),

            // Recipient Details
            const Text(
              'Recipient Contact',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: NanmaTextField(
                    controller: _contactPersonController,
                    label: 'Contact Name',
                    hintText: 'Recipient name',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: NanmaTextField(
                    controller: _contactPhoneController,
                    label: 'Phone Number',
                    hintText: '10-digit phone',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Parcel size
            const Text(
              'Parcel Size & Nature',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
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
                  value: _parcelSize,
                  items: [
                    'Small (Keys, Documents, Tiffin box)',
                    'Medium (Shoebox, Clothes, Electronics)',
                    'Large (Carton up to 10kg)',
                  ].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _parcelSize = val;
                        if (val.startsWith('Small')) _priceEstimate = 85;
                        if (val.startsWith('Medium')) _priceEstimate = 120;
                        if (val.startsWith('Large')) _priceEstimate = 180;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Fragile checkbox
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primaryGreen,
              title: const Text('Fragile or Handle with Extra Care', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              value: _isFragile,
              onChanged: (val) => setState(() => _isFragile = val ?? false),
            ),
            const SizedBox(height: 14),

            // Instructions
            NanmaTextField(
              controller: _instructionsController,
              label: 'Instructions for Helper (Optional)',
              hintText: 'e.g. Leave with security guard, call before ringing...',
            ),
            const SizedBox(height: 24),

            // Price estimate card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estimated Delivery Charge:', style: TextStyle(fontSize: 13, color: AppColors.textDark)),
                      Text('Based on 4.2 km distance in Kochi', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                  Text('₹${_priceEstimate.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Confirm
            NanmaButton(
              text: 'Find Nearby Courier Worker →',
              onPressed: _submitParcel,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
