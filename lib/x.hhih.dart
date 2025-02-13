import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _thoughtsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now()); // Set today's date
  }

  // Format Date Function
  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  // Pick Date Function
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

  // Save Entry to SharedPreferences (without overwriting)
  Future<void> _saveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Load existing entries safely
      String? savedData = prefs.getString('entries');
      List<Map<String, String>> entries = [];

      if (savedData != null && savedData.isNotEmpty) {
        try {
          List<dynamic> decodedData = jsonDecode(savedData);
          entries = decodedData.map((e) => Map<String, String>.from(e)).toList();
        } catch (e) {
          print("Error decoding JSON: $e");
          entries = []; // Reset entries if decoding fails
        }
      }

      // Check if input fields are empty
      if (_titleController.text.trim().isEmpty || _thoughtsController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Title and Thoughts cannot be empty!")),
        );
        return;
      }

      // Create a new entry
      Map<String, String> newEntry = {
        'title': _titleController.text.trim(),
        'date': _dateController.text.trim(),
        'thoughts': _thoughtsController.text.trim(),
      };

      // Add new entry to the list
      entries.add(newEntry);

      // Save updated list
      await prefs.setString('entries', jsonEncode(entries));

      print("Saved data successfully: ${jsonEncode(entries)}");

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved Successfully!")),
      );

      // Go back to HomePage (refresh automatically)
      Navigator.pop(context, true);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        title: Text("Add Diary Entry", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Set a Title",
                  filled: true,
                  fillColor: Colors.pink[50],
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 15),

              // Date Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Thoughts Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: 50,
                  child: TextField(
                    controller: _thoughtsController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Type your Thoughts",
                      filled: true,
                      fillColor: Colors.pink[50],
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: _saveData,
                  child: Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}