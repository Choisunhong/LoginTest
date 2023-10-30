import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/Pages/ChatroomList.dart';

import '../Member/Member.dart';
import '../Pages/FriendList.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.mainloginMember}) : super(key: key);
  final Member mainloginMember;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  void addFriend() async {
    final response = await http.post(
      Uri.parse(
          'http://localhost:8080/friend/follow/${widget.mainloginMember.userName}'),
      body: {
        'userName': widget.mainloginMember.userName,
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 친구를 추가한 경우
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
    } else if (response.statusCode == 409) {
      // 이미 친구인 경우
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
      // 그 외의 오류
      print('오류 발생: ${response.statusCode}');
    }
  }

  Widget build(BuildContext context) {
    final loginMember = widget.mainloginMember;
    return Scaffold(
      appBar: AppBar(
        //앱바 수정상황
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffD3D3D3),
        title: SizedBox(
          child: Image.asset(
            "assets/textlogo.png",
            width: 140,
            height: 20,
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext contesxt) {
              // 앱바 세부사항
              return [
                PopupMenuItem(
                  child: Text("Settings"),
                  value: "Settings",
                ),
              ];
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child: TabBarView(
          controller: _controller,
          children: [
            FriendList(loginId: loginMember.id),
            ChatroomList(loginId: loginMember.id),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ID: ${loginMember.id}'),
                  Text('Name: ${loginMember.userName}'),
                  Text('Password: ${loginMember.userPw}'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _controller,
            indicatorColor: const Color(0xFF51C878),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  color: const Color(0xFF51C878),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.chat,
                  color: const Color(0xFF51C878),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.settings,
                  color: const Color(0xFF51C878),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: const Color(0xFF51C878),
            ),
            onPressed: addFriend,
          ),
        ],
      ),
    );
  }
}
