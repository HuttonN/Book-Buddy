import 'package:flutter/material.dart';

class TBR extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode; 

   const TBR({
    required this.isDarkMode,
    required this.toggleDarkMode,
    super.key,
   });

   @override 
   _TBRState createState() => _TBRState();
}


class _TBRState extends State<TBR>{
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
                    Icons.bookmark,
                    color: _isDarkMode ? Colors.white: Colors.black,
                    size: 80,
                    )
                ),
                Text(
                  'TBR',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),

            

            
          ],
        ),
      ),
    );
  }
}