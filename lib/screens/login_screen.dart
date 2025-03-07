import 'package:adoptanddonate_new/screens/location_screen.dart';
import 'package:adoptanddonate_new/widgets/auth_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {  
  const LoginScreen({super.key});
  static const String id = 'login-screen';

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("user is currently signed out");
      } else {
        //if already logged in it will not again ask for login 
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      }
    });

    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "PawPal",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan.shade900,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: const AuthUi(),
            ),
          )
        ],
      ),
    );
  }
}
