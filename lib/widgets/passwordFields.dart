
import 'package:flutter/material.dart';

class PasswordFields extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  // Custom text input

  PasswordFields({required this.hintText, required this.controller}); // Constructor to accept text

  @override
  _PasswordFieldsState createState() => _PasswordFieldsState();
}

class _PasswordFieldsState extends State<PasswordFields> {
  bool _isObscure = true; // Toggle visibility
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscure,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        fillColor: Color(0xFFFFEDED),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black),
        ),
        prefixIcon: Icon(Icons.lock),
        hintText: widget.hintText, // 👈 Custom text from main file
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure; // Toggle visibility
            });
          },
        ),
      ),
    );
  }
}
