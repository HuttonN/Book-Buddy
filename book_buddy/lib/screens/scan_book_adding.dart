import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanBookAdding extends StatefulWidget {
  final String imagePath;

  const ScanBookAdding({super.key, required this.imagePath});

  @override
  _ScanBookAddingState createState() => _ScanBookAddingState();
}

class _ScanBookAddingState extends State<ScanBookAdding> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  String? _aiReview;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveBook() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).collection('books').add({
        'title': _titleController.text,
        'author': _authorController.text,
        'isbn': _isbnController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Book saved successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in!")),
      );
    }
  }

  Future<void> _generateAIReview() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: 'YOUR_API_KEY');
    final prompt = "Write a review for the book '${_titleController.text}' by ${_authorController.text}";
    final response = await model.generateContent([Content.text(prompt)]);
    setState(() {
      _aiReview = response.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Book")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Book Title"),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: "Author"),
            ),
            TextField(
              controller: _isbnController,
              decoration: InputDecoration(labelText: "ISBN"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBook,
              child: Text("Add Book to Library"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateAIReview,
              child: Text("Click to generate AI review"),
            ),
            if (_aiReview != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(_aiReview!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
