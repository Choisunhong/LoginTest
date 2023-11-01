import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPwController = TextEditingController();

  void registerUser(BuildContext context) async {
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
      Uri.parse('http://localhost:8080/user/signup'),
      body: {
        'userName': userName,
        'userPw': userPw,
      },
    );
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('성공'),
            content: Text('회원가입이 완료되었습니다!'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // 닫기
                  Navigator.of(context).pop(); // 이전 화면으로 돌아가기
                },
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 409) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('에러'),
            content: Text('이미 회원가입이 된 아이디입니다.'),
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
      appBar: AppBar(backgroundColor: const Color(0xFF708333), title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userNameController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12.0),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: userPwController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12.0),
              ),
              obscureText: true,
            ),
            SizedBox(height: 32.0), // 공간 추가
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF708333)),
              ),
              onPressed: () {
                registerUser(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Sign Up',
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
