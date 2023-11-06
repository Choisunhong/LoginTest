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
          width: 300,
          height: 300,
        
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
                MaterialStateProperty.all<Color>(const Color(0xFF51C878)),
                
                ),
            
          child: Text('Login',
           style: TextStyle(fontSize: 17)),
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
                  MaterialStateProperty.all<Color>( const Color(0xFF708333)), 
            ),
            child: Text('Sign Up',
            style: TextStyle(fontSize: 17)),
          ),
        )
      ],
    );
  }
}
