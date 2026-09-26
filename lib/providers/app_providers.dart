import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/worker_model.dart';
import '../models/service_request_model.dart';
import '../models/chat_message_model.dart';
import '../repositories/auth_repository.dart';
import '../repositories/request_repository.dart';
import '../repositories/worker_repository.dart';
import '../repositories/chat_repository.dart';
import '../repositories/admin_repository.dart';

// Repository Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return RequestRepository();
});

final workerRepositoryProvider = Provider<WorkerRepository>((ref) {
  return WorkerRepository();
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});

// App State Providers
final currentUserProvider = StateProvider<UserModel?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.currentUser;
});

final currentRoleProvider = StateProvider<UserRole>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.role ?? UserRole.customer;
});

final appLanguageProvider = StateProvider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.language ?? 'en';
});

final elderlyModeProvider = StateProvider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isElderlyModeEnabled ?? false;
});

final customerNavIndexProvider = StateProvider<int>((ref) => 0);
final workerNavIndexProvider = StateProvider<int>((ref) => 0);

// Request Management Notifier
class RequestNotifier extends StateNotifier<List<ServiceRequestModel>> {
  final RequestRepository _repo;

  RequestNotifier(this._repo) : super(_repo.allRequests);

  void refresh() {
    state = _repo.allRequests;
  }

  Future<ServiceRequestModel> addRequest(ServiceRequestModel request) async {
    final created = await _repo.createRequest(request);
    state = _repo.allRequests;
    return created;
  }

  Future<void> updateStatus(String id, RequestStatus status) async {
    await _repo.updateStatus(id, status);
    state = _repo.allRequests;
  }

  Future<void> assignWorker(String id, WorkerModel worker) async {
    await _repo.assignWorker(id, worker);
    state = _repo.allRequests;
  }

  Future<void> submitRating({
    required String id,
    required double rating,
    required String review,
    required List<String> tags,
    double tipAmount = 0.0,
  }) async {
    await _repo.submitRating(
      requestId: id,
      rating: rating,
      review: review,
      tags: tags,
      tipAmount: tipAmount,
    );
    state = _repo.allRequests;
  }
}

final requestsProvider = StateNotifierProvider<RequestNotifier, List<ServiceRequestModel>>((ref) {
  final repo = ref.watch(requestRepositoryProvider);
  return RequestNotifier(repo);
});

// Chat Notifier
class ChatNotifier extends StateNotifier<List<ChatMessageModel>> {
  final ChatRepository _repo;
  final String _requestId;

  ChatNotifier(this._repo, this._requestId) : super(_repo.getMessagesForRequest(_requestId));

  void sendMessage(String text, {bool isFromCustomer = true, MessageType type = MessageType.text}) {
    final msg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: isFromCustomer ? 'user_001' : 'worker_001',
      senderName: isFromCustomer ? 'You' : 'Ravi Kumar',
      isFromCustomer: isFromCustomer,
      content: text,
      type: type,
      timestamp: DateTime.now(),
    );
    _repo.addMessage(_requestId, msg);
    state = _repo.getMessagesForRequest(_requestId);
  }
}

final chatProviderFamily = StateNotifierProvider.family<ChatNotifier, List<ChatMessageModel>, String>(
  (ref, requestId) {
    final repo = ref.watch(chatRepositoryProvider);
    return ChatNotifier(repo, requestId);
  },
);
