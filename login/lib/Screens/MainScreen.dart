import 'package:flutter/material.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(//앱바 수정상황
        backgroundColor:const Color(0xFF39E64F),
        title: Text("TeenTalk"),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext contesxt) {// 앱바 세부사항
              return [
                PopupMenuItem(
                  child: Text("New group"),
                  value: "New group",
                ),
                PopupMenuItem(
                  child: Text("New broadcast"),
                  value: "New broadcast",
                ),
                PopupMenuItem(
                  child: Text("TeenTalk Web"),
                  value: "TeenTalk Web",
                ),
                PopupMenuItem(
                  child: Text("Starred messages"),
                  value: "Starred messages",
                ),
                PopupMenuItem(
                  child: Text("Settings"),
                  value: "Settings",
                ),
              ];
            },
          )
        ],
        
      ),
      body: TabBarView(
        controller:_controller,
        children: [
          Center(child: Text("Tab 1 Content")),
          Center(child: Text("Tab 2 Content")),
          Center(child: Text("Tab 3 Content")),
          Center(child: Text("Tab 4 Content")),
      ],),
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
