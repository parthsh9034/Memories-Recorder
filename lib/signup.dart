import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/custom_button.dart';
import 'widgets/gradient_text.dart';
import 'widgets/passwordFields.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool get isPasswordMatch => passwordController.text == confirmPasswordController.text;

  /// **Show an Alert Dialog for Errors**
  void showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  /// **Sign-Up Function**
  Future<void> signUp() async {
    if (emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showAlert("Empty Fields", "All fields are required. Please fill them out.");
      return;
    }

    if (!isPasswordMatch) {
      showAlert("Password Mismatch", "Passwords do not match. Please try again.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    // **Check if Username Already Exists**
    List<String> usersList = prefs.getStringList('users') ?? [];
    if (usersList.contains(usernameController.text)) {
      showAlert("Username Taken", "This username is already in use. Please choose another.");
      return;
    }

    // **Store User Data**
    Map<String, String> userData = {
      'email': emailController.text,
      'username': usernameController.text,
      'password': passwordController.text, // Password is stored as plain text
    };

    await prefs.setString('user_${usernameController.text}', jsonEncode(userData));

    // **Add Username to List of Users**
    usersList.add(usernameController.text);
    await prefs.setStringList('users', usersList);

    // **Save the Logged-In User**
    await prefs.setString('loggedInUser', usernameController.text);

    print("User Registered: ${jsonEncode(userData)}");

    // **Show Success Message & Redirect to Login**
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Account created successfully! Redirecting to Login..."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: "Diary")), // Redirect to Login
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Center(
        child: Align(
          alignment: Alignment(0, -0.4),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  GradientText(
                    text: "Memories",
                    fontSize: 55,
                    gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
                  ),
                  GradientText(
                    text: "Recorder",
                    fontSize: 45,
                    gradient: LinearGradient(colors: [Colors.blue, Colors.black]),
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
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        fillColor: Color(0xFFFFEDED),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(Icons.person),
                        hintText: "Enter Your Username",
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        PasswordFields(
                          hintText: "Enter Your Password",
                          controller: passwordController,
                        ),
                        SizedBox(height: 10),
                        PasswordFields(
                          hintText: "Confirm Your Password",
                          controller: confirmPasswordController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 17),
                  SizedBox(
                    width: 350,
                    child: CustomButton(
                      text: "Sign Up",
                      onPressed: signUp,
                    ),
                  ),
                  SizedBox(height: 17),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage(title: "Diary")), // Redirect to Login
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
