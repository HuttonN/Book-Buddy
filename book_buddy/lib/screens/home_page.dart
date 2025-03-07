import 'package:flutter/material.dart';
import 'library.dart';
import 'scan_book.dart';
import 'tbr.dart';
import 'settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  _HomePageState createState() => _HomePageState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Bar',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: HomePage(), 
    );
  }
}


class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; 


  final List<Widget> _pages = [
    HomePage(), 
    Library(), 
    TBR(), 
    Settings(), 
    ScanBook(), 
  ];

 
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFFD9D9D9),
    ),
    
    body: _pages[_selectedIndex],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: const<BottomNavigationBarItem>[

        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Library',
        ),

      BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'TBR',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Scan Book',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),


      ]
    )
  );
}
}




