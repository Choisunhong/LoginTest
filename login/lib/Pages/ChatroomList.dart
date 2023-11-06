import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/Pages/IndividualPage.dart';

import '../DTO/ChatRoomListResponse.dart';

class ChatroomList extends StatefulWidget {
  const ChatroomList({Key? key, required this.loginId}) : super(key: key);
  final int loginId;
  @override
  State<ChatroomList> createState() => _ChatroomListState();
}

class _ChatroomListState extends State<ChatroomList> {
  List<ChatRoomListResponse> chatRoomList = [];

  @override
  void initState() {
    super.initState();
    fetchChatroomList();
  }

  void fetchChatroomList() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/chatRoom/find/user/${widget.loginId}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<ChatRoomListResponse> chatrooms = responseData
          .map((data) => ChatRoomListResponse.fromJson(data))
          .toList();

      setState(() {
        chatRoomList = chatrooms;
      });
    } else {
      print('오류 발생: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: chatRoomList.length,
      itemBuilder: (context, index) {
        final chatRoom = chatRoomList[index];

        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFB1EEB3),
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            title: Text(
              chatRoom.otherPersonName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IndividualPage(
                    user1: widget.loginId,
                    user2: chatRoom.otherPersonId,
                    roomId: chatRoom.roomId,
                  ),
                ),
              );
            },
          ),
        );
      },
    ));
  }
}
