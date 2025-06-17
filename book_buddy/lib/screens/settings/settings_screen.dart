// Import required packages.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import some other screens.
import 'package:book_buddy/screens/library/library_screen.dart';
import 'package:book_buddy/screens/scan/scan_book_screen.dart';
import 'package:book_buddy/screens/home/home_page_screen.dart';
import 'package:book_buddy/screens/tbr/tbr_screen.dart';
import 'package:book_buddy/screens/auth/login_screen.dart';

// User details from Firebase.
final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final User currentUser = FirebaseAuth.instance.currentUser!;

/* Initially, when navigating to the settings page a red error screen 
was briefly displayed before all the user data was fetched. AI was used
to help fix this error, by helping to add in the future builder.*/

// Settings screen allowing users to view their account 
// infor, toggle between light and dark mode and sign 
// out of their acount
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
    
    child: BottomNavigationBar(
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
          icon: Semantics(
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
          icon: Semantics(
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
            icon: Semantics(
              label: 'Scan book- camera icon',
              hint: 'Press to to go to scan book screen',
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode
                    ? Colors.white70
                    : Colors.black, // Black circle for camera button
                  shape: 
                    BoxShape.circle,
                ),
                child: 
                  Icon(
                    Icons.camera_alt, 
                    color: isDarkMode 
                      ? Colors.black
                      : Colors.white,
                    ), // White camera icon
              ),
            ),
            label: "", 
            ),
            
        // Sentimatics
        BottomNavigationBarItem(
          icon: Semantics(
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
          icon: Semantics(
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

// State class for settings screen that fetches and 
// displays user data, allows light/dark mode 
// toggling and a user authentication state
class _SettingsState extends State<Settings>{
  late bool _isDarkMode;
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState(){
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _userDataFuture = fetchUserData();
  }

  // Fetches user data from firestore
  // Error catching for user data.
  Future<Map<String, dynamic>?> fetchUserData() async {
    try{
      final user = FirebaseAuth.instance.currentUser;
      if (user == null){
        print("User not signed in yet.");
        return null;
      }

      String uid = user.uid;
      
      final querySnapshot = await FirebaseFirestore.instance
      .collection("usersCollection")
      .where("uid", isEqualTo: uid)
      .get();

      if (querySnapshot.docs.isEmpty){
        print("No matching user found.");
        return null;
      }

      final userDoc = querySnapshot.docs.first;
      return userDoc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

    // Sign out option for user.
    Future<void> signOutUser() async {
      await FirebaseAuth.instance.signOut();
      
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: 
            Text('Log out successful!'),
          backgroundColor: 
            Colors.black,
          duration: 
            Duration(seconds: 2),
        ),
      );

        Future.delayed(
          const Duration(seconds: 2), () {
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
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Define the margin (you can modify this to make it editable)
    double margin = 20.0;

    // Calculate the available width by subtracting the margin from the screen width
    double availiableWidth = screenWidth - margin * 2;




    return Scaffold(

      // App bar.
      appBar: 
        PreferredSize(preferredSize: Size.fromHeight(35), 
      child: 
        AppBar(
        backgroundColor: _isDarkMode 
          ? Color.fromARGB(255, 20, 9, 45) 
          : Color.fromARGB(255, 223, 245, 252),
        elevation: 5 ,
        iconTheme: IconThemeData(
          color: _isDarkMode 
            ? Colors.white 
            : Color.fromARGB(255, 20, 9, 45) 
          ),

        // Save the state of light/dark mode 
        // when the back button is pressed.
        leading: IconButton(
            icon: 
            Icon(
              Icons.arrow_back
            ),
            onPressed: () {
              widget.toggleDarkMode(
                _isDarkMode
              );  // Save the dark mode state.
              Navigator.pop(
                context, 
                _isDarkMode
              );  // Go back and pass the updated state.
            },
          ),
        )),
      
      backgroundColor: _isDarkMode 
        ? Color.fromARGB(255, 20, 9, 45) 
        : Color.fromARGB(255, 216, 243, 245),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userDataFuture,
        builder: (contect, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center();
          } else if (snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null){
            return Center(child:Text('No user data found.'));
          } else {
            final userData = snapshot.data!;
            return Align(
        alignment: 
          Alignment.topCenter,
        child: 
        Column(
          crossAxisAlignment: 
            CrossAxisAlignment.center,
          
          

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
            SizedBox(height:85),

            // Menu of user details, mode and sign out options.
            // Outer container.
            Container(
              width: availiableWidth,
              height: 400,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _isDarkMode 
                  ? Colors.black 
                  : Color.fromARGB(255, 223, 245, 252),
                borderRadius: 
                  BorderRadius.circular(10),
                border: 
                  Border.all(
                  color: _isDarkMode 
                    ? Colors.white 
                    : Color.fromARGB(255, 216, 238, 245),  // Border color
                  width: 1,  // Border width
                ),
              boxShadow: [
                BoxShadow(
                  color: 
                    Color.fromARGB(90, 0, 0, 0),  
                  offset:  
                    Offset(0,5),  
                  blurRadius: 6,  
                  spreadRadius: 2,  
                ),
              ],
            ),

              alignment: 
                Alignment.center,
              child:  
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // Inner containers.
                children: [

                  // Add space.
                  //SizedBox(height: 30),

                  // Displayn user's email address.
                  Container(
                    height: 30,
                    decoration: 
                    BoxDecoration(
                      color: _isDarkMode 
                        ? Colors.white 
                        : Colors.black,
                      borderRadius: 
                        BorderRadius.circular(10),
                    ),
                    alignment: 
                      Alignment.center,
                    child: 
                      Text('Email: ${userData['Email']}', 
                                style: TextStyle(
                                  color: _isDarkMode 
                                    ? Colors.black 
                                    : Colors.white
                                )
                            ),
                  ),
                  
                  // Display user's first name.
                  Container(
                    height: 30,
                    decoration: 
                    BoxDecoration(
                      color: _isDarkMode 
                        ? Colors.white 
                        : Colors.black,
                      borderRadius:
                        BorderRadius.circular(10),
                    ),
                    alignment: 
                      Alignment.center,
                    child: 
                      Text('First Name: ${userData['First Name']}', 
                                style: TextStyle(
                                  color: _isDarkMode 
                                    ? Colors.black 
                                    : Colors.white
                                )
                            ),
                  ),

                  // Display user's surname.
                  Container(
                    height: 30,
                    decoration: 
                    BoxDecoration(
                      color: _isDarkMode 
                        ? Colors.white 
                        : Colors.black,
                      borderRadius: 
                        BorderRadius.circular(10),
                    ),
                    alignment: 
                      Alignment.center,
                    child: 
                      Text('Surname: ${userData['Surname']}', 
                                style: TextStyle(
                                  color: _isDarkMode 
                                    ? Colors.black 
                                    : Colors.white
                                )
                            ),
                  ),

                  // Light/ dark mode toggle switch.
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: _isDarkMode 
                        ? Colors.white 
                        : Colors.black,
                      borderRadius: 
                        BorderRadius.circular(10),
                    ),
                    alignment: 
                      Alignment.center,
                    child: 
                    Row(
                      mainAxisAlignment: 
                        MainAxisAlignment.center,
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
                                      _isDarkMode= false;
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

                    style: 
                      ElevatedButton.styleFrom(
                      padding: 
                        EdgeInsets.symmetric(
                        horizontal: 30, 
                        vertical: 10),  
                      textStyle: 
                        TextStyle(fontSize: 16),  
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

            Spacer(),
          ],
        ),
      );
          }
        }),
      

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
              MaterialPageRoute(
                builder: 
                (context) => screen
              ),
            );
        },
        isDarkMode: _isDarkMode,
       )
    );
  }
}