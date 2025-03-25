import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget{
  final bool isDarkMode;

  const ForgotPassword({super.key, required this.isDarkMode});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  String message = '';

  Future<void> sendResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      setState(() {
        message = 'A reset link has been sent to your email.';
      });
    } catch (e) {
      setState(() {
        message = 'Error: ${e.toString()}';
      });
    }
  }

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
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:  Colors.black,
                  ),
                ),
              ],
            ),

            Padding(padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Enter the email linked to your account, and you will be emailed a link to reset your password!'),

                  SizedBox(height: 20),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter your email',
                      filled: true,
                      fillColor: widget.isDarkMode 
                        ? Colors.grey 
                        : Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: sendResetEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                        widget.isDarkMode 
                          ? Colors.white 
                          : Colors.black,
                      foregroundColor:
                        widget.isDarkMode 
                          ? Colors.black 
                          : Colors.white,
                    ),
                  child: Text('Send Reset Link'),
                  ),

                  SizedBox(height: 20),

                  Text(
                    message,
                    style: TextStyle(
                      color: widget.isDarkMode 
                        ? Colors.white 
                        : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
            
                ],
              )
            )
            
          ]
        )
      )
    );
  }
}