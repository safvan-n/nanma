import 'worker_model.dart';

enum RequestStatus {
  pending,
  findingWorker,
  workerAssigned,
  onTheWay,
  shoppingWorking,
  delivering,
  completed,
  cancelled,
}

enum RequestUrgency {
  normal,
  urgent,
  scheduled,
}

class RequestItem {
  final String name;
  final String quantity;
  final String? preferredBrand;
  final String? alternativeBrand;
  final double? estimatedPrice;

  const RequestItem({
    required this.name,
    required this.quantity,
    this.preferredBrand,
    this.alternativeBrand,
    this.estimatedPrice,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'quantity': quantity,
    'preferredBrand': preferredBrand,
    'alternativeBrand': alternativeBrand,
    'estimatedPrice': estimatedPrice,
  };

  factory RequestItem.fromMap(Map<String, dynamic> map) => RequestItem(
    name: map['name'] ?? '',
    quantity: map['quantity'] ?? '1',
    preferredBrand: map['preferredBrand'],
    alternativeBrand: map['alternativeBrand'],
    estimatedPrice: map['estimatedPrice']?.toDouble(),
  );
}

class ServiceRequestModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String serviceCategory;
  final String title;
  final String description;
  final List<RequestItem> items;
  final List<String> photoUrls;
  final String? voiceNoteUrl;
  final String pickupAddress;
  final String deliveryAddress;
  final RequestUrgency urgency;
  final String preferredTime;
  final RequestStatus status;
  final double estimatedCost;
  final double finalCost;
  final double tipAmount;
  final WorkerModel? assignedWorker;
  final DateTime createdAt;
  final double? rating;
  final String? review;
  final List<String> tags;
  final String? familyMemberName;

  const ServiceRequestModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.serviceCategory,
    required this.title,
    required this.description,
    this.items = const [],
    this.photoUrls = const [],
    this.voiceNoteUrl,
    required this.pickupAddress,
    required this.deliveryAddress,
    this.urgency = RequestUrgency.normal,
    required this.preferredTime,
    this.status = RequestStatus.pending,
    this.estimatedCost = 150.0,
    this.finalCost = 150.0,
    this.tipAmount = 0.0,
    this.assignedWorker,
    required this.createdAt,
    this.rating,
    this.review,
    this.tags = const [],
    this.familyMemberName,
  });

  ServiceRequestModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? serviceCategory,
    String? title,
    String? description,
    List<RequestItem>? items,
    List<String>? photoUrls,
    String? voiceNoteUrl,
    String? pickupAddress,
    String? deliveryAddress,
    RequestUrgency? urgency,
    String? preferredTime,
    RequestStatus? status,
    double? estimatedCost,
    double? finalCost,
    double? tipAmount,
    WorkerModel? assignedWorker,
    DateTime? createdAt,
    double? rating,
    String? review,
    List<String>? tags,
    String? familyMemberName,
  }) {
    return ServiceRequestModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      title: title ?? this.title,
      description: description ?? this.description,
      items: items ?? this.items,
      photoUrls: photoUrls ?? this.photoUrls,
      voiceNoteUrl: voiceNoteUrl ?? this.voiceNoteUrl,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      urgency: urgency ?? this.urgency,
      preferredTime: preferredTime ?? this.preferredTime,
      status: status ?? this.status,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      finalCost: finalCost ?? this.finalCost,
      tipAmount: tipAmount ?? this.tipAmount,
      assignedWorker: assignedWorker ?? this.assignedWorker,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      tags: tags ?? this.tags,
      familyMemberName: familyMemberName ?? this.familyMemberName,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'customerId': customerId,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'serviceCategory': serviceCategory,
    'title': title,
    'description': description,
    'items': items.map((x) => x.toMap()).toList(),
    'photoUrls': photoUrls,
    'voiceNoteUrl': voiceNoteUrl,
    'pickupAddress': pickupAddress,
    'deliveryAddress': deliveryAddress,
    'urgency': urgency.name,
    'preferredTime': preferredTime,
    'status': status.name,
    'estimatedCost': estimatedCost,
    'finalCost': finalCost,
    'tipAmount': tipAmount,
    'assignedWorker': assignedWorker?.toMap(),
    'createdAt': createdAt.toIso8601String(),
    'rating': rating,
    'review': review,
    'tags': tags,
    'familyMemberName': familyMemberName,
  };
}
