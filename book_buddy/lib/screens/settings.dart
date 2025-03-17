import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final User currentUser = FirebaseAuth.instance.currentUser!;

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
                    child: Text("$currentUser", 
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
    );
  }
}




