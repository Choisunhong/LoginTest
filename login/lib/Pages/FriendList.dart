import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Member/Member.dart';
import 'IndividualPage.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key, required this.loginId}) : super(key: key);
  final int loginId;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<Member> friendList = [];

  @override
  void initState() {
    super.initState();
    fetchFriends(); 
  }

  void fetchFriends() async {
    final response = await http.get(
        Uri.parse('http://localhost:8080/user/${widget.loginId}/findFriends'));

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<Member> friends =
          responseData.map((data) => Member.fromJson(data)).toList();

      setState(() {
        friendList = friends;
      });
    } else {
      print('오류 발생: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: friendList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  _showCreateChatRoom(context, index);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF39E64F),
                    child: Text(
                      friendList[index].userName[0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    friendList[index].userName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                height: 1,
                color: Colors.grey,
              ),
            ],
          );
        },
      ),
    );
  }
Future<int> createChatRoom(int index) async {
  try { 
    final response = await http.post(
      Uri.parse('http://localhost:8080/chatRoom/create'),
      body: {
        'user1': widget.loginId.toString(),
        'user2': friendList[index].id.toString(),
      },
      ); 
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      int roomIdValue = responseData['id'];
      return roomIdValue;
      
    } else {
      print('Failed to create chat room');
      return 111111111111 ;
    }
  } catch (error) {
    print('Error during chat room creation: $error');
    return 22;
  }
}

  void _showCreateChatRoom(BuildContext context, int index) async {
     Object roomIdValue = await createChatRoom(index);
    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("채팅방 생성"),
            content: Text("1:1 채팅방을 생성하시겠습니까?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("취소"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndividualPage(
                        user1: widget.loginId,
                        user2: friendList[index].id,
                        roomId: roomIdValue,
                      ),
                    ),
                  );
                },
                child: Text("생성"),
              )
            ],
          );
        });
  }
  
}
