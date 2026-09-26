import '../../models/worker_model.dart';
import '../../models/service_request_model.dart';
import '../core/services/mock_data_service.dart';

class WorkerRepository {
  WorkerModel _currentWorker = MockDataService.primaryWorker;
  final List<WorkerModel> _allWorkers = List.from(MockDataService.sampleWorkers);

  WorkerModel get currentWorker => _currentWorker;
  List<WorkerModel> get allWorkers => List.unmodifiable(_allWorkers);

  void toggleOnlineStatus(bool isOnline) {
    _currentWorker = _currentWorker.copyWith(isOnline: isOnline);
  }

  List<ServiceRequestModel> getAvailableTasks() {
    return [
      ServiceRequestModel(
        id: 'task_w1',
        customerId: 'cust_08',
        customerName: 'Sita Ramachandran',
        customerPhone: '+91 94472 88123',
        serviceCategory: 'Groceries',
        title: 'Provision store items (Rice, Dal, Oil)',
        description: 'Need 5kg rice, 1kg toor dal, 1L Sunflower oil from Margin Free Market.',
        pickupAddress: 'Margin Free Market, Palarivattom',
        deliveryAddress: 'Green Acres, Padivattom, Kochi',
        urgency: RequestUrgency.urgent,
        preferredTime: 'Within 30 mins',
        status: RequestStatus.pending,
        estimatedCost: 120.0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ServiceRequestModel(
        id: 'task_w2',
        customerId: 'cust_09',
        customerName: 'George Joseph',
        customerPhone: '+91 98470 54321',
        serviceCategory: 'Medicines',
        title: 'Emergency Asthma Inhaler Delivery',
        description: 'Asthalin inhaler from Neethi Medicals or any nearby pharmacy urgently.',
        pickupAddress: 'Neethi Medicals, Kaloor',
        deliveryAddress: 'Apartment 2A, Skyline Manor, Kaloor',
        urgency: RequestUrgency.urgent,
        preferredTime: 'Immediate',
        status: RequestStatus.pending,
        estimatedCost: 95.0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ];
  }

  Future<void> updateVerificationStatus(String workerId, WorkerVerificationStatus status) async {
    final index = _allWorkers.indexWhere((w) => w.id == workerId);
    if (index != -1) {
      _allWorkers[index] = _allWorkers[index].copyWith(verificationStatus: status);
      if (_currentWorker.id == workerId) {
        _currentWorker = _currentWorker.copyWith(verificationStatus: status);
      }
    }
  }
}
