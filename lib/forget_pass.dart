import 'package:flutter/material.dart';
import 'package:untitled3/login.dart';
import 'widgets/gradient_text.dart';
import 'widgets/custom_button.dart';
import 'forgetpasssent.dart';

class ForgetPassPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Container(
                  width: 166,
                  height: 22,
                  child: Text(
                    "FORGET PASSWORD?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
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
                  width: 358,
                  height: 54,
                  child: CustomButton(
                    text: "Submit",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Forgetpasssent()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 358,
                  height: 54,
                  child: CustomButton(
                    text: "Back",
                    color: Colors.white,
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Diary App')),
                      );
                    },
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
