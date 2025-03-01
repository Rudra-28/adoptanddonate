import 'package:adoptanddonate/screens/location_screen.dart';
import 'package:adoptanddonate/widgets/authentication/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PhoneAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(BuildContext context, String uid) async {
    //Check if the user exists
    final QuerySnapshot result =
        await users.where('uid', isEqualTo: uid).get();

    List<DocumentSnapshot> document = result.docs;

    if (result.docs.isNotEmpty) {
      Navigator.pushReplacementNamed(context, LocationScreen.id);
    } else {
      return users
          .doc(user!.uid) // Correct method call
          .set({
        'uid': user!.uid, // User ID
        'mobile': user!.phoneNumber, // Mobile number
        'email': user!.email, // Email address
      }).then((value) {
        // Navigate to the next screen
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      }).catchError((error) {
        print("Failed to add user: $error");
        return Future.error(error); // Propagate the error if necessary
      });
    }
    // Add user to Firestore
  }

  Future<void> verifyPhoneNumber(BuildContext context, number) async {
    final PhoneVerificationCompleted;

    verificationCompleted(PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    }

    PhoneVerificationCompleted = verificationCompleted;

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) async {
      if (e.code == 'invalid-phone-number') {
        print("The provided phone number is not valid");
      }
      print('the error is ${e.code}');
    };

    final PhoneCodeSent codeSent = (String verID, int? resendToken)async{
      Navigator.push<void>(
        context,
        MaterialPageRoute(
            builder: (context) => OtpScreen(
                  number: number,
                  verID: verID,
                )),
      );
    };

    try {
      auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          timeout: const Duration(seconds: 60),
          codeAutoRetrievalTimeout: (String verificationId) {
            print(verificationId);
          });
    } catch (e) {
      print('error ${e.toString()}');
    }
  }
}
