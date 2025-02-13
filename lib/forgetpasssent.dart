import 'package:flutter/material.dart';
import 'widgets/gradient_text.dart';
import 'widgets/custom_button.dart';
import 'login.dart';

class Forgetpasssent extends StatelessWidget {
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
                SizedBox(height: 20), // Adds spacing
                Text(
                  "We sent you an email! \n"
                      "Follow the instructions to \n"
                      "reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 20,),
                Container(
                  width: 204,

                  child: CustomButton(
                      text: "Back to login",
                      color: Colors.white,
                      textColor: Colors.black,
                      onPressed:(){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage(title: 'Diary App')),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
