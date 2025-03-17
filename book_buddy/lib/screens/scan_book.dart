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
    );
  }
}