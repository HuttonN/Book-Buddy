import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:book_buddy/screens/library.dart';
import 'package:book_buddy/screens/scan_book.dart';
import 'package:book_buddy/screens/settings.dart';
import 'package:book_buddy/screens/home_page2.dart';
import 'package:book_buddy/screens/tbr.dart';

class Library_specific_book extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;
  final String bookTitle;  
  final String bookAuthor;
  final String imageUrl;

  const Library_specific_book({
    required this.isDarkMode,
    required this.toggleDarkMode,
    required this.bookTitle,  
    required this.bookAuthor,
    required this.imageUrl,
    super.key
  });

  @override
  _Library_specific_bookState createState() => _Library_specific_bookState();
}

// Navigation bar.
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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    
    child: BottomNavigationBar(
        backgroundColor: Colors.transparent, 
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.white, 
        showSelectedLabels: false, 
        showUnselectedLabels: false, 
        currentIndex: currentIndex, 
        onTap: onTap, 
        type: BottomNavigationBarType.fixed,  

      items: [
        BottomNavigationBarItem(
          icon: Semantics(
            label: 'Library- book icon',
            hint: 'Press to go to My Library screen',
            child: Icon(Icons.menu_book, color: isDarkMode ? Colors.black: Colors.white,),
          ),
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: Semantics(
            label: 'My TBR- bookmark icon',
            hint: 'Press to go to My TBR screen',
            child: Icon(Icons.bookmark, color: isDarkMode ? Colors.black: Colors.white,)
          ),
          label: "", 
        ),
        
        BottomNavigationBarItem(
            icon: Semantics(
              label: 'Scan book- camera icon',
              hint: 'Press to to go to scan book screen',
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode? Colors.white70: Colors.black, // Black circle for camera button
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt, color: isDarkMode ? Colors.black: Colors.white,), // White camera icon
              ),
            ),
            label: "", 
            ),
            

        BottomNavigationBarItem(
          icon: Semantics(
            label: 'Settings- settings icon',
            hint: 'Press to go to Settings screen', 
            child: Icon(Icons.settings, color: isDarkMode ? Colors.black: Colors.white,),
          ), 
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: Semantics(
            label: 'Home- home icon', 
            hint: 'Press to go to the home page screen',
            child: Icon(Icons.home, color: isDarkMode ? Colors.black: Colors.white,),
          ),
          label: "", 
        ),
      ],
    ),
    );
  }
}


class _Library_specific_bookState extends State<Library_specific_book> {
  late bool _isDarkMode;
  String _aiReview = "";
  bool _isGeneratingReview = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  Future<void> generateAIReview() async {  
    setState(() {
      _isGeneratingReview = true;
    });

    try {
      final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: 'AIzaSyCElfNpjFeYtMAhK1KqLg14VyMOEhGq_oA'); 
      final prompt = "Write a 80-word review for the book '${widget.bookTitle}' by ${widget.bookAuthor}. "
          "Include the genre, main themes, and who might enjoy it.";
      final response = await model.generateContent([Content.text(prompt)]);
      
      setState(() {
        _aiReview = response.text ?? "Could not generate review. Please try again.";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error generating review: ${e.toString()}")),
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

   @override
  Widget build(BuildContext context) {
    Color bgColor = _isDarkMode
        ? const Color.fromARGB(255, 20, 9, 45)
        : const Color.fromARGB(255, 216, 243, 245);
    Color boxColor = bgColor;
    Color shadowColor = Colors.black26;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: AppBar(
          backgroundColor: bgColor,
          elevation: 5,
          iconTheme: IconThemeData(color: _isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      backgroundColor: bgColor,
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.imageUrl,
                    height: 100,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                )
                ,
                const SizedBox(width: 40),
                _buildBox(200, 100, '${widget.bookTitle} \n ${widget.bookAuthor}', boxColor, shadowColor),
              ],
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _isGeneratingReview ? null : generateAIReview, 
              child: _buildBox(
                350, 
                60, 
                _isGeneratingReview ? 'Generating review...' : 'Click to generate AI review', 
                _isDarkMode ? Colors.white : Colors.black, 
                shadowColor,
                textColor: _isDarkMode ? Colors.black : Colors.white,
              )
            ),
            const SizedBox(height: 40),
            _buildSpeechBubble(_aiReview, boxColor, shadowColor),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 4,
        onTap: (index) {
          Widget screen;
          switch (index) {
            case 0:
              screen = Library(isDarkMode: _isDarkMode, toggleDarkMode: widget.toggleDarkMode);
              break;
            case 1:
              screen = TBR(isDarkMode: _isDarkMode, toggleDarkMode: widget.toggleDarkMode);
              break;
            case 2:
              screen = ScanBook(isDarkMode: _isDarkMode, toggleDarkMode: widget.toggleDarkMode);
              break;
            case 3:
              screen = Settings(isDarkMode: _isDarkMode, toggleDarkMode: widget.toggleDarkMode);
              break;
            case 4:
            default:
              screen = HomePage2(isDarkMode: _isDarkMode, toggleDarkMode: widget.toggleDarkMode);
          }
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen));
        },
        isDarkMode: _isDarkMode,
      ),
    );
  }

  Widget _buildBox(double width, double height, String text, Color color, Color shadowColor,
      {Color? textColor}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: _isDarkMode ? Colors.white : Colors.black),
        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 5, offset: const Offset(2, 2))],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor ?? (_isDarkMode ? Colors.white: Colors.black), fontSize: 16),
      ),
    );
  }

  Widget _buildSpeechBubble(String text, Color color, Color shadowColor, {bool isLoading = false}) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _isDarkMode ? Colors.white : Colors.black),
        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 5, offset: const Offset(2, 2))],
      ),
      child: Row(
        children: [
          Icon(Icons.person, size: 30, color: _isDarkMode ? Colors.white: Colors.black,),
          const SizedBox(width: 10),
          Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(
                    text,
                    style: TextStyle(fontSize: 16, color: _isDarkMode ? Colors.white : Colors.black,),
                  ),
          ),
        ],
      ),
    );
  }
}