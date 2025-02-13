import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'widgets/custom_button.dart';
import 'package:untitled3/homepage_empty.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _thoughtsController = TextEditingController();
  String? loggedInUser; // To store the current user's username

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now()); // Set today's date
    _loadLoggedInUser(); // Load the logged-in user
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _thoughtsController.dispose();
    super.dispose();
  }

  // **Load Logged-In User**
  Future<void> _loadLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUser = prefs.getString('loggedInUser'); // Retrieve username
    });
  }

  // **Format Date Function**
  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  // **Pick Date Function**
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = _formatDate(picked);
      });
    }
  }

  // **Save Entry to SharedPreferences**
  // **Save Entry to SharedPreferences**
  Future<void> _saveData() async {
    if (loggedInUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: No user logged in!")),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String key = 'entries_$loggedInUser'; // Store data per user

      // Load existing entries
      String? savedData = prefs.getString(key);
      List<Map<String, String>> entries = [];

      if (savedData != null && savedData.isNotEmpty) {
        try {
          List<dynamic> decodedData = jsonDecode(savedData);
          entries = decodedData.map((e) => Map<String, String>.from(e)).toList();
        } catch (e) {
          print("Error decoding JSON: $e");
          entries = []; // Reset entries if there's an error
        }
      }

      // **Check if input fields are empty**
      if (_titleController.text.trim().isEmpty || _thoughtsController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Title and Thoughts cannot be empty!")),
        );
        return;
      }

      // **Ensure date is not empty**
      String date = _dateController.text.trim().isNotEmpty
          ? _dateController.text.trim()
          : DateTime.now().toLocal().toString().split(' ')[0];

      // **Create a new entry**
      Map<String, String> newEntry = {
        'title': _titleController.text.trim(),
        'date': date,
        'thoughts': _thoughtsController.text.trim(),
      };

      // **Add new entry**
      entries.add(newEntry);

      // **Save updated list**
      await prefs.setString(key, jsonEncode(entries));

      print("Saved data successfully for user $loggedInUser: ${jsonEncode(entries)}");

      // **Show confirmation message**
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved Successfully!")),
      );

      // **Navigate directly to HomePage and reset bottom navigation**
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(initialIndex: 0)), // Pass index 0 for home
            (route) => false, // Removes all previous routes
      );

    } catch (e) {
      print("Error saving data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data! Please try again.")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Diary Entry"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
                Navigator.pop(context, false); // Just return false, do not push a new page
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Set A Title",
                  filled: true,
                  fillColor: Colors.pink[50],
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Date",
                filled: true,
                fillColor: Colors.pink[50],
                suffixIcon: Icon(Icons.calendar_month_outlined),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 10),
            Container(
              height: 560,
              child: TextField(
                maxLines: null,  // Allows multiple lines
                expands: true,   // Expands to fill available height
                controller: _thoughtsController,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top, // Aligns text to the top-left
                decoration: InputDecoration(
                  labelText: "Your Thoughts",
                  floatingLabelBehavior: FloatingLabelBehavior.auto, // Moves label when typing
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.pink[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),


            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // 🔹 Adjust this value to control roundness
                ),
              ),
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
