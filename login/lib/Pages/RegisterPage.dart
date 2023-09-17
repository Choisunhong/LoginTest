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
      Uri.parse('http://localhost:8080/user/create'),
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
  } else {
    print('오류 발생: ${response.statusCode}');
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green, title: Text('회원가입')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userNameController,
              decoration: InputDecoration(
                labelText: '사용자 이름',
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
            SizedBox(height: 32.0), // 공간 추가
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightGreen),
              ),
              onPressed: () {
                registerUser(context); 
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  '회원가입',
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
