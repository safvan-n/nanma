import '../../models/user_model.dart';
import '../../models/worker_model.dart';
import '../../models/service_request_model.dart';
import '../../models/chat_message_model.dart';
import '../../models/payment_receipt_model.dart';

/// Abstract Firebase Service Contract
/// When actual Firebase project credentials (google-services.json / GoogleService-Info.plist)
/// are connected, implement these interfaces using cloud_firestore, firebase_auth, and firebase_storage.
abstract class IFirebaseAuthService {
  Future<UserModel?> getCurrentUser();
  Future<void> sendPhoneOtp(String phoneNumber);
  Future<UserModel> verifyOtpAndLogin(String phoneNumber, String otp);
  Future<UserModel> registerUser(UserModel user);
  Future<void> signOut();
}

abstract class IFirebaseFirestoreService {
  // Requests
  Stream<List<ServiceRequestModel>> getCustomerRequests(String customerId);
  Stream<List<ServiceRequestModel>> getAvailableWorkerRequests();
  Future<void> createRequest(ServiceRequestModel request);
  Future<void> updateRequestStatus(String requestId, RequestStatus status);
  Future<void> assignWorkerToRequest(String requestId, WorkerModel worker);

  // Chat
  Stream<List<ChatMessageModel>> getChatMessages(String requestId);
  Future<void> sendMessage(String requestId, ChatMessageModel message);

  // Payments
  Future<void> recordPayment(PaymentReceiptModel receipt);
}

abstract class IFirebaseStorageService {
  Future<String> uploadImage(String folder, String filePath);
  Future<String> uploadVoiceNote(String requestId, String filePath);
}
