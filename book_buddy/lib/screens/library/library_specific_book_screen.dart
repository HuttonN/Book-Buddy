import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:book_buddy/screens/library/library_screen.dart';
import 'package:book_buddy/screens/scan/scan_book_screen.dart';
import 'package:book_buddy/screens/settings.dart';
import 'package:book_buddy/screens/home/home_page_screen.dart';
import 'package:book_buddy/screens/tbr/tbr_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

// Screen for viewing a specific book in Library
class Library_specific_book extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;
  final String bookTitle;  
  final String bookAuthor;
  final String imageUrl;
  final String bookId;
  final String uid;

  const Library_specific_book({
    required this.isDarkMode,
    required this.toggleDarkMode,
    required this.bookTitle,  
    required this.bookAuthor,
    required this.imageUrl,
    required this.bookId,
    required this.uid,
    super.key
  });

  @override
  _Library_specific_bookState createState() => _Library_specific_bookState();
}

// Nav bar implementation
class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDarkMode;

  const NavBar({
    super.key, 
    required this.onTap, 
    required this.currentIndex,
    required this.isDarkMode});

 @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode 
          ? Colors.white
          : Colors.black, // Nav bar background colour
        borderRadius: 
          BorderRadius.only(
          topLeft: 
            Radius.circular(20),
          topRight: 
            Radius.circular(20),
        ),
      ),
    
    child: 
      BottomNavigationBar(
        backgroundColor: 
          Colors.transparent, 
        selectedItemColor: 
          Colors.white, 
        unselectedItemColor: 
          Colors.white, 
        showSelectedLabels: 
          false, 
        showUnselectedLabels: 
          false, 
        currentIndex: 
          currentIndex, 
        onTap: 
          onTap, 
        type: 
          BottomNavigationBarType.fixed,  

      items: [
        BottomNavigationBarItem(
          icon: 
          Semantics(
            label: 'Library- book icon',
            hint: 'Press to go to My Library screen',
            child: 
              Icon(
                Icons.menu_book, 
                color: isDarkMode 
                  ? Colors.black
                  : Colors.white,
                ),
          ),
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: 
          Semantics(
            label: 'My TBR- bookmark icon',
            hint: 'Press to go to My TBR screen',
            child: 
              Icon(
                Icons.bookmark, 
                color: isDarkMode 
                  ? Colors.black  
                  : Colors.white,
                )
          ),
          label: "", 
        ),
        
        BottomNavigationBarItem(
            icon: 
            Semantics(
              label: 'Scan book- camera icon',
              hint: 'Press to to go to scan book screen',
              child: 
              Container(
                padding: 
                EdgeInsets.all(8),
                decoration: 
                BoxDecoration(
                  color: isDarkMode
                    ? Colors.white70
                    : Colors.black, 
                  shape: 
                    BoxShape.circle,
                ),
                child: 
                  Icon(
                    Icons.camera_alt,  
                      color: isDarkMode 
                        ? Colors.black
                        : Colors.white,
                      ), 
              ),
            ),
            label: "", 
            ),
            

        BottomNavigationBarItem(
          icon: 
          Semantics(
            label: 'Settings- settings icon',
            hint: 'Press to go to Settings screen', 
            child: 
              Icon(
                Icons.settings, 
                  color: isDarkMode 
                    ? Colors.black
                    : Colors.white,
                  ),
          ), 
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: 
          Semantics(
            label: 'Home- home icon', 
            hint: 'Press to go to the home page screen',
            child: 
              Icon(
                Icons.home, 
                  color: isDarkMode 
                    ? Colors.black
                    : Colors.white,
                  ),
          ),
          label: "", 
        ),
      ],
    ),
    );
  }
}

// State class for the Library specific book page
class _Library_specific_bookState extends State<Library_specific_book> {
  late bool _isDarkMode;
  String _aiReview = "";
  bool _isGeneratingReview = false;
  bool _isSavingNotes = false;

  final TextEditingController _notesController = TextEditingController() ;
  
