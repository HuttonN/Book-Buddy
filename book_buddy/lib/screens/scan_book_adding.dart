import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ScanBookAdding extends StatefulWidget {
  final String imagePath;
  final String initialTitle;
  final String initialAuthor;

  const ScanBookAdding({
    super.key, 
    required this.imagePath,
    required this.initialTitle,
    required this.initialAuthor,
  });

  @override
  _ScanBookAddingState createState() => _ScanBookAddingState();
}

class _ScanBookAddingState extends State<ScanBookAdding> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  final TextEditingController _isbnController = TextEditingController();
  String? _aiReview;
  bool _isSaving = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _authorController = TextEditingController(text: widget.initialAuthor);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    super.dispose();
  }

  Future<void> _saveBook(String collectionName) async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and author are required!")),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).collection(collectionName).add({
          'title': _titleController.text,
          'author': _authorController.text,
          'isbn': _isbnController.text,
          'coverImage': widget.imagePath,
          'timestamp': FieldValue.serverTimestamp(),
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Book saved to $collectionName successfully!")),
        );
        
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not logged in!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving book: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _generateAIReview() async {
    try {
      final model = GenerativeModel(model: 'gemini-pro', apiKey: 'AIzaSyCElfNpjFeYtMAhK1KqLg14VyMOEhGq_oA');
      final prompt = "Write a review for the book '${_titleController.text}' by ${_authorController.text}";
      final response = await model.generateContent([Content.text(prompt)]);
      setState(() {
        _aiReview = response.text;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error generating review: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Book"),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () {
              // You could add functionality to select from gallery here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Book Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: "Author",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _isbnController,
              decoration: InputDecoration(
                labelText: "ISBN (optional)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            
            ElevatedButton.icon(
              onPressed: _isSaving ? null : () => _saveBook('library'),
              icon: Icon(Icons.library_books),
              label: Text(_isSaving ? "Saving..." : "Add to Library"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : () => _saveBook('tbr'),
              icon: Icon(Icons.bookmark),
              label: Text(_isSaving ? "Saving..." : "Add to TBR"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateAIReview,
              child: Text("Generate AI Review"),
            ),
            if (_aiReview != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("AI Review:", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(_aiReview!),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}