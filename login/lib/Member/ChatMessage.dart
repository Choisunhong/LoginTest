
class ChatMessage {
  final int id; // 메시지 ID
  late final String content; // 메시지 내용
  final String roomId; // 채팅방 ID
  final String sender; // 보낸 사람
  final String receiver; // 받는 사람
  final String createdAt; // 메시지 작성 시간
  final MessageType msgType; // 메시지 타입

  ChatMessage({
    required this.id,
    required this.content,
    required this.roomId,
    required this.sender,
    required this.receiver,
    required this.createdAt,
    required this.msgType,
  });
 factory ChatMessage.fromJson(Map<String, dynamic> json) {
 
  return ChatMessage(
    id: json['id'],
    content: json['content'] ?? '',
    roomId: json['roomId'] != null ? json['roomId'].toString() : '',
    sender: json['sender'] ?? '',
    receiver: json['receiver'] ?? '',
    createdAt: json['createdAt'] ?? '',
     msgType: MessageTypeExtension.fromString(json['msgType'] ?? ''),
  );
}

  
}
enum MessageType {
  TALK, 
  HATE,
  CLEAN, 
}
extension MessageTypeExtension on MessageType{
  static MessageType fromString(String value) {
   
  switch (value) {
    case "HATE":
      return MessageType.HATE;
    case "CLEAN":
      return MessageType.CLEAN;
    default:
      return MessageType.TALK; // 만약 값이 인식되지 않으면 TALK로 기본 설정
  }
}

}

