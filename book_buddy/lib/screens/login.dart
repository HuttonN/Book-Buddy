import 'package:flutter/material.dart';
import 'package:book_buddy/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:book_buddy/screens/home_page2.dart';
import 'package:book_buddy/screens/forgot_password.dart';

class Login extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode; 

   const Login({
    required this.isDarkMode,
    required this.toggleDarkMode,
    super.key,
   });

   @override 
   _LoginState createState() => _LoginState();
}



// Define two TextEditingController instances to be able work with TextFields for email and password
class _LoginState extends State<Login> {

  late bool _isDarkMode;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), // trim() used to remove leading and trailling whitespace
        password: passwordController.text.trim() // see line above
        ); 

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 2),
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
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'INVALID_LOGIN_CREDENTIALS'){
        message = 'Invalid login credentials.';
      } else if (e.code == 'user-not-found'){
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password'){
        message = 'Incorrect password.';
      } else {
        message = 'Login failed: ${e.message}';
      }
      
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

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
        )
      ),
      backgroundColor: _isDarkMode ? Color.fromARGB(255, 20, 9, 45) : Color.fromARGB(255, 216, 243, 245),
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
                  child: _isDarkMode ? Image.asset('assets/logo_no_words_dark_mode.png'): Image.asset('assets/logo_no_words_light_mode.png'),
                ),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            // Add in the logo.
            
            // Add space between the logo and the button.
            SizedBox(height: 10),  

            Container(
              width: 200,
              height: 274,
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.black : Color.fromARGB(255, 223, 245, 252),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 216, 238, 245),  // Border color
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
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Add space
                  SizedBox(height: 30),

                  TextField(
                    controller: emailController,
                    decoration: 
                       InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            fillColor: _isDarkMode ? Colors.grey: Colors.white,
                            filled: true
                      )
                  ),

                  // Add space
                  SizedBox(height: 30),

                  TextField(
                    controller: passwordController,
                    decoration: 
                       InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            fillColor: _isDarkMode ? Colors.grey: Colors.white,
                            filled: true
                      ),
                      obscureText: true,
                  ),

                  // Add space
                  SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                            ForgotPassword(isDarkMode: _isDarkMode),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: _isDarkMode? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  // Add space
                  SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),  
                      textStyle: TextStyle(fontSize: 16),  
                      backgroundColor: _isDarkMode ? Colors.white: Colors.black, 
                      foregroundColor: _isDarkMode ? Colors.black: Colors.white,
                      minimumSize: Size(100, 40)
                    ),
                    child: Text('Sign In'),
                  ),

                  // Add space
                  SizedBox(height: 30)
                ],
              ),
            ),

           SizedBox(height: 30),

           Text("Or"),

           SizedBox(height: 30),


            ElevatedButton(
              onPressed: () {
                // Navigate to the Login page when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),  // Navigate to LoginPage
                );
              },
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
      ),
    );
  }
}


