import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; //required package for authentication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_buddy/screens/home_page2.dart';

// Registration page allowing new users to create an account
class Register extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode; 

  const Register({
    super.key,
    required this.isDarkMode,
    required this.toggleDarkMode,
  });
  

  @override
  State<Register> createState() => _RegisterState();
}

// State class for the Register screen thay forms input controllers and controls firebase 
// operations. 
// Define two TextEditingController instances to be able work with TextFields for email and password
class _RegisterState extends State<Register> {

  late bool _isDarkMode;

  @override
  void initState(){
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  // Controller for form input fields
  final firestore = FirebaseFirestore.instance;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

// registerUser function for registering a new user using Firbase Authentication 
// with email and password (createUserWithEmailAndPassword)
Future<void> registerUser() async {
  // Validates that all fields contain input
  if (firstNameController.text.isEmpty) {
    _showErrorMessage('Please enter your first name.');
    return;
  } else if (surnameController.text.isEmpty) {
    _showErrorMessage('Please enter your surname.');
    return;
  } else if (emailController.text.isEmpty) {
    _showErrorMessage('Please enter your email address.');
    return;
  } else if (passwordController.text.isEmpty) {
    _showErrorMessage('Please enter a password.');
    return;
  } else if (confirmPasswordController.text.isEmpty) {
    _showErrorMessage('Please confirm your password.');
    return;
  } else if (passwordController.text != confirmPasswordController.text) {
    _showErrorMessage('Passwords do not match.');
    return;
  }

  try {
    // Creates a user in Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Generate unique user ID
    String uid = userCredential.user!.uid;

    // Stores user data in Firestore
    await firestore.collection("usersCollection").add({
      "First Name": firstNameController.text,
      "Surname": surnameController.text,
      "Email": emailController.text,
      "uid": uid,
      "Books Read": 0
    });

    // Feedback to show successful registration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Registration successful!"),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 3),
      ),
    );

    // Push to homepage after short delay
    Future.delayed(const Duration(seconds: 2), () {
      print('success');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage2(
            isDarkMode: _isDarkMode,
            toggleDarkMode: widget.toggleDarkMode,
          ),
        ),
      );
    });
  } catch (e) {
    // Handle specific Firebase authentication errors
    String errorMessage = 'An error occurred. Please try again later.';
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email address is already in use. Please use a different email.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak. Please use a stronger password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid. Please enter a valid email.';
          break;
        default:
          errorMessage = 'An error occurred during registration. Please try again.';
          break;
      }
    }
    _showErrorMessage(errorMessage);
    print("Error during registration: $e");
  }
}

// Helper function to show error messages
void _showErrorMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
}


// Simple Widget for registeration
  @override
  Widget build(BuildContext context){
    return Scaffold(

       // App bar.
      appBar: PreferredSize(preferredSize: Size.fromHeight(35), 
      child: AppBar(
        // App bar with consistent styling 
        backgroundColor: Color.fromARGB(255, 223, 245, 252),
        elevation: 5 ,
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 20, 9, 45) 
          ),)),

      backgroundColor: Color.fromARGB(255, 216, 243, 245),
      body: Align(  // Align everything at the top
        alignment: Alignment.topCenter,  // Move everything to the top
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,  // Centre horizontally
          children: [
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child:Image.asset('assets/logo_no_words_light_mode.png'),
                ),
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:  Colors.black,
                  ),
                ),
              ],
            ),
          // Registration form with padding 
          Padding(padding: const EdgeInsets.all(16.0),
            child: Column(
            children: [
              // First name input field
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                labelText: 'First Name',
                filled: true,
                fillColor:Colors.white,
                border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              // Surname input field 
              TextField(
                controller: surnameController,
                decoration: const InputDecoration(
                labelText: 'Surname',
                filled: true,
                fillColor:Colors.white,
                border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),
              
              // Email input field
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor:Colors.white,
                border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              // Password input field 
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor:Colors.white,
                border: OutlineInputBorder(),
                ),
                obscureText: true, 
              ),

              SizedBox(height: 20),

              // Confirm Password input field 
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                labelText: 'Confirm Password',
                filled: true,
                fillColor:Colors.white,
                border: OutlineInputBorder(),
                ),
                obscureText: true, 
              ),

              SizedBox(height: 20),

              ElevatedButton(
              onPressed: registerUser,
              style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),  
                      textStyle: TextStyle(fontSize: 16),  
                      backgroundColor: _isDarkMode ? Colors.white: Colors.black, 
                      foregroundColor: _isDarkMode ? Colors.black: Colors.white,
                      minimumSize: Size(100, 40)
                    ),
              child: Text('Register'),
                 ),
              ],
             ),
            )
          ]
        )
      )
    );
  }
}