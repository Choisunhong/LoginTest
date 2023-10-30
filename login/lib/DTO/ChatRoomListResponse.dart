import 'package:flutter/material.dart';

class ChatRoomListResponse{
  final int roomId;
  final String otherPersonName;
  final int otherPersonId;

ChatRoomListResponse ({
 required this.roomId,
 required this.otherPersonName,
 required this.otherPersonId

 });
 factory ChatRoomListResponse.fromJson(Map<String, dynamic> json) {
    return ChatRoomListResponse(
      roomId: json['roomId'],
      otherPersonName: json['otherPersonName'],
      otherPersonId: json['otherPersonId'],
    );
  }


}
