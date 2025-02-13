import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/widgets/passwordFields.dart';
import 'forget_pass.dart';
import 'widgets/custom_button.dart';
import 'widgets/gradient_text.dart';
import 'signup.dart';
import 'homepage_empty.dart'; // Assuming this is your HomePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFFEDED)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Diary App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    String enteredEmail = emailController.text.trim();
    String enteredPassword = passwordController.text.trim();

    List<String> usersList = prefs.getStringList('users') ?? [];

    for (String username in usersList) {
      String? userDataJson = prefs.getString('user_$username');

      if (userDataJson != null && userDataJson.isNotEmpty) {
        try {
          Map<String, dynamic> userData = jsonDecode(userDataJson);

          if (userData.containsKey('email') && userData.containsKey('password')) {
            if (enteredEmail == userData['email'] && enteredPassword == userData['password']) {
              // Store logged-in user
              await prefs.setString('loggedInUser', username);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              return; // Exit after successful login
            }
          }
        } catch (e) {
          print("Error decoding user data for $username: $e");
        }
      }
    }

    // Show error if no match found
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invalid Credentials'),
        content: Text('The email or password you entered is incorrect.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment(0, -0.4),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GradientText(
                      text: "Memories",
                      fontSize: 55,
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                    ),
                    GradientText(
                      text: "Recorder",
                      fontSize: 45,
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.black],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      fillColor: Color(0xFFFFEDED),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      prefixIcon: Icon(Icons.email),
                      hintText: "Enter Your Email",
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      PasswordFields(
                        hintText: "Enter Your Password",
                        controller: passwordController,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPassPage()),
                        );
                      },
                      child: Text(
                        "Forget Pass",
                        style: TextStyle(
                            fontSize: 14, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 350,
                  child: CustomButton(
                    text: "Sign In",
                    onPressed: _login,
                  ),
                ),
                SizedBox(height: 17),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
