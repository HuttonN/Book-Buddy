import 'package:book_buddy/screens/home_page2.dart';
import 'package:book_buddy/screens/scan_book.dart';
import 'package:book_buddy/screens/settings.dart';
import 'package:book_buddy/screens/tbr.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
//import 'package:firebase_storage/firebase_storage.dart';

class Library extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode; 

   const Library({
    required this.isDarkMode,
    required this.toggleDarkMode,
    super.key,
   });

   @override 
   _LibraryState createState() => _LibraryState();
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


class _LibraryState extends State<Library>{
  late bool _isDarkMode;
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> userBooks = [];

  @override
  void initState(){
    super.initState();
    _isDarkMode = widget.isDarkMode;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try{
      String uid = FirebaseAuth.instance.currentUser!.uid;
      
      firestore.QuerySnapshot querySnapshot = await firestore.FirebaseFirestore.instance
      .collection("usersCollection")
      .where("uid", isEqualTo: uid)
      .get();

     firestore.DocumentSnapshot userDoc = querySnapshot.docs.first;

    setState(() {
      userData = userDoc.data() as Map<String,dynamic>?;
    });

     print(userData);

    firestore.QuerySnapshot booksSnapshot = await userDoc.reference
      .collection("Books")
      .get();

    List<Map<String, dynamic>> booksList = booksSnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .where((book) => 
        book['has_read'] == true)
      .toList();

    setState(() {
      userBooks = booksList;
    });

    print(userBooks);
    
    } catch (e) {
      print("Error fetching user data: $e");
    }
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
                    Icons.menu_book,
                    color: _isDarkMode ? Colors.white: Colors.black,
                    size: 90,
                    )
                ),
                Text(
                  'Library',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),

            Expanded(
              child:ListView.builder(
                itemCount: userBooks.length,
                itemBuilder: (context, index) {
                  final book = userBooks[index];
                    return Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            book['image_url'],
                            fit: BoxFit.cover,
                            )
                        ),
                        title: Text(book['Title']),
                        subtitle: Text(book['Author']),
                      ),
                    );
                },
              ),
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