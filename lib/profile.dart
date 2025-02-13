import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/widgets/custom_dialog.dart';
import 'add.dart';
import 'homepage_empty.dart';
import 'widgets/gradient_text.dart';
import 'widgets/custom_button.dart';
import 'delete_account.dart';
import 'login.dart'; // Import MyHomePage
import 'widgets/bottom_nave.dart'; // Import Bottom Navigation

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = "Loading...";
  String _email = "Loading...";
  int _selectedIndex = 2; // Profile tab index

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get logged-in user's username
    String? loggedInUsername = prefs.getString('loggedInUser');
    if (loggedInUsername == null) {
      setState(() {
        _username = "No User";
        _email = "No Email";
      });
      return;
    }

    // Fetch user details from SharedPreferences
    String? userDataJson = prefs.getString('user_$loggedInUsername');
    if (userDataJson != null && userDataJson.isNotEmpty) {
      Map<String, dynamic> userData = jsonDecode(userDataJson);
      setState(() {
        _username = userData['username'] ?? "Unknown";
        _email = userData['email'] ?? "Unknown";
      });
    } else {
      setState(() {
        _username = "No Data";
        _email = "No Data";
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(initialIndex: 0)),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddPage()),
      );
    } else if (index == 2) {
      // Stay on profile page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GradientText(
                  text: "Memories Recorder",
                  fontSize: 20,
                  gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
                ),
                SizedBox(height: 30),
                Container(
                  width: 150,
                  height: 150,
                  child: Image.asset('lib/assets/img.png'),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      _username,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      _email,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Container(
                  width: 226,
                  height: 50,
                  child: CustomButton(
                    text: "Update Username",
                    onPressed: () {
                      showCustomDialog(context, "Update Username", "username", _loadUserData);
                    },
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  width: 226,
                  height: 50,
                  child: CustomButton(
                    text: "Update Email",
                    onPressed: () {
                      showCustomDialog(context, "Update Email", "email", _loadUserData);
                    },
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  width: 226,
                  height: 50,
                  child: CustomButton(
                    text: "Update Password",
                    onPressed: () {
                      showCustomDialog(context, "Update Password", "password", _loadUserData);

                    },
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  width: 226,
                  height: 50,
                  child: CustomButton(
                    text: "Delete Account",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeleteAccountScreen()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  width: 226,
                  height: 50,
                  child: CustomButton(
                    text: "Logout",
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.remove('loggedInUser'); // Remove login session

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(title: 'Diary App'),
                        ),
                            (route) => false, // Removes all previous routes
                      );
                    },
                  ),
                ),

                SizedBox(height: 30),
                Text(
                  "Read",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Terms and Conditions",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: " and ",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
