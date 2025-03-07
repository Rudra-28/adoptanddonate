import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAdScreen extends StatelessWidget {
  const MyAdScreen({super.key});

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("My Ads", style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
      ),
    );
  }
}