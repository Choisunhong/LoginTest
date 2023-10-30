import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../DTO/FriendListResponse.dart';
import '../Member/Member.dart';
import 'IndividualPage.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key, required this.loginId, required this.userName})
      : super(key: key);
  final int loginId;
  final String userName;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<FriendListResponse> friendList = [];

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  void fetchFriends() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/friend/follow/list/${widget.userName}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));
        List<FriendListResponse> friends = responseData
            .map((data) => FriendListResponse.fromJson(data))
            .toList();

        setState(() {
          friendList = friends;
        });
      } else {
        print('오류 발생: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during fetching friends: $error');
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
                  leading: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  title: Text(
                    friendList[index].friendName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
          'user2': friendList[index].friendId.toString(),
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        int roomIdValue = responseData['id'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("채팅방 생성"),
              content: Text("1:1 채팅방을 생성하시겠습니까?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualPage(
                          user1: widget.loginId,
                          user2: friendList[index].friendId,
                          roomId: roomIdValue,
                        ),
                      ),
                    );
                  },
                  child: Text("생성"),
                )
              ],
            );
          },
        );

        return roomIdValue;
      } else if (response.statusCode == 409) {
        Map<String, dynamic> responseData = json.decode(response.body);
        int roomIdValue = responseData['id'];
        return roomIdValue;
      } else {
        return -1;
      }
    } catch (error) {
      print('Error during chat room creation: $error');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("에러 발생"),
            content: Text("채팅방 생성 중 오류가 발생했습니다."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );
      return -1;
    }
  }

  void _showCreateChatRoom(BuildContext context, int index) async {
    int roomIdValue = await createChatRoom(index);
    Navigator.of(context).pop(); // 다이얼로그 닫기
    if (roomIdValue != -1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IndividualPage(
            user1: widget.loginId,
            user2: friendList[index].friendId,
            roomId: roomIdValue,
          ),
        ),
      );
    } else {
      print("채팅방 생성에 실패했습니다.");
    }
  }
}
