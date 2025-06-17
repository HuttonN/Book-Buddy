import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:book_buddy/screens/home/home_page_screen.dart';
import 'dart:io';

// Scan book for adding a book to a users library or TBR
class ScanBookAdding extends StatefulWidget {
  final String imagePath;
  final String initialTitle;
  final String initialAuthor;
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;
  final String uid;


  const ScanBookAdding({
    super.key, 
    required this.imagePath,
    required this.initialTitle,
    required this.initialAuthor,
    required this.isDarkMode,
    required this.toggleDarkMode,
    required this.uid,
  });

  @override
  _ScanBookAddingState createState() => _ScanBookAddingState();
}

// State class for the book adding screen
class _ScanBookAddingState extends State<ScanBookAdding> {
  late bool _isDarkMode;
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  final TextEditingController _isbnController = TextEditingController();
  String? _aiReview;
  bool _isSaving = false;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    // Initialise controllers with scanned data
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

  Future<String> _uploadImageToFirebase(String filePath) async {
    File file = File(filePath);
    String fileName = 'book_covers/${DateTime.now()}.jpg';
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot snapshot = await uploadTask.whenComplete(()=>{});
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  // Save book to Firestore with the specified read status
  Future<void> _saveBook(bool hasRead) async {
    if (
      _titleController.text.isEmpty || _authorController.text.isEmpty
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: 
            Text("Title and author are required!")
          ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      User? user = _auth.currentUser;

      String downloadUrl = await _uploadImageToFirebase(widget.imagePath);

      // Save to Firestore
      if (user != null) {
        await FirebaseFirestore.instance
          .collection('usersCollection')
          .where('uid', isEqualTo: widget.uid)
          .get()
          .then((snapshot) async {
            final userDoc = snapshot.docs.first;
            await userDoc.reference
              .collection("Books")
              .add({'Author': _authorController.text,
                  'Title': _titleController.text,
                  'has_read': hasRead,
                  'image_url': downloadUrl,
              });

          if (hasRead) {
            await userDoc.reference.update({
              "Books Read":FieldValue.increment(1),
            });
          }
        });
        
        // Shows success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: 
              Text("Book saved successfully!")
            ),
        );
        
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageScreen(
            isDarkMode: _isDarkMode, 
            toggleDarkMode: widget.toggleDarkMode,
          ),
        ),
      );
      } else {
        ScaffoldMessenger.of(
          context).showSnackBar(
          SnackBar(
            content: 
              Text("User not logged in!")
            ),
        );
      }
    } catch (e) {
      // Shows error message
      ScaffoldMessenger.of(
        context).showSnackBar(
        SnackBar(
          content: 
            Text("Error saving book: ${e.toString()}"
            )
          ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Generate an AI review for the scanned book
  Future<void> _generateAIReview() async {
    try {
      // Initialise AI model
      final model = GenerativeModel(
        model: 'gemini-2.0-flash', 
        apiKey: 'AIzaSyCElfNpjFeYtMAhK1KqLg14VyMOEhGq_oA'
        ); 
      final prompt = "Write a 80-word review for the book '${_titleController.text}' by ${_authorController.text}";
      final response = await model.generateContent(
        [Content.text(prompt)]
     );
      setState(() {
        _aiReview = response.text;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context).showSnackBar(
        SnackBar(
          // Error message
          content: 
            Text("Error generating review: ${e.toString()}"
          )
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custome app bar
      appBar: 
      PreferredSize(
        preferredSize: Size.fromHeight(35), 
      child: 
      AppBar(
        backgroundColor: _isDarkMode 
          ? Color.fromARGB(255, 20, 9, 45) 
          : Color.fromARGB(255, 223, 245, 252),
        elevation: 5 ,
        iconTheme: 
          IconThemeData(
            color: _isDarkMode 
              ? Colors.white 
              : Color.fromARGB(255, 20, 9, 45)
            ),
          )
        ),
      
      backgroundColor: _isDarkMode 
        ? Color.fromARGB(255, 20, 9, 45) 
        : Color.fromARGB(255, 216, 243, 245),
      body: 
      SingleChildScrollView(
        padding: 
          const EdgeInsets.all(16.0),
        child: 
        Column(
          crossAxisAlignment: 
            CrossAxisAlignment.stretch,
          children: [
            // Display scanned book image
            Container(
              height: 200,
              decoration: 
              BoxDecoration(
                borderRadius: 
                  BorderRadius.circular(8),
                image: 
                DecorationImage(
                  image: 
                    FileImage(
                      File(
                        widget.imagePath
                      )
                    ),
                  fit: 
                    BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 20
            ),
            // Book title input field
            TextField(
              controller: _titleController,
              decoration: 
              InputDecoration(
                labelText: "Book Title",
                labelStyle: 
                  TextStyle(
                    color: _isDarkMode 
                      ? Colors.white 
                      : Colors.black
                    ),
                border: 
                  OutlineInputBorder(),
                fillColor: _isDarkMode 
                  ? Colors.grey
                  : Colors.white,
                filled: true
              ),
              style: TextStyle(
                color: _isDarkMode 
                  ? Colors.white 
                  : Colors.black,
              )
            ),
            SizedBox(
              height: 16
            ),
            // Author input field
            TextField(
              controller: _authorController,
              decoration: 
              InputDecoration(
                labelText: "Author",
                labelStyle: 
                  TextStyle(
                    color: _isDarkMode 
                      ? Colors.white 
                      : Colors.black
                    ),
                border: 
                  OutlineInputBorder(),
                fillColor: _isDarkMode 
                  ? Colors.grey
                  : Colors.white,
                filled: true
              ),
              style: TextStyle(
                color: _isDarkMode 
                  ? Colors.white 
                  : Colors.black,
              )
            ),

            SizedBox(
              height: 16
            ),
            // ISBN input field
            TextField(
              controller: _isbnController,
              decoration: 
              InputDecoration(
                labelText: "ISBN (optional)",
                labelStyle: 
                  TextStyle(
                    color: _isDarkMode 
                      ? Colors.white 
                      : Colors.black
                    ),
                border: 
                  OutlineInputBorder(),
                fillColor: _isDarkMode 
                  ? Colors.grey
                  : Colors.white,
                filled: true
              ),
              keyboardType: 
                TextInputType.number,
            ),
            SizedBox(
              height: 24
            ),
            
            // Button to add book to library
            ElevatedButton.icon(
              onPressed: _isSaving 
                ? null 
                : () => _saveBook(true),
              icon: 
                Icon(
                  Icons.library_books, 
                  color: _isDarkMode 
                    ? Colors.black 
                    : Colors.white
                  ),
              label: 
                Text(_isSaving 
                  ? "Saving..." : "Add to Library", 
                  style: 
                    TextStyle(
                      color: _isDarkMode 
                        ? Colors.black 
                        : Colors.white
                      )
                    ),
              style: 
              ElevatedButton.styleFrom(
                padding: 
                EdgeInsets.symmetric(
                  vertical: 16
                ),
                backgroundColor: _isDarkMode 
                  ? Colors.white 
                  : Colors.black
              ),
            ),
            SizedBox(
              height: 12
            ),

            // Button to add book to TBR
            ElevatedButton.icon(
              onPressed: _isSaving 
                ? null 
                : () => _saveBook(false),
              icon: 
                Icon(
                  Icons.bookmark, 
                  color: _isDarkMode 
                    ? Colors.black 
                    : Colors.white
                  ),
              label: 
                Text(_isSaving 
                  ? "Saving..." : "Add to TBR", 
                  style: 
                    TextStyle(
                      color: _isDarkMode 
                        ? Colors.black 
                        : Colors.white
                      )
                    ),
              style: 
              ElevatedButton.styleFrom(
                padding: 
                EdgeInsets.symmetric(
                  vertical: 16
                ),
                backgroundColor: _isDarkMode 
                  ? Colors.white 
                  : Colors.black
              ),
            ),
            SizedBox(
              height: 24
            ),
            // Button to generate AI review
            Divider(),
            SizedBox(
              height: 16
            ),
            ElevatedButton(
            onPressed: 
              _generateAIReview,
            style: 
            ElevatedButton.styleFrom(
              backgroundColor: _isDarkMode 
                ? Colors.white 
                : Colors.black, // Background color of the button
              ),
            child: 
              Text("Generate AI Review", 
                style: 
                TextStyle(
                  color: _isDarkMode 
                    ? Colors.black 
                    : Colors.white
                  )
                ),
              ),
            if (_aiReview != null)
              Padding(
                padding: 
                  const EdgeInsets.only(
                    top: 16.0
                  ),
                child: Card(
                  child: Padding(
                    padding: 
                      const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: 
                        CrossAxisAlignment.start,
                      children: [
                        Text("AI Review:", 
                        style: 
                          TextStyle(
                            fontWeight: 
                              FontWeight.bold
                            )
                          ),
                        SizedBox(
                          height: 8
                        ),
                        Text(
                          _aiReview!
                        ),
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