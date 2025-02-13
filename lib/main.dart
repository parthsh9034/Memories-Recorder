import 'package:flutter/material.dart';
import 'login.dart';  // Import the login.dart file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),  // Call the LoginPage widget from login.dart
    );
  }
}