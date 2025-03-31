import 'package:book_buddy/screens/library.dart';
import 'package:book_buddy/screens/scan_book.dart';
import 'package:book_buddy/screens/settings.dart';
import 'package:book_buddy/screens/tbr.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final User currentUser = FirebaseAuth.instance.currentUser!;

class HomePage2 extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode; 

   const HomePage2({
    required this.isDarkMode,
    required this.toggleDarkMode,
    super.key,
   });

   @override 
   _HomePage2State createState() => _HomePage2State();
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


class _HomePage2State extends State<HomePage2>{
  late bool _isDarkMode;
  Map<String, dynamic>? userData;

  @override
  void initState(){
    super.initState();
    _isDarkMode = widget.isDarkMode;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try{
      final user = FirebaseAuth.instance.currentUser;
      if (user == null){
        print("User not signed in yet.");
        return;
      }

      String uid = user.uid;
      
      final querySnapshot = await firestore.FirebaseFirestore.instance
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

  @override
  Widget build(BuildContext context) {
if (userData == null){
      return Scaffold(
        backgroundColor: _isDarkMode ? Color.fromARGB(255, 20, 9, 45) : Color.fromARGB(255, 223, 245, 252),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
        return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(35), 
      child: AppBar(
        backgroundColor: _isDarkMode ? Color.fromARGB(255, 20, 9, 45) : Color.fromARGB(255, 223, 245, 252),
        elevation: 5 ,
        iconTheme: IconThemeData(color: _isDarkMode ? Colors.white : Color.fromARGB(255, 20, 9, 45)),
      )
      ),
      
      backgroundColor: _isDarkMode ? Color.fromARGB(255, 20, 9, 45) : Color.fromARGB(255, 216, 243, 245),
      
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
                      Icons.home,
                      size: 90,
                      color: _isDarkMode
                        ? Colors.white
                        : Colors.black
                    )
                ),

                // Heading.
                Text(
                  'Home',
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

            Container(
              width: 200,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,  
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,  
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  Text(
                    '${userData!['First Name']},\nYOU HAVE\n COMPLETED\n${userData!['Books Read']}\nBOOKS THIS\n YEAR!!!',
                    textAlign: TextAlign.center,  
                    style: TextStyle(
                      color: _isDarkMode ? Colors.black : Colors.white,  // Text color based on dark mode
                      fontSize: 14, 
                    ),
                  ),
                  ],
              ),
            ),

            // Container for navigations.
            Container(
              width: 200,
              height: 240,
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
            child: Column(

              //Navigations to different pages.
              children: [

                SizedBox(height: 10),

                //My Library.
                Semantics(

                  // Semantics added for accessibility.
                  label: 'Nativate to My Library',
                  hint: 'Press to navigate to the My Library screen',

                  child: 
                    TextButton(onPressed: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => Library(
                          isDarkMode: _isDarkMode, 
                          toggleDarkMode: widget.toggleDarkMode
                          )
                        )
                      );
                      }, child: 
                        Container( 
                          width:180, 
                          height: 20, 
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isDarkMode ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(90, 0, 0, 0),  
                                offset: Offset(0,5),  
                                blurRadius: 6,  
                                spreadRadius: 0.1,  
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              SizedBox(width: 2),

                              Icon(
                                Icons.menu_book,
                                color: _isDarkMode ? Colors.black : Colors.white,
                                size: 20,
                              ),

                              SizedBox(width: 45),

                              Expanded(
                                child: 
                                  Text('My Library', 
                                    style: TextStyle(
                                      color: _isDarkMode ? Colors.black : Colors.white,
                                      fontSize: 10)
                                  )
                              )
                            ],
                          )
                        )
                      ),
                ),
                
                SizedBox(height: 10),

                //My TBR.
                Semantics(

                  // Semantics added for accessibility.
                  label: 'Nativate to My TBR',
                  hint: 'Press to navigate to the My TBR screen',

                  child: 
                    TextButton(onPressed: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => TBR(
                          isDarkMode: _isDarkMode, 
                          toggleDarkMode: widget.toggleDarkMode
                        )
                        )
                      );
                      }, child: 
                        Container( 
                          width:180, 
                          height: 20, 
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isDarkMode ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(90, 0, 0, 0),  
                                offset: Offset(0,5),  
                                blurRadius: 6,  
                                spreadRadius: 0.1,  
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              
                              SizedBox(width: 2),

                              Icon(
                                Icons.bookmark,
                                color: _isDarkMode ? Colors.black : Colors.white,
                                size: 20,
                              ),

                              SizedBox(width: 45),

                              Expanded(
                                child: 
                                  Text('My TBR', 
                                    style: TextStyle(
                                      color: _isDarkMode ? Colors.black : Colors.white,
                                      fontSize: 10)
                                  )
                              )
                            ],
                          )
                        )
                      )
                ),

                SizedBox(height: 10),

                //Scan Book.
                Semantics(

                  // Semantics added for accessibility.
                  label: 'Nativate to Scan Book',
                  hint: 'Press to navigate to the Scan Book screen',

                  child: 
                    TextButton(onPressed: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ScanBook(
                          isDarkMode: _isDarkMode, 
                          toggleDarkMode: widget.toggleDarkMode
                        )
                        )
                      );
                    }, child: 
                      Container( 
                        width:180, 
                        height: 20, 
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _isDarkMode 
                            ? Colors.white
                            : Colors.black,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(90, 0, 0, 0),  
                              offset: Offset(0,5),  
                              blurRadius: 6,  
                              spreadRadius: 0.1,  
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          
                          SizedBox(width: 2),

                          Icon(
                            Icons.camera_alt,
                            color: _isDarkMode
                              ? Colors.black
                              : Colors.white,
                            size: 20,
                          ),

                          SizedBox(width: 45),

                          Expanded(
                            child: 
                              Text('Scan Book', 
                                style: TextStyle(
                                  color: _isDarkMode ? Colors.black : Colors.white,
                                  fontSize: 10)
                              )
                          )
                          ],
                        )
                      )
                  )

                ),
                

                SizedBox(height: 10),

                //Settings.
                Semantics(

                  // Semantics added for accessibility.
                  label: 'Nativate to Settings',
                  hint: 'Press to navigate to the Settings screen',

                  child: 
                    TextButton(
                      onPressed: () async {
                        final updatedDarkMode = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Settings(
                            isDarkMode: _isDarkMode, 
                            toggleDarkMode: widget.toggleDarkMode,
                          ),
                        ),
                        );

                    // Update the state with the new dark mode value
                    if (updatedDarkMode != null) {
                      setState(() {
                        _isDarkMode = updatedDarkMode;
                      });
                    }
                  },child: 
                        Container( 
                          width:180, 
                          height: 20, 
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isDarkMode ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(90, 0, 0, 0),  
                                offset: Offset(0,5),  
                                blurRadius: 5,  
                                spreadRadius: 0.1,  
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              
                              SizedBox(width: 2),

                              Icon(
                                Icons.settings,
                                color: _isDarkMode ? Colors.black : Colors.white,
                                size: 20,
                              ),

                              SizedBox(width: 45),

                              Expanded(
                                child: 
                                  Text('Settings', 
                                    style: TextStyle(
                                      color: _isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                      fontSize: 10
                                      )
                                  )
                              )
                            ],
                          )
                        )
                    )

                ),
              ],
            )
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
        },
      ),
    );
  }
}