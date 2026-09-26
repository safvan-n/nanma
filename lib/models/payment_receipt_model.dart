enum PaymentMethod {
  upi,
  card,
  netBanking,
  wallet,
  cash,
}

enum PaymentStatus {
  processing,
  successful,
  failed,
  pending,
}

class PaymentReceiptModel {
  final String transactionId;
  final String requestId;
  final double itemCost;
  final double serviceCost;
  final double deliveryFee;
  final double platformFee;
  final double discount;
  final double tipAmount;
  final double totalAmount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime paidAt;

  const PaymentReceiptModel({
    required this.transactionId,
    required this.requestId,
    required this.itemCost,
    required this.serviceCost,
    required this.deliveryFee,
    this.platformFee = 15.0,
    this.discount = 20.0,
    this.tipAmount = 0.0,
    required this.totalAmount,
    required this.method,
    this.status = PaymentStatus.successful,
    required this.paidAt,
  });

  factory PaymentReceiptModel.calculate({
    required String transactionId,
    required String requestId,
    required double itemCost,
    required double serviceCost,
    required double deliveryFee,
    double tipAmount = 0.0,
    PaymentMethod method = PaymentMethod.upi,
  }) {
    const platformFee = 15.0;
    const discount = 20.0;
    final total = itemCost + serviceCost + deliveryFee + platformFee - discount + tipAmount;
    return PaymentReceiptModel(
      transactionId: transactionId,
      requestId: requestId,
      itemCost: itemCost,
      serviceCost: serviceCost,
      deliveryFee: deliveryFee,
      platformFee: platformFee,
      discount: discount,
      tipAmount: tipAmount,
      totalAmount: total > 0 ? total : 0.0,
      method: method,
      status: PaymentStatus.successful,
      paidAt: DateTime.now(),
    );
  }
}
