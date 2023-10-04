class ChatRoom {
  final int id;
  final int user1;
  final int user2;

  ChatRoom({
    required this.id,
    required this.user1,
    required this.user2,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      user1: json['user1'],
      user2: json['user2'],
    );
  }
}