class FriendListResponse {
  int friendId;
  String friendName;

  FriendListResponse({required this.friendId, required this.friendName});

  factory FriendListResponse.fromJson(Map<String, dynamic> json) {
    return FriendListResponse(
      friendId: json['friendId'],
      friendName: json['friendName'],
    );
  }
}