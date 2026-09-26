enum MessageType {
  text,
  image,
  quickReply,
  location,
  voice,
  systemNotice,
}

class ChatMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final bool isFromCustomer;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;

  const ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.isFromCustomer,
    required this.content,
    this.type = MessageType.text,
    required this.timestamp,
    this.isRead = true,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'senderId': senderId,
    'senderName': senderName,
    'isFromCustomer': isFromCustomer,
    'content': content,
    'type': type.name,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
  };
}
