import '../../models/service_request_model.dart';
import '../../models/worker_model.dart';
import '../core/services/mock_data_service.dart';

class RequestRepository {
  final List<ServiceRequestModel> _requests = List.from(MockDataService.sampleRequests);

  List<ServiceRequestModel> get allRequests => List.unmodifiable(_requests);

  List<ServiceRequestModel> get activeRequests => _requests
      .where((r) =>
          r.status != RequestStatus.completed &&
          r.status != RequestStatus.cancelled)
      .toList();

  List<ServiceRequestModel> get completedRequests =>
      _requests.where((r) => r.status == RequestStatus.completed).toList();

  List<ServiceRequestModel> get cancelledRequests =>
      _requests.where((r) => r.status == RequestStatus.cancelled).toList();

  ServiceRequestModel? getRequestById(String id) {
    try {
      return _requests.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<ServiceRequestModel> createRequest(ServiceRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _requests.insert(0, request);
    return request;
  }

  Future<void> updateStatus(String requestId, RequestStatus newStatus) async {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _requests[index] = _requests[index].copyWith(status: newStatus);
    }
  }

  Future<void> assignWorker(String requestId, WorkerModel worker) async {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _requests[index] = _requests[index].copyWith(
        assignedWorker: worker,
        status: RequestStatus.workerAssigned,
      );
    }
  }

  Future<void> submitRating({
    required String requestId,
    required double rating,
    required String review,
    required List<String> tags,
    double tipAmount = 0.0,
  }) async {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _requests[index] = _requests[index].copyWith(
        rating: rating,
        review: review,
        tags: tags,
        tipAmount: tipAmount,
        status: RequestStatus.completed,
      );
    }
  }
}
