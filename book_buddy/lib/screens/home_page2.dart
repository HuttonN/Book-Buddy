import 'package:book_buddy/screens/library.dart';
import 'package:flutter/material.dart';

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


class _HomePage2State extends State<HomePage2>{
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
                  height: 50,
                  child: _isDarkMode ? Image.asset('assets/home_icon_dark_mode.png'): Image.asset('assets/home_icon_light_mode.png'),
                ),
              ],
            ),

            Container(
              width: 200,
              height: 274,
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
                    '[first name],\nYOU HAVE\n COMPLETED\n[...]\nBOOKS THIS\n YEAR!!!',
                    textAlign: TextAlign.center,  
                    style: TextStyle(
                    color: _isDarkMode ? Colors.black : Colors.white,  // Text color based on dark mode
                    fontSize: 16, 
                    ),
                  ),
                  ],
              ),
            ),

            Container(
              width: 200,
              height: 200,
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
              children: [
                TextButton(onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => Library(),));
                  }, child: 
                    Container(color: Colors.black, 
                      width:180, 
                      height: 20, 
                      alignment: Alignment.center,
                      child: Text('My Library', style: TextStyle(fontSize: 10)))),
                Text('lib'),
                Text('My TBR'),
                Text('Scan Book'),
                Text('Settings')
              ],
            )
            )

          ],
        ),
      ),
    );
  }
}