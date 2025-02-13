import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🔹 Function to Show Custom Dialog for Username, Email, or Password Update
void showCustomDialog(BuildContext context, String title, String field, Function() refreshUI) {
  TextEditingController textController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPassword = field == "password";

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(title),
            content: isPassword
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPasswordField("New Password", newPasswordController, _obscureNew, (value) {
                  setState(() {
                    _obscureNew = value;
                  });
                }),
                SizedBox(height: 10),
                _buildPasswordField("Confirm Password", confirmPasswordController, _obscureConfirm, (value) {
                  setState(() {
                    _obscureConfirm = value;
                  });
                }),
              ],
            )
                : TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "Enter new $field",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(fontSize: 12)),
              ),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? loggedInUser = prefs.getString('loggedInUser');

                  if (loggedInUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("No user logged in!"),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }

                  String? userDataJson = prefs.getString('user_$loggedInUser');
                  if (userDataJson == null || userDataJson.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("User data not found!"),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }

                  Map<String, dynamic> userData = jsonDecode(userDataJson);

                  if (isPassword) {
                    String newPassword = newPasswordController.text;
                    String confirmPassword = confirmPasswordController.text;

                    if (newPassword.isEmpty || confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please enter both fields"),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }

                    if (newPassword != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Passwords do not match"),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }

                    userData['password'] = newPassword;
                  } else {
                    String newValue = textController.text.trim();
                    if (newValue.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please enter a valid $field"),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }
                    userData[field] = newValue;
                  }

                  await prefs.setString('user_$loggedInUser', jsonEncode(userData));

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$field updated successfully"),
                    backgroundColor: Colors.green,
                  ));

                  refreshUI(); // ✅ Refresh UI after update
                },
                child: Text("Update", style: TextStyle(fontSize: 12)),
              ),
            ],
          );
        },
      );
    },
  );
}

// 🔹 Custom Password Field with Toggle
Widget _buildPasswordField(String hint, TextEditingController controller, bool obscure, Function(bool) onToggle) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          onToggle(!obscure);
        },
      ),
    ),
  );
}
