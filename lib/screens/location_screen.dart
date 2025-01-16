import 'package:adoptanddonate/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});
  static const String id = 'location-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {});
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
            child: const Text("sign out")),
      ),
    );
  }
}
