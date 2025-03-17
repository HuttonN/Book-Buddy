import 'package:book_buddy/screens/library.dart';
import 'package:book_buddy/screens/scan_book.dart';
import 'package:book_buddy/screens/home_page2.dart';
import 'package:book_buddy/screens/tbr.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode; 

   const Settings({
    required this.isDarkMode,
    required this.toggleDarkMode,
    super.key,
   });

   @override 
   _SettingsState createState() => _SettingsState();
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


class _SettingsState extends State<Settings>{
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

        //Save the state of light/dark mode when the back button is pressed.
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.toggleDarkMode(_isDarkMode);  // Save the dark mode state.
              Navigator.pop(context, _isDarkMode);  // Go back and pass the updated state.
            },
          ),
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
                  child: _isDarkMode ? Image.asset('assets/settings_icon_dark_mode.png'): Image.asset('assets/settings_icon_light_mode.png'),
                ),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),

            // Add space
            SizedBox(height: 50),

            Container(
              width: 200,
              height: 274,
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.black : Color.fromARGB(255, 223, 245, 252),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isDarkMode ? Colors.white : Color.fromARGB(255, 216, 238, 245),  // Border color
                  width: 1,  // Border width
                ),
              boxShadow: [
                BoxShadow(
                color: Color.fromARGB(90, 0, 0, 0),  
                offset: Offset(0,5),  
                blurRadius: 6,  
                spreadRadius: 2,  
                ),
              ],
            ),
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Add space
                  SizedBox(height: 30),

                  Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('Email', 
                                style: TextStyle(
                                  color: _isDarkMode ? Colors.black : Colors.white)),
                  ),

                  // Add space
                  SizedBox(height: 30),

                  Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('First Name', 
                                style: TextStyle(
                                  color: _isDarkMode ? Colors.black : Colors.white)),
                  ),

                  // Add space
                  SizedBox(height: 30),

                  Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('Surname', 
                                style: TextStyle(
                                  color: _isDarkMode ? Colors.black : Colors.white)),
                  ),

                  // Add space
                  SizedBox(height: 30),

                  //Light/dark mode container
                  Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isDarkMode ? 'Dark Mode' : 'Light Mode',  // Conditionally change text
                          style: TextStyle(
                            color:_isDarkMode ? Colors.black: Colors.white),
                        ),
                        Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: _isDarkMode,
                            onChanged: (value){
                              setState((){
                                _isDarkMode = value;
                              });
                              widget.toggleDarkMode(value);
                            },  // When the switch is toggled, update state
                            activeColor: Colors.blue,  // Color of the switch when active
                          ),
                        )
                      ],
                    ),
                  ),

                  // Add space
                  SizedBox(height: 30)
                ],
              ),
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




