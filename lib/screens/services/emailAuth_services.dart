import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailauthServices {
  CollectionReference users= FirebaseFirestore.instance.collection('users');

 Future<DocumentSnapshot> getAdminCredential({
  required BuildContext context,
  required String email,
  required String password,
  required bool isLog,
}) async {
  DocumentSnapshot result = await users.doc(email).get();

  if (isLog) {
    emailLogin(email, password, context); // Assuming emailLogin now accepts context
  } else {
    if (result.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("an account already created")), // Added closing parenthesis
      );
    } else {
      emailRegister(email, password);
    }
  }
  return result; // Add a return statement if you intend to return the DocumentSnapshot
}

Future<void> emailLogin(String email, String password, BuildContext context) async {
  // Login with the existing email
  try {
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, // Use the provided email parameter
      password: password, // Use the provided password parameter
    );
    print('User created successfully: ${userCredential.user}');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    } else {
      print('Error creating user: $e'); // Use $e to print the exception object
    }
  }
}
  emailRegister(email, password){
    //register as a new email
  }
}