import 'dart:async';

import 'package:adoptanddonate_new/screens/location_screen.dart';
import 'package:adoptanddonate_new/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String id='splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  
  void initstate(){
    Timer(Duration (
    seconds:3),
    (){
      FirebaseAuth.instance.authStateChanges().listen((User? user){
        if(user==null){
          //not signed 
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        }else{
          //signed in 
         // Navigator.pushReplacementNamed(context, LocationScreen.id);
        }
      });
    });
    super.initState(); 
  }
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Loading"),),
    );
  }
}