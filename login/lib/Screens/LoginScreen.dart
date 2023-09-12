import 'package:flutter/material.dart';

import '../Pages/LoginPage.dart';
import '../Pages/RegisterPage.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Container(
          height: 100,
        ),
        Image.asset(
          "assets/logowithText.png",
          width: 200,
          height: 200,
        ),
         Container(
          height: 100,
        ),
        Container(
          width: 280, 
          height: 40,
          child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.lightGreen),
                
                ),
            
          child: Text('로그인'),
        ),
        ),
        Container(
          height: 10,
        ),
        Container(
          width: 280, 
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.black), // 검은색
            ),
            child: Text('회원가입'),
          ),
        )
      ],
    );
  }
}
