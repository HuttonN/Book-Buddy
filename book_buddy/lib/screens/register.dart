import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; //required package for authentication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_buddy/screens/home_page2.dart';


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

// Define two TextEditingController instances to be able work with TextFields for email and password
class _RegisterState extends State<Register> {

  late bool _isDarkMode;

  @override
  void initState(){
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  final firestore = FirebaseFirestore.instance;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

// registerUser function for registering a new user using Firbase Authentication with email and password (createUserWithEmailAndPassword)
  Future<void> registerUser() async {
    if (firstNameController.text.isNotEmpty &&
        surnameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(), // trim() used to remove leading and trailling whitespace
          password: passwordController.text.trim() // see line above
        );
        
        String uid = userCredential.user!.uid;

        await firestore.collection("usersCollection").add({
            "First Name": firstNameController.text,
            "Surname": surnameController.text,
            "Email": emailController.text,
            "uid": uid,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Registration successful!"),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 3),
            ),
          );

          Future.delayed(const Duration(seconds: 2), () {
          print('success');
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => HomePage2(
                      isDarkMode: _isDarkMode, 
                      toggleDarkMode: widget.toggleDarkMode
                    ))
          );
          });

        } catch (e) {
          print("Error during registration: $e");
        } // Need to add action for when user is registered. Currently nothing indicates that user is registered but they have been added to Firebase
      }
  }
// ADD SOME ERROR HANDLING HERE? email already in use, email format incorrect (no '@'), password not sophisticated enough, no password and/or email entered

// Simple Widget for registeration
  @override
  Widget build(BuildContext context){
    return Scaffold(

       // App bar.
      appBar: PreferredSize(preferredSize: Size.fromHeight(35), 
      child: AppBar(
        backgroundColor: Color.fromARGB(255, 223, 245, 252),
        elevation: 5 ,
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 20, 9, 45) 
          ),)),

      backgroundColor: Color.fromARGB(255, 216, 243, 245),
      body: Align(  // Align everything at the top
        alignment: Alignment.topCenter,  // Move everything to the top
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,  // Center horizontally
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
          Padding(padding: const EdgeInsets.all(16.0),
            child: Column(
            children: [

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

              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor:Colors.white,
                border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              // TextField(
              //   controller: firstNameController,
              //   decoration: const InputDecoration(labelText: 'First Name'),
              // ),
              // TextField(
              //   controller: surnameController,
              //   decoration: const InputDecoration(labelText: 'Surname'),
              // ),
              // TextField(
              //   controller: emailController,
              //   decoration: const InputDecoration(labelText: 'Email'),
              // ),
              // TextField(
              //   controller: passwordController,
              //   decoration: const InputDecoration(labelText: 'Password'),
              //   obscureText: true,
              // ),
              // ElevatedButton(
              //   onPressed: registerUser, //runs registerUser function above when clicked
              //   child: const Text("Register"),
              // )

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