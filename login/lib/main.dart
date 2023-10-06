import 'package:flutter/material.dart';
import 'package:login/Screens/LoginScreen.dart';


 void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext  context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF39E64F),
      ),
      home: LoginScreen(),
    );
  }
}
//Color(0xFF39E64F),