import 'package:book_buddy/screens/library.dart';
import 'package:book_buddy/screens/home_page2.dart';
import 'package:book_buddy/screens/settings.dart';
import 'package:book_buddy/screens/tbr.dart';
import 'package:flutter/material.dart';

class ScanBook extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode; 

   const ScanBook({
    required this.isDarkMode,
    required this.toggleDarkMode,
    super.key,
   });

   @override 
   _ScanBookState createState() => _ScanBookState();
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
          icon: Icon(Icons.menu_book),
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: "", 
        ),
        
        BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black, // Black circle for camera button
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.camera_alt, color: Colors.white), // White camera icon
            ),
            label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "", 
        ),
      ],
    ),
    );
  }
}


class _ScanBookState extends State<ScanBook>{
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
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.camera_alt,
                    color: _isDarkMode ? Colors.white: Colors.black,
                    size: 80,
                    )
                ),
                Text(
                  'Scan Book',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),

            Container(
              width:300, 
              height: 60, 
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.black : Color.fromARGB(255, 223, 245, 252),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: _isDarkMode ? Colors.white : Color.fromARGB(255, 216, 238, 245),  // Border color
                  width: 1,  // Border width
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(90, 0, 0, 0),  
                    offset: Offset(0,5),  
                    blurRadius: 5,  
                    spreadRadius: 0.1,  
                  ),
                ],
              ),
              child: Text('Position camera directly above book cover.',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18)),
            )

            
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