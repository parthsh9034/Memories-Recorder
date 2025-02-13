import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'profile.dart';
import 'widgets/bottom_nave.dart';
import 'add.dart';
import 'details_page.dart';
import 'widgets/gradient_text.dart';
import 'widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  HomePage({this.initialIndex = 0});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Map<String, String>> _savedEntries = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInUser = prefs.getString('loggedInUser');
    if (loggedInUser == null) return;

    String key = 'entries_$loggedInUser';
    String? savedData = prefs.getString(key);

    if (savedData != null && savedData.isNotEmpty) {
      try {
        List<dynamic> decodedData = jsonDecode(savedData);
        List<Map<String, String>> newEntries = decodedData.map((e) => Map<String, String>.from(e)).toList();

        setState(() {
          _savedEntries = newEntries;
        });
      } catch (e) {
        print("Error decoding saved data: $e");
      }
    } else {
      setState(() {
        _savedEntries = [];
      });
    }
  }

  Future<void> _navigateToAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPage()),
    );

    if (result == true) {
      await _loadSavedData();
    }
  }

  Future<void> _deleteEntry(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInUser = prefs.getString('loggedInUser');
    if (loggedInUser == null) return;

    String key = 'entries_$loggedInUser';
    _savedEntries.removeAt(index);
    await prefs.setString(key, jsonEncode(_savedEntries));

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Entry deleted successfully!")),
    );
  }

  Widget _buildHomeScreenContent() {
    if (_savedEntries.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            GradientText(
              text: "Memories Recorder",
              fontSize: 20,
              gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
            ),
            SizedBox(height: 100),
            Container(
              width: 249,
              height: 249,
              child: Image.asset('lib/assets/ph.png'),
            ),
            SizedBox(height: 20),
            Text(
              "Create your first Memory",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: CustomButton(
                text: "Create",
                color: Colors.white,
                textColor: Colors.black,
                onPressed: _navigateToAddPage,
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 40),
          GradientText(
            text: "Memories Recorder",
            fontSize: 20,
            gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _savedEntries.length,
              itemBuilder: (context, index) {
                final entry = _savedEntries[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          title: entry['title'] ?? "No Title",
                          date: entry['date'] ?? "No Date",
                          thoughts: entry['thoughts'] ?? "No Thoughts",
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        title: Text(
                          entry['title'] ?? "",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry['date'] ?? "",
                              style: TextStyle(fontSize: 11.70, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 4),
                            Text(
                              entry['thoughts'] ?? "",
                              style: TextStyle(fontSize: 11.50),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteEntry(index),
                        ),
                      ),
                    ),
                  ),
                );

              },
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHomeScreenContent(),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            setState(() {
              _selectedIndex = 0;
            });
          } else if (index == 1) {
            _navigateToAddPage();
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
      ),
    );
  }
}