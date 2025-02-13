import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool isDeleted = false; // State to track if delete is requested

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Account"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Delete Account",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "• Your email will be permanently deleted.\n"
                    "• All your memories on the app will be removed.\n"
                    "• Your username will be erased from our database.\n"
                    "• This action cannot be undone.\n"
                    "• You have 15 days to cancel this request if you change your mind.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // ✅ Dynamic Button (Changes to "Cancel" After Deletion Request)
              Container(
                width: 226,
                height: 39,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDeleted ? Colors.red : Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (isDeleted) {
                      // Reset back to delete account
                      setState(() {
                        isDeleted = false;
                      });
                    } else {
                      _showDeleteConfirmation(context);
                    }
                  },
                  child: Text(
                    isDeleted ? "Cancel" : "Delete Account", // Dynamic button text
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              // ✅ "15 Days Left" Text (Only Shows After Delete Is Pressed)
              if (isDeleted) ...[
                SizedBox(height: 10),
                Text(
                  "15 days left",
                  style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete your account permanently?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  isDeleted = true; // Change button to "Cancel" & show "15 days left"
                });
                Navigator.pop(context); // Close dialog
              },
              child: Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
