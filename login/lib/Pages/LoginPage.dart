import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Member/Member.dart';
import '../Screens/MainScreen.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPwController = TextEditingController();

  void loginUser(BuildContext context) async {
    String userName = userNameController.text;
    String userPw = userPwController.text;

    if (userName.isEmpty || userPw.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('에러'),
            content: Text('사용자 이름과 비밀번호를 모두 입력해주세요.'),
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
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:8080/user/login'),
      body: {
        'userName': userName,
        'userPw': userPw,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Member loginMember = Member.fromJson(responseData);//로그인 된 멤버 의 정보를 담는 객체에 정보 넣기

      
      //int memberId = loginMemeber.id; 이런식으로 데이터사용
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('성공'),
            content: Text('로그인이 완료되었습니다!'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainScreen(mainloginMember: loginMember)), // MainScreen으로 이동
                  ); // MainScreen으로 돌아가기
                },
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 401) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('에러'),
            content: Text('로그인에 실패했습니다.'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // 닫기
                },
              ),
            ],
          );
        },
      );
    } else {
      print('오류 발생: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.lightGreen, title: Text('로그인')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              
              controller: userNameController,
              decoration: InputDecoration(
                labelText: '아이디',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12.0),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: userPwController,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12.0),
              ),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightGreen),
              ),
              onPressed: () {
                loginUser(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
