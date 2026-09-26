import '../../models/chat_message_model.dart';
import '../core/services/mock_data_service.dart';

class ChatRepository {
  final Map<String, List<ChatMessageModel>> _chats = {
    'req_101': List.from(MockDataService.sampleChatMessages),
  };

  List<ChatMessageModel> getMessagesForRequest(String requestId) {
    if (!_chats.containsKey(requestId)) {
      _chats[requestId] = [
        ChatMessageModel(
          id: 'sys_${DateTime.now().millisecondsSinceEpoch}',
          senderId: 'system',
          senderName: 'Nanma Security',
          isFromCustomer: false,
          content: 'Never share OTP, passwords or sensitive payment information.',
          type: MessageType.systemNotice,
          timestamp: DateTime.now(),
        ),
        ChatMessageModel(
          id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
          senderId: 'worker_001',
          senderName: 'Nanma Worker',
          isFromCustomer: false,
          content: 'Namaskaram! I have received your request and am getting ready to assist.',
          type: MessageType.text,
          timestamp: DateTime.now(),
        ),
      ];
    }
    return List.unmodifiable(_chats[requestId]!);
  }

  void addMessage(String requestId, ChatMessageModel message) {
    if (!_chats.containsKey(requestId)) {
      _chats[requestId] = [];
    }
    _chats[requestId]!.add(message);
  }
}
