import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPwController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('로그인')),
      body:Padding(
        padding: EdgeInsets.all(16.0),
            child:  Column(
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
                SizedBox(height: 32.0), 
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightGreen),
                  ),
                  onPressed: () {
                    
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