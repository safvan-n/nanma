import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/payment_receipt_model.dart';
import '../../../models/service_request_model.dart';
import '../../../widgets/nanma_app_bar.dart';
import '../../../widgets/nanma_button.dart';
import '../../../providers/app_providers.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String requestId;

  const PaymentScreen({super.key, required this.requestId});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.upi;
  double _tipAmount = 20.0;
  bool _isProcessing = false;

  final double _itemCost = 340.0;
  final double _serviceCost = 120.0;
  final double _deliveryFee = 45.0;
  final double _platformFee = 15.0;
  final double _discount = 20.0;

  double get _totalAmount {
    return _itemCost + _serviceCost + _deliveryFee + _platformFee - _discount + _tipAmount;
  }

  void _processPayment() async {
    setState(() => _isProcessing = true);

    await Future.delayed(const Duration(milliseconds: 1400));

    if (mounted) {
      await ref.read(requestsProvider.notifier).updateStatus(widget.requestId, RequestStatus.completed);
      if (!mounted) return;
      setState(() => _isProcessing = false);
      context.go('/completion/${widget.requestId}?total=$_totalAmount');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanmaAppBar(
        title: 'Payment & Receipt',
        subtitle: 'സുരക്ഷിത പേയ്‌മെന്റ്',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill Breakdown Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bill Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 14),
                  _buildBillRow('Item Cost (Verified store receipt)', '₹${_itemCost.toStringAsFixed(0)}'),
                  _buildBillRow('Service / Labor Cost', '₹${_serviceCost.toStringAsFixed(0)}'),
                  _buildBillRow('Delivery Fee', '₹${_deliveryFee.toStringAsFixed(0)}'),
                  _buildBillRow('Platform Fee', '₹${_platformFee.toStringAsFixed(0)}'),
                  _buildBillRow('Help Points Discount', '-₹${_discount.toStringAsFixed(0)}', isDiscount: true),
                  if (_tipAmount > 0)
                    _buildBillRow('Worker Tip ❤️', '₹${_tipAmount.toStringAsFixed(0)}', isTip: true),
                  const Divider(height: 24, color: AppColors.divider),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Payable',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      Text(
                        '₹${_totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tip Selection Section (Requirement 29)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppDimensions.roundedMd,
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.volunteer_activism_rounded, color: AppColors.darkOrange, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Thank your Nanma worker ❤️',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '100% of your tip goes directly to Ravi Kumar',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [0.0, 10.0, 20.0, 50.0, 100.0].map((tip) {
                      final isSelected = _tipAmount == tip;
                      return ChoiceChip(
                        label: Text(tip == 0.0 ? 'None' : '₹${tip.toStringAsFixed(0)}'),
                        selected: isSelected,
                        selectedColor: AppColors.primaryGreen,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        onSelected: (_) => setState(() => _tipAmount = tip),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods (Requirement 28)
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            RadioGroup<PaymentMethod>(
              groupValue: _selectedMethod,
              onChanged: (val) {
                if (val != null) setState(() => _selectedMethod = val);
              },
              child: Column(
                children: [
                  _buildMethodTile(PaymentMethod.upi, 'UPI (Google Pay, PhonePe, Paytm, BHIM)', Icons.account_balance_rounded),
                  _buildMethodTile(PaymentMethod.card, 'Credit / Debit Card', Icons.credit_card_rounded),
                  _buildMethodTile(PaymentMethod.netBanking, 'Net Banking (Kerala Grameen, SBI, Federal)', Icons.account_balance_outlined),
                  _buildMethodTile(PaymentMethod.wallet, 'Nanma Community Wallet', Icons.account_balance_wallet_rounded),
                  _buildMethodTile(PaymentMethod.cash, 'Cash on Delivery to Helper', Icons.payments_outlined),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Pay Button
            NanmaButton(
              text: 'Pay ₹${_totalAmount.toStringAsFixed(0)} Securely →',
              isLoading: _isProcessing,
              onPressed: _processPayment,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isDiscount = false, bool isTip = false}) {
    Color color = AppColors.textDark;
    if (isDiscount) color = AppColors.primaryGreen;
    if (isTip) color = AppColors.darkOrange;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildMethodTile(PaymentMethod method, String title, IconData icon) {
    final isSelected = _selectedMethod == method;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.cream.withValues(alpha: 0.5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryGreen : AppColors.borderSubtle,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        dense: true,
        onTap: () => setState(() => _selectedMethod = method),
        leading: Icon(icon, color: isSelected ? AppColors.primaryGreen : AppColors.textLight),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
        trailing: Radio<PaymentMethod>(
          value: method,
          activeColor: AppColors.primaryGreen,
        ),
      ),
    );
  }
}
