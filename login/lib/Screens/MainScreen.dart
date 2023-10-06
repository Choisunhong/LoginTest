import 'package:flutter/material.dart';
import 'package:login/Pages/ChatroomList.dart';

import '../Member/Member.dart';
import '../Pages/FriendList.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.mainloginMember}) : super(key: key);
  final Member mainloginMember;
  @override
   _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{
  late TabController _controller;
  @override
  void initState(){

    super.initState();
    _controller=TabController(length: 4, vsync: this,initialIndex: 0);
  }
  Widget build(BuildContext context) {
    final loginMember = widget.mainloginMember;
    return Scaffold(
      appBar: AppBar(//앱바 수정상황
        automaticallyImplyLeading: false,
        backgroundColor:Color(0xffD3D3D3),
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
            itemBuilder: (BuildContext contesxt) {// 앱바 세부사항
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
      Center(child: Text("Tab 4 Content")),
    ],
  ),
),
       bottomNavigationBar: TabBar(
          controller: _controller,
          indicatorColor: Colors.black,
          tabs: [
            Tab(text: "친구목록"),
            Tab(text: "채팅"),
            Tab(text: "마이페이지"),
            Tab(text: "설정"),
          ],
        ),
    );
  }
}
