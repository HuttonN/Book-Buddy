import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 51, 243, 33)),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Color.fromARGB(92, 216, 243, 245),
        body: Align(  // Align everything at the top
          alignment: Alignment.topCenter,  // Move everything to the top
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,  // Center horizontally
            children: [
              SizedBox(
                width: 500,
                height: 500,
                child: Image.asset('assets/logo_with_words.png'),
              ),
              SizedBox(height: 10),  // Adjust space between the logo and button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 70),  // Width: 200, Height: 70
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),  // Extra padding for button content
                  textStyle: TextStyle(fontSize: 18),  // Font size of the text
                  backgroundColor: Color.fromARGB(255, 216, 238, 245), // Button background color
                  foregroundColor: Colors.black, // Text color
                  shadowColor: Colors.blueAccent, // Shadow color (optional)
                ),
                child: Text('Get Started!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
