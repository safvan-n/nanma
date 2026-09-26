import '../../models/user_model.dart';
import '../../models/worker_model.dart';
import '../../models/service_request_model.dart';
import '../../models/complaint_model.dart';
import '../core/services/mock_data_service.dart';

class AdminRepository {
  final List<UserModel> _users = [
    MockDataService.defaultCustomer,
    const UserModel(
      id: 'user_002',
      phoneNumber: '+91 94460 77112',
      fullName: 'Gopika Nambiar',
      address: 'Sea View Heights, Marine Drive, Kochi',
      pincode: '682031',
      district: 'Ernakulam',
      helpPoints: 310,
    ),
    const UserModel(
      id: 'user_003',
      phoneNumber: '+91 98471 22334',
      fullName: 'Mathew Thomas',
      address: 'Thrikkakara, Kakkanad, Kochi',
      pincode: '682021',
      district: 'Ernakulam',
      helpPoints: 180,
    ),
  ];

  final List<WorkerModel> _workers = List.from(MockDataService.sampleWorkers);
  final List<ComplaintModel> _complaints = List.from(MockDataService.sampleComplaints);
  final List<ServiceRequestModel> _requests = List.from(MockDataService.sampleRequests);

  List<UserModel> get users => List.unmodifiable(_users);
  List<WorkerModel> get workers => List.unmodifiable(_workers);
  List<ComplaintModel> get complaints => List.unmodifiable(_complaints);
  List<ServiceRequestModel> get requests => List.unmodifiable(_requests);

  // Admin KPI metrics
  int get totalUsers => 1420;
  int get activeWorkers => 86;
  int get activeRequests => 19;
  int get completedRequests => 3892;
  double get totalRevenue => 148500.0;
  int get pendingVerifications => 7;
  double get averageRating => 4.88;

  void resolveComplaint(String id, String resolutionNotes) {
    final index = _complaints.indexWhere((c) => c.id == id);
    if (index != -1) {
      _complaints[index] = _complaints[index].copyWith(
        status: ComplaintStatus.resolved,
        adminNotes: resolutionNotes,
      );
    }
  }

  void verifyWorker(String workerId, WorkerVerificationStatus status) {
    final index = _workers.indexWhere((w) => w.id == workerId);
    if (index != -1) {
      _workers[index] = _workers[index].copyWith(verificationStatus: status);
    }
  }
}
