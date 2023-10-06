class ChatMessage {
  final int id; // 메시지 ID
  final String content; // 메시지 내용
  final String roomId; // 채팅방 ID
  final String sender; // 보낸 사람
  final String receiver; // 받는 사람
  final String createdAt; // 메시지 작성 시간
  final MessageType messageType; // 메시지 타입

  ChatMessage({
    required this.id,
    required this.content,
    required this.roomId,
    required this.sender,
    required this.receiver,
    required this.createdAt,
    required this.messageType,
  });
 factory ChatMessage.fromJson(Map<String, dynamic> json) {
  return ChatMessage(
    id: json['id'],
    content: json['content'] ?? '',
    roomId: json['roomId'] ?? '',
    sender: json['sender'] ?? '',
    receiver: json['receiver'] ?? '',
    createdAt: json['createdAt'] ?? '',
    messageType: (json['messageType'] != null && json['messageType'] < MessageType.values.length)
      ? MessageType.values[json['messageType']]
      : MessageType.TALK,
  );
}

  
}
enum MessageType {
  TALK, 
  HATE_SPEECH, 
}

extension MessageTypeExtension on MessageType {
  int get value {
    switch (this) {
      case MessageType.TALK:
        return 0;
      case MessageType.HATE_SPEECH:
        return 1;
      default:
        throw Exception("Unknown MessageType: $this");
    }
  }
  
  static MessageType fromValue(int value) {
    switch (value) {
      case 0:
        return MessageType.TALK;
      case 1:
        return MessageType.HATE_SPEECH;
      default:
        throw Exception("Unknown MessageType value: $value");
    }
  }
}