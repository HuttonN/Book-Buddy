import 'package:flutter/material.dart';
//import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:book_buddy/screens/library.dart';
import 'package:book_buddy/screens/scan_book.dart';
import 'package:book_buddy/screens/settings.dart';
import 'package:book_buddy/screens/home_page2.dart';
import 'package:book_buddy/screens/tbr.dart';


class TBR_specific_book extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode; 

   const TBR_specific_book({
    required this.isDarkMode,
    required this.toggleDarkMode,
    super.key,
   });

   @override 
   _TBR_specific_bookState createState() => _TBR_specific_bookState();
}

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({super.key, required this.onTap, required this.currentIndex});

 @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black, // Black background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    
    child: BottomNavigationBar(
        backgroundColor: Colors.transparent, 
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.white70, 
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
            child: Icon(Icons.menu_book),
          ),
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: Semantics(
            label: 'My TBR- bookmark icon',
            hint: 'Press to go to My TBR screen',
            child: Icon(Icons.bookmark)
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
                  color: Colors.black, // Black circle for camera button
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt, color: Colors.white), // White camera icon
              ),
            ),
            label: "", 
            ),
            

        BottomNavigationBarItem(
          icon: Semantics(
            label: 'Settings- settings icon',
            hint: 'Press to go to Settings screen', 
            child: Icon(Icons.settings),
          ), 
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: Semantics(
            label: 'Home- home icon', 
            hint: 'Press to go to the home page screen',
            child: Icon(Icons.home),
          ),
          label: "", 
        ),
      ],
    ),
    );
  }
}


class _TBR_specific_bookState extends State<TBR_specific_book>{
  late bool _isDarkMode;

  @override
  void initState(){
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(35), 
      child: AppBar(
        backgroundColor: _isDarkMode ? Color.fromARGB(255, 20, 9, 45) : Color.fromARGB(255, 223, 245, 252),
        elevation: 5 ,
        iconTheme: IconThemeData(color: _isDarkMode ? Colors.white : Color.fromARGB(255, 20, 9, 45) ),
        )),
      
      backgroundColor: _isDarkMode ? Color.fromARGB(255, 20, 9, 45) : Color.fromARGB(255, 216, 243, 245),
      
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40), 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //SizedBox(width: 40), 

                Container(
                            width: 80,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 223, 245, 252),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black)
                            ),
                            child: Text('cover')
                          ),

                SizedBox(width: 40), 

                Container(
                            width: 200,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 223, 245, 252),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black)
                            ),
                            child: Column(children: [Text('title'), Text('author')],)
                          ),
              ],
            ),
            SizedBox(height: 40), 

            Container(
                            width: 350,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 223, 245, 252),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black)
                            ),
                            child: Text('click to generate AI review'),
                          ),
            SizedBox(height: 40), 

            Container(
                            width: 350,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 223, 245, 252),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black)
                            ),
                            child: Text('AI generated reveiw'),
                          ),

            
            
          ],
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
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
        }
       )
    );
  }
}