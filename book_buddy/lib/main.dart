import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          children: [const Text(
            'Hello, Flutter!',
            style: TextStyle(fontSize: 24),
          ),body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             Expanded(child: Image.asset('book_buddy_logo.png'))
          ],
        ),
      ),]
        ),
      ),
    );
  }
}
