import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/Pages/ChatroomList.dart';
import 'package:login/Pages/PersonalPage.dart';

import '../Member/Member.dart';
import '../Pages/FriendList.dart';
import '../Pages/PersonalPage.dart';


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

  

  @override
  Widget build(BuildContext context) {
    final loginMember = widget.mainloginMember;
    return Scaffold(
      appBar: AppBar(
        // 앱바 수정상황
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 177, 238, 179),
        title: SizedBox(
          child: Image.asset(
            "assets/textlogo.png",
            width: 210,
            height: 30,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child: TabBarView(
          controller: _controller,
          children: [
            FriendList(
              loginId: loginMember.id,
              userName: loginMember.userName,
            ),
            ChatroomList(loginId: loginMember.id),
            PersonalPage(
              loginId: loginMember.id,
              userName: loginMember.userName,
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
        ],
      ),
    );
  }
}