  // Star rating state
  int _rating = 0; 

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _loadBookData();
  }

  // Loading book data from firestore
  Future<void> _loadBookData() async {
  try {
    final snapshot = await firestore.FirebaseFirestore.instance
        .collection("usersCollection")
        .where("uid", isEqualTo: widget.uid)
        .get();
        
    if (snapshot.docs.isNotEmpty) {
      final userDoc = snapshot.docs.first;
      final bookDoc = await userDoc.reference
          .collection("Books")
          .doc(widget.bookId)
          .get();

      // Checking if the book has a pre-existed rating or 
      // user inputed notes    
      if (bookDoc.exists) {
        setState(() {
          _rating = bookDoc.data()?['Rating'] ?? 0;
          _notesController.text = bookDoc.data()?['User_Notes'] ?? '';
        });
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: 
          Text("Error loading book data: ${e.toString()}")),
      );
    }
  }

  // Saving notes to Firebase
  Future<void> _saveNotes() async {
    setState(() {
      _isSavingNotes = true;
    });
    if(_notesController.text.isNotEmpty){
      try{
        await firestore.FirebaseFirestore.instance
        .collection("usersCollection")
        .where("uid", isEqualTo: widget.uid)
        .get()
        .then((snapshot) async {
          final userDoc = snapshot.docs.first;
          await userDoc.reference
            .collection("Books")
            .doc(widget.bookId)
            .set({'User_Notes':_notesController.text},firestore.SetOptions(merge: true));
        }); 
      } finally {
      setState(() {
        _isSavingNotes = false;
      });
    }
    }
  }

  // Saving rating to Firebase
  Future<void> _saveRating() async {
    try {
    await firestore.FirebaseFirestore.instance
        .collection("usersCollection")
        .where("uid", isEqualTo: widget.uid)
        .get()
        .then((snapshot) async {
      final userDoc = snapshot.docs.first;
      await userDoc.reference
          .collection("Books")
          .doc(widget.bookId)
          .set({'Rating': _rating}, firestore.SetOptions(merge: true));
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: 
          Text("Error saving rating: ${e.toString()}"
        )
      ),
    );
  }
  }
  // Generates AI review for book
  Future<void> generateAIReview() async {  
    setState(() {
      _isGeneratingReview = true;
    });

    try {
      // Initialise AI model
      final model = GenerativeModel(
        model: 'gemini-2.0-flash', 
        apiKey: 'AIzaSyCElfNpjFeYtMAhK1KqLg14VyMOEhGq_oA'
      ); 
      final prompt = "Write a 80-word review for the book '${widget.bookTitle}' by ${widget.bookAuthor}. "
          "Include the genre, main themes, and who might enjoy it.";
      // Get AI response
      final response = await model.generateContent([
        Content.text(prompt)
      ]
    );
      
      setState(() {
        // Error message if generation fails
        _aiReview = response.text 
          ?? "Could not generate review. Please try again.";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: 
            Text("Error generating review: ${e.toString()}"
          )
        ),
      );
      setState(() {
        _aiReview = "Error generating review. Please try again.";
      });
    } finally {
      setState(() {
        _isGeneratingReview = false;
      });
    }
  }

  // Used AI to build the rating system for books then edited 
  // the code to save the rating to Firebase
  Widget _buildStarRating() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(5, (index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _rating = index + 1;
          });
          _saveRating(); // Save the rating when changed
        },
        child: Icon(
          index < _rating ? Icons.star : Icons.star_border,
          size: 30,
          color:_isDarkMode? Colors.white: Colors.black,
        ),
      );
    }),
  );
}

  @override
  Widget build(BuildContext context) {
    Color bgColor = _isDarkMode
        ? const Color.fromARGB(255, 20, 9, 45)
        : const Color.fromARGB(255, 216, 243, 245);
    Color boxColor = bgColor;
    Color shadowColor = Colors.black26;

    return Scaffold(
    // Custome app bar
    appBar: PreferredSize(
      preferredSize: 
        const Size.fromHeight(35),
      child: AppBar(
        backgroundColor: bgColor,
        elevation: 5,
        iconTheme: IconThemeData(
          color: _isDarkMode 
            ? Colors.white 
            : Colors.black
          ),
      ),
    ),
    backgroundColor: bgColor,
    body: 
    SingleChildScrollView(
      child: Align(
        alignment: 
        Alignment.topCenter,
        child: 
        Column(
          crossAxisAlignment: 
            CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40
            ),
            Row(
              mainAxisAlignment:
                MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: 
                    BorderRadius.circular(5),
                  child: 
                  Image.network(
                    widget.imageUrl,
                    height: 100,
                    width: 80,
                    fit: 
                      BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 40
                ),
                _buildBox(
                  200, 
                  100, 
                  '${widget.bookTitle} \n ${widget.bookAuthor}', 
                  boxColor, 
                  shadowColor,
                  isDarkMode: _isDarkMode,
                ),
              ],
            ),
            const SizedBox(
              height: 10
            ),
            _buildStarRating(),
            const SizedBox(
              height: 20
            ),
            GestureDetector(
              onTap: 
                _isGeneratingReview ? 
                  null : generateAIReview, 
              child: _buildBox(
                350, 
                60, 
                _isGeneratingReview 
                  ? 'Generating review...' 
                  : 'Click to generate AI review', 
               boxColor, 
                  shadowColor,
                  isDarkMode: _isDarkMode,
              )
            ),
            const SizedBox(
              height: 40
            ),
            _buildSpeechBubble(
              _aiReview, 
              boxColor, 
              shadowColor
            ),
            const SizedBox(
              height: 40
            ),

              Padding(
                padding: 
                  const EdgeInsets.symmetric(
                    horizontal: 20
                  ),
                child: 
                Column(
                  crossAxisAlignment: 
                    CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Notes:",
                      style: TextStyle(
                        fontSize: 
                          18,
                        fontWeight: 
                          FontWeight.bold,
                        color: _isDarkMode 
                          ? Colors.white 
                          : Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height
                      : 10
                    ),
                    Container(
                      height: 200,
                      decoration: 
                      BoxDecoration(
                        color: _isDarkMode 
                          ? Colors.grey[900] 
                          : Colors.white,
                        borderRadius: 
                          BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: 
                          const EdgeInsets.all(8.0),
                        child: 
                        TextField(
                          controller:
                            _notesController,
                          maxLines: 
                            null,
                          keyboardType: 
                            TextInputType.multiline,
                          decoration: 
                          InputDecoration(
                            hintText: "Write your notes about this book here...",
                            border: 
                              InputBorder.none,
                            hintStyle: 
                              TextStyle(
                              color: _isDarkMode 
                                ? Colors.grey[400] 
                                : Colors.grey[600],
                            ),
                          ),
                          style: TextStyle(
                            color: _isDarkMode 
                              ? Colors.white 
                              : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15
                    ),
                    SizedBox(
                      width: 
                        double.infinity,
                      child: 
                      ElevatedButton(
                        onPressed: _saveNotes,
                        style: 
                        ElevatedButton.styleFrom(
                          backgroundColor:_isDarkMode ? Colors.white: Colors.black,
                          padding: 
                            const EdgeInsets.symmetric(
                              vertical: 15
                            ),
                          shape: 
                          RoundedRectangleBorder(
                            borderRadius: 
                              BorderRadius.circular(10),
                          ),
                        ),
                        child: _isSavingNotes
                            ? CircularProgressIndicator(
                                color: _isDarkMode ? Colors.black :
                                  Colors.white
                                )
                            :  Text(
                                "Save Notes",
                                style: 
                                TextStyle(
                                  color: _isDarkMode ? Colors.black:
                                    Colors.white
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 40
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: NavBar(
      currentIndex: 4,
      onTap: (index) {
          Widget screen;
          switch (index) {
            case 0:
              screen = Library(
                isDarkMode: _isDarkMode, 
                toggleDarkMode: widget.toggleDarkMode
                );
              break;
            case 1:
              screen = TBR(
                isDarkMode: _isDarkMode, 
                toggleDarkMode: widget.toggleDarkMode
                );
              break;
            case 2:
              screen = ScanBook(
                isDarkMode: _isDarkMode, 
                toggleDarkMode: widget.toggleDarkMode
                );
              break;
            case 3:
              screen = Settings(
                isDarkMode: _isDarkMode, 
                toggleDarkMode: widget.toggleDarkMode
                );
              break;
            case 4:
            default:
              screen = HomePage2(
                isDarkMode: _isDarkMode, 
                toggleDarkMode: widget.toggleDarkMode
                );
          }
          Navigator.pushReplacement(
            context, MaterialPageRoute(
              builder: 
              (context) => screen));
        },
        isDarkMode: _isDarkMode,
      ),
    );
  }

  Widget _buildBox(
    double width, 
    double height, 
    String text, 
    Color color, 
    Color shadowColor,
      {required bool isDarkMode,}) {
    return Container(
      width: width,
      height: height,
      decoration: 
        BoxDecoration(
        color: color,
        borderRadius: 
          BorderRadius.circular(5),
        border: 
          Border.all(
            color:isDarkMode ? Colors.white: Colors.black),
        boxShadow: [
          BoxShadow(
            color: shadowColor, 
            blurRadius: 5, 
            offset: const Offset(2, 2))],
      ),
      alignment: 
        Alignment.center,
      child: Text(
        text,
        textAlign: 
          TextAlign.center,
        style: 
          TextStyle(
            color: isDarkMode ? Colors.white: Colors.black, 
            fontSize: 16
          ),
      ),
    );
  }

  // Method to create speech bubble style 
  // container for AI reviews
  Widget _buildSpeechBubble(
    String text, 
    Color color, 
    Color shadowColor, 
    {bool isLoading = false}) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(10),
      decoration: 
      BoxDecoration(
        color: color,
        borderRadius: 
          BorderRadius.circular(10),
        border: Border.all(
          color: _isDarkMode ? Colors.white : Colors.black ),
        boxShadow: [
          BoxShadow(
            color: shadowColor, 
            blurRadius: 5, 
            offset: const Offset(2, 2)
          )
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.person, 
            size: 30, 
            color: _isDarkMode 
              ? Colors.white
              : Colors.black,
            ),
          const SizedBox(
            width: 10
          ),
          Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: 16, 
                      color: _isDarkMode 
                        ? Colors.white 
                        : Colors.black,
                      ),
                  ),
          ),
        ],
      ),
    );
  }
}