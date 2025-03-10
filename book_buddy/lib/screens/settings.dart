import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(92, 216, 243, 245),
      body: Align(  
        alignment: Alignment.topCenter, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center ,
          children: [
            Row(
              children:[
                SizedBox(
                  width: 100,  
                  height: 100,  
                  child: Image.asset('assets/settings_icon.png'),
            ),
            Text('Settings',
                  style: TextStyle(
                    fontSize: 24,  
                    fontWeight: FontWeight.bold,  
                    color: Colors.black, 
                    )),
                ],
            ),
          Container(color: Colors.cyan,
                    width: 500,
                    height: 500,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(color: Colors.red,
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,)
                      ]
                    )
          ),
          ]
        ),
      ),
    );
  }
}



