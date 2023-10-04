import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login/Member/ChatRoom.dart';
import 'package:http/http.dart' as http;
import 'package:login/Pages/IndividualPage.dart';

class ChatroomList extends StatefulWidget {
  const ChatroomList({Key? key, required this.loginId}) : super(key: key);
  final int loginId;
  @override
  State<ChatroomList> createState() => _ChatroomListState();
}
class _ChatroomListState extends State<ChatroomList> {
  List<ChatRoom> chatRoomList = [];

  @override
  void initState() {
    super.initState();
    fetchChatroomList();
  }

  void fetchChatroomList() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/chatRoom/findAll'),
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<ChatRoom> chatrooms =
          responseData.map((data) => ChatRoom.fromJson(data)).toList();

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

          return ListTile(
            title:Text('참여자:${chatRoom.user2}'),
            onTap: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IndividualPage(
                    user1:widget.loginId,
                    user2: chatRoom.user2,
                    roomId: chatRoom.id,
                  ),
                ),
              );
             
            },
          );
        },
      ),
    );
  }
  
  
}
