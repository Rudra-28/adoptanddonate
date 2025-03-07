import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("chat screen", style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
      ),
    );
  }
}