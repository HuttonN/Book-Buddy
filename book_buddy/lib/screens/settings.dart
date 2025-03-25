// Import required packages.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import some other screens.
import 'package:book_buddy/screens/library.dart';
import 'package:book_buddy/screens/scan_book.dart';
import 'package:book_buddy/screens/home_page2.dart';
import 'package:book_buddy/screens/tbr.dart';
import 'package:book_buddy/screens/login.dart';

// User details from Firebase.
final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final User currentUser = FirebaseAuth.instance.currentUser!;

// Light/dark mode.
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

// Navigation bar.
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

        // My Library.
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: "", 
        ),
        
        // My TBR.
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: "", 
        ),
        
        // Scan Book.
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
        
        // Settings.
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "", 
        ),
        
        // Home.
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
  Map<String, dynamic>? userData;

  @override
  void initState(){
    super.initState();
    _isDarkMode = widget.isDarkMode;
    fetchUserData();
  }

  // Error catching for user data.
  Future<void> fetchUserData() async {
    try{
      final user = FirebaseAuth.instance.currentUser;
      if (user == null){
        print("User not signed in yet.");
        return;
      }

      String uid = user.uid;
      
      final querySnapshot = await FirebaseFirestore.instance
      .collection("usersCollection")
      .where("uid", isEqualTo: uid)
      .get();

      if (querySnapshot.docs.isEmpty){
        print("No matching user found.");
        return;
      }

      final userDoc = querySnapshot.docs.first;
      setState(() {
        userData = userDoc.data() as Map<String,dynamic>?;
      });

      print(userData);
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

    // Sign out option for user.
    Future<void> signOutUser() async {
      await FirebaseAuth.instance.signOut();
      
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Log out successful!'),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ),
      );

        Future.delayed(const Duration(seconds: 2), () {
          print('success');
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => Login(
                      isDarkMode: _isDarkMode, 
                      toggleDarkMode: widget.toggleDarkMode
                    ))
          );
        });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // App bar.
      appBar: PreferredSize(preferredSize: Size.fromHeight(35), 
      child: AppBar(
        backgroundColor: _isDarkMode 
          ? Color.fromARGB(255, 20, 9, 45) 
          : Color.fromARGB(255, 223, 245, 252),
        elevation: 5 ,
        iconTheme: IconThemeData(
          color: _isDarkMode 
            ? Colors.white 
            : Color.fromARGB(255, 20, 9, 45) 
          ),

        //Save the state of light/dark mode when the back button is pressed.
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.toggleDarkMode(_isDarkMode);  // Save the dark mode state.
              Navigator.pop(context, _isDarkMode);  // Go back and pass the updated state.
            },
          ),
        )),
      
      backgroundColor: _isDarkMode 
        ? Color.fromARGB(255, 20, 9, 45) 
        : Color.fromARGB(255, 216, 243, 245),
      
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          // Page icon and heading.
          children: [
            Row(
              children: [

                // Icon.
                SizedBox(
                  width: 100,
                  height: 100,
                    child: Icon(
                      Icons.settings,
                      size: 90,
                      color: _isDarkMode
                        ? Colors.white
                        : Colors.black
                    )
                ),

                // Heading.
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode 
                      ? Colors.white 
                      : Colors.black,
                  ),
                ),
              ],
            ),

            // Add space
            SizedBox(height: 50),

            // Menu of user details, mode and sign out options.
            // Outer container.
            Container(
              width: 270,
              height: 330,
              decoration: BoxDecoration(
                color: _isDarkMode 
                  ? Colors.black 
                  : Color.fromARGB(255, 223, 245, 252),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isDarkMode 
                    ? Colors.white 
                    : Color.fromARGB(255, 216, 238, 245),  // Border color
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

                // Inner containers.
                children: [

                  // Add space.
                  SizedBox(height: 30),

                  // Displayn user's email address.
                  Container(
                    width: 240,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _isDarkMode 
                        ? Colors.white 
                        : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('Email: ${userData!['Email']}', 
                                style: TextStyle(
                                  color: _isDarkMode 
                                    ? Colors.black 
                                    : Colors.white
                                )
                            ),
                  ),

                  // Add space.
                  SizedBox(height: 30),
                  
                  // Display user's first name.
                  Container(
                    width: 240,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _isDarkMode 
                        ? Colors.white 
                        : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('First Name: ${userData!['First Name']}', 
                                style: TextStyle(
                                  color: _isDarkMode 
                                    ? Colors.black 
                                    : Colors.white
                                )
                            ),
                  ),

                  // Add space.
                  SizedBox(height: 30),

                  // Display user's surname.
                  Container(
                    width: 240,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _isDarkMode 
                        ? Colors.white 
                        : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('Surname: ${userData!['Surname']}', 
                                style: TextStyle(
                                  color: _isDarkMode 
                                    ? Colors.black 
                                    : Colors.white
                                )
                            ),
                  ),

                  // Add space.
                  SizedBox(height: 30),

                  // Light/ dark mode toggle switch.
                  Container(
                    width: 240,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _isDarkMode 
                        ? Colors.white 
                        : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // Change the text on the button.
                        Text(
                          _isDarkMode 
                            ? 'Dark Mode' 
                            : 'Light Mode', 
                          style: TextStyle(
                            color:_isDarkMode 
                              ? Colors.black
                              : Colors.white
                          ),
                        ),

                        // switch between modes.
                        Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: _isDarkMode,
                            onChanged: (value){
                              setState((){
                                _isDarkMode = value;
                              });
                              widget.toggleDarkMode(value);
                            }, 
                            activeColor: Colors.blue,
                          ),
                        )

                      ],

                    ),
                  ),

                  // Add space
                  SizedBox(height: 30),

                  // Sign out button.
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context, 
                          builder: (BuildContext context){

                            // Dialog box.
                            return AlertDialog(
                              title: Text('Are you sure?'),
                                actions: [

                                  // Sign out confirmed.
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      signOutUser();
                                    }, 
                                    child: Text("Yes")
                                  ),

                                  // Sign out cancelled.
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }, 
                                    child: Text("No")
                                  )
                                ],
                            );
                          }
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30, 
                        vertical: 10),  
                      textStyle: TextStyle(fontSize: 16),  
                      backgroundColor: _isDarkMode 
                        ? Colors.white
                        : Colors.black, 
                      foregroundColor: _isDarkMode 
                        ? Colors.black
                        : Colors.white,
                      minimumSize: Size(100, 40)
                    ),
                    child: Text('Sign Out'),
                  )
                ],
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),

      // Navigation bar.       
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