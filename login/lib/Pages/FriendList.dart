import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Member/MemberDTO.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key, required this.loginId}) : super(key: key);
  final int loginId;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<MemberDTO> friendList = []; // 친구 목록을 저장할 리스트

  @override
  void initState() {
    super.initState();
    fetchFriends(); // initState에서 친구 목록을 불러옴
  }

  void fetchFriends() async {
    final response = await http.get(
        Uri.parse('http://localhost:8080/user/${widget.loginId}/findFriends'));

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<MemberDTO> friends =
          responseData.map((data) => MemberDTO.fromJson(data)).toList();

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
                onTap: () {},
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
}
