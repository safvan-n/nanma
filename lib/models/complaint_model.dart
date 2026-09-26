enum ComplaintStatus {
  open,
  investigating,
  resolved,
}

enum ComplaintPriority {
  low,
  medium,
  high,
}

class ComplaintModel {
  final String id;
  final String customerName;
  final String workerName;
  final String requestId;
  final String issue;
  final ComplaintPriority priority;
  final ComplaintStatus status;
  final String adminNotes;
  final DateTime createdAt;

  const ComplaintModel({
    required this.id,
    required this.customerName,
    required this.workerName,
    required this.requestId,
    required this.issue,
    required this.priority,
    required this.status,
    required this.adminNotes,
    required this.createdAt,
  });

  ComplaintModel copyWith({
    ComplaintStatus? status,
    String? adminNotes,
  }) {
    return ComplaintModel(
      id: id,
      customerName: customerName,
      workerName: workerName,
      requestId: requestId,
      issue: issue,
      priority: priority,
      status: status ?? this.status,
      adminNotes: adminNotes ?? this.adminNotes,
      createdAt: createdAt,
    );
  }
}
