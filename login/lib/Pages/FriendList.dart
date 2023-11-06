import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:login/Pages/PersonalPage.dart';

import '../DTO/FriendListResponse.dart';
import '../Member/Member.dart';
import 'IndividualPage.dart';

class FriendList extends StatefulWidget {
  const FriendList({
    Key? key,
    required this.loginId,
    required this.userName,
  }) : super(key: key);
  final int loginId;
  final String userName;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<FriendListResponse> friendList = [];
  late TextEditingController _friendNameController;
  @override
  void initState() {
    super.initState();
    fetchFriends();
    _friendNameController = TextEditingController();
  }

  Future<void> fetchFriends() async {
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

  void addFriend(String friendName) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/friend/follow/$friendName'),
      body: {
        'id': widget.loginId.toString(),
        'userName': widget.userName,
      },
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('친구 추가 성공'),
            content: Text('친구가 성공적으로 추가되었습니다.'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      fetchFriends();
    } else if (response.statusCode == 409) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('친구 추가 실패'),
            content: Text('이미 친구입니다.'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('친구 추가 실패'),
            content: Text('존재하지 않은 회원입니다.'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print('오류 발생: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchFriends,
      child: Scaffold(
        body: ListView.builder(
          itemCount: friendList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _showCreateChatRoom(context, index);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFB1EEB3),
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  title: Text(
                    friendList[index].friendName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: const Color(0xFF51C878),
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              child: Image.asset('assets/logo.png', width: 40, height: 40),
              label: '친구 추가',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('친구 추가'),
                      content: TextField(
                        controller: _friendNameController,
                        decoration: InputDecoration(labelText: '친구 이름'),
                      ),
                      actions: [
                        TextButton(
                          child: Text('추가'),
                          onPressed: () {
                            String friendName = _friendNameController.text;
                            addFriend(friendName);
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('취소'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
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
