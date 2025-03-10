import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; //required package for authentication

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

// Define two TextEditingController instances to be able work with TextFields for email and password
class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

// registerUser function for registering a new user using Firbase Authentication with email and password (createUserWithEmailAndPassword)
  Future<void> registerUser() async {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(), // trim() used to remove leading and trailling whitespace
        password: passwordController.text.trim() // see line above
        ); // Need to add action for when user is registered. Currently nothing indicates that user is registered but they have been added to Firebase
  }
// ADD SOME ERROR HANDLING HERE? email already in use, email format incorrect (no '@'), password not sophisticated enough, no password and/or email entered

// Simple Widget for registeration
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              ElevatedButton(
                onPressed: registerUser, //runs registerUser function above when clicked
                child: const Text("Register"),
              )
            ],
          ),
        ),      
      );
  }
}