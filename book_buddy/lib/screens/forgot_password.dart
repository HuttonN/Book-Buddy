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
      appBar: AppBar(
        backgroundColor: widget.isDarkMode
            ? Color.fromARGB(255, 20, 9, 45)
            : Color.fromARGB(255, 223, 245, 252),
        iconTheme: IconThemeData(
            color: widget.isDarkMode
                ? Colors.white
                : Color.fromARGB(255, 20, 9, 45)),
        title: Text(
          'Forgot Password',
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      backgroundColor: widget.isDarkMode
       ? Color.fromARGB(255, 20, 9, 45)
       : Color.fromARGB(255, 223, 245, 252),
body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                filled: true,
                fillColor: widget.isDarkMode ? Colors.grey : Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendResetEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.isDarkMode ? Colors.white : Colors.black,
                foregroundColor:
                    widget.isDarkMode ? Colors.black : Colors.white,
              ),
              child: Text('Send Reset Link'),
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}