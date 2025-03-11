import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

/*
State for light or dark mode.
Generative AI was used for generating this toggle
between light and dark mode.
*/
class _SettingsState extends State<Settings> {
  bool isDarkMode = false;  

   // Method to toggle dark mode
  void toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;  // Set state when the switch is toggled
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Color.fromARGB(255, 20, 9, 45) : Color.fromARGB(255, 216, 243, 245),

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
                  child: isDarkMode ? Image.asset('assets/settings_icon_dark_mode.png'): Image.asset('assets/settings_icon_light_mode.png'),
                ),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),

            // Add space
            SizedBox(height: 50),

            Container(
              width: 200,
              height: 270,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Color.fromARGB(255, 216, 238, 245),
                borderRadius: BorderRadius.circular(10),
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
                      color: isDarkMode ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('Email', 
                                style: TextStyle(
                                  color: isDarkMode ? Colors.black : Colors.white)),
                  ),

                  // Add space
                  SizedBox(height: 30),

                  Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('First Name', 
                                style: TextStyle(
                                  color: isDarkMode ? Colors.black : Colors.white)),
                  ),

                  // Add space
                  SizedBox(height: 30),

                  Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('Surname', 
                                style: TextStyle(
                                  color: isDarkMode ? Colors.black : Colors.white)),
                  ),

                  // Add space
                  SizedBox(height: 30),

                  //Light/dark mode container
                  Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isDarkMode ? 'Dark Mode' : 'Light Mode',  // Conditionally change text
                          style: TextStyle(
                            color:isDarkMode ? Colors.black: Colors.white),
                        ),
                        Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: isDarkMode,
                            onChanged: toggleDarkMode,  // When the switch is toggled, update state
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




