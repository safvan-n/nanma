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

class GroceryFlowScreen extends ConsumerStatefulWidget {
  const GroceryFlowScreen({super.key});

  @override
  ConsumerState<GroceryFlowScreen> createState() => _GroceryFlowScreenState();
}

class _GroceryFlowScreenState extends ConsumerState<GroceryFlowScreen> {
  final List<RequestItem> _items = [
    const RequestItem(name: 'Milma Milk Blue (500ml)', quantity: '2 packets', preferredBrand: 'Milma', estimatedPrice: 56),
    const RequestItem(name: 'Jaya Rice', quantity: '5 kg', preferredBrand: 'Pavizham / Nirapara', estimatedPrice: 240),
    const RequestItem(name: 'Coconut Oil', quantity: '1 Litre', preferredBrand: 'Kera', estimatedPrice: 190),
  ];

  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1 kg');
  final _brandController = TextEditingController();
  final _instructionsController = TextEditingController();
  String _preferredStore = 'Any nearby supermarket / Margin Free';
  RequestUrgency _urgency = RequestUrgency.urgent;
  bool _uploadedList = false;

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _brandController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_itemNameController.text.trim().isEmpty) return;
    setState(() {
      _items.add(
        RequestItem(
          name: _itemNameController.text.trim(),
          quantity: _quantityController.text.trim().isEmpty ? '1' : _quantityController.text.trim(),
          preferredBrand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
          estimatedPrice: 60,
        ),
      );
      _itemNameController.clear();
      _brandController.clear();
    });
  }

  double get _totalEstimated {
    return _items.fold(0.0, (sum, item) => sum + (item.estimatedPrice ?? 0)) + 45.0; // + delivery fee
  }

  void _proceedToMatching() async {
    final user = ref.read(currentUserProvider);
    final newRequest = ServiceRequestModel(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      customerId: user?.id ?? 'cust_01',
      customerName: user?.fullName ?? 'Anjali Menon',
      customerPhone: user?.phoneNumber ?? '+91 98765 43210',
      serviceCategory: 'Groceries',
      title: 'Grocery Order (${_items.length} items)',
      description: _instructionsController.text.trim().isEmpty
          ? 'Weekly grocery shopping list. Ensure fresh packed items.'
          : _instructionsController.text.trim(),
      items: _items,
      pickupAddress: _preferredStore,
      deliveryAddress: user?.address ?? 'Panampilly Nagar, Kochi',
      urgency: _urgency,
      preferredTime: 'Within 45 mins',
      status: RequestStatus.findingWorker,
      estimatedCost: _totalEstimated,
      finalCost: _totalEstimated,
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
        title: 'Grocery & Essentials',
        subtitle: 'പലചരക്ക് സാധനങ്ങൾ',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick shopping list upload banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: AppColors.primaryGreen, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Have a handwritten list?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Upload a photo of your paper list',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() => _uploadedList = !_uploadedList);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_uploadedList ? 'Shopping list image attached!' : 'Removed attached image.'),
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryGreen),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: Text(_uploadedList ? 'Attached ✓' : 'Upload', style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Add Item Section
            const Text(
              'Add Items to Basket',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Column(
                children: [
                  NanmaTextField(
                    controller: _itemNameController,
                    hintText: 'Item name (e.g. Sugar, Atta, Eggs)',
                    prefixIcon: const Icon(Icons.add_shopping_cart_rounded, color: AppColors.primaryGreen, size: 20),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: NanmaTextField(
                          controller: _quantityController,
                          hintText: 'Qty (e.g. 2 kg, 1 pkt)',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: NanmaTextField(
                          controller: _brandController,
                          hintText: 'Brand preference (Optional)',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  NanmaButton(
                    text: '+ Add Item',
                    height: 42,
                    backgroundColor: AppColors.ultraLightGreen,
                    foregroundColor: AppColors.primaryGreen,
                    onPressed: _addItem,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Current Items List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shopping List (${_items.length} items)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                Text(
                  'Est: ₹${_totalEstimated.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, color: AppColors.primaryGreen, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                            ),
                            Text(
                              'Qty: ${item.quantity}${item.preferredBrand != null ? ' • ${item.preferredBrand}' : ''}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${(item.estimatedPrice ?? 0).toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textLight),
                        onPressed: () {
                          setState(() {
                            _items.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Store preference & Special notes
            const Text(
              'Store Preference & Delivery Notes',
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
                  value: _preferredStore,
                  items: [
                    'Any nearby supermarket / Margin Free',
                    'Lulu Hypermarket',
                    'Bismi Hypermart',
                    'Supplyco People\'s Bazaar',
                    'Local neighborhood provision store',
                  ].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _preferredStore = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            NanmaTextField(
              controller: _instructionsController,
              hintText: 'Special instructions for worker (e.g. Ring bell, alternative brand ok)...',
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            // Urgency selector
            const Text(
              'Delivery Urgency',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Urgent (30-45m)'),
                    selected: _urgency == RequestUrgency.urgent,
                    selectedColor: AppColors.ultraLightGreen,
                    onSelected: (val) => setState(() => _urgency = RequestUrgency.urgent),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Flexible Today'),
                    selected: _urgency == RequestUrgency.normal,
                    selectedColor: AppColors.ultraLightGreen,
                    onSelected: (val) => setState(() => _urgency = RequestUrgency.normal),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Submit Request Button
            NanmaButton(
              text: 'Find Nanma Helper (₹${_totalEstimated.toStringAsFixed(0)}) →',
              onPressed: _items.isEmpty ? null : _proceedToMatching,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
