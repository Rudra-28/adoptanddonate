import 'package:adoptanddonate_new/screens/location_screen.dart';
import 'package:adoptanddonate_new/widgets/authentication/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PhoneAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

 Future<void> addUser(BuildContext context, String uid, String? phoneNumber, String? email) async {
  print('addUser function called with UID: $uid');
  // Check if the user exists
  final QuerySnapshot result = await users.where('uid', isEqualTo: uid).get();

  List <DocumentSnapshot> document = result.docs;

  if (result.docs.isNotEmpty) {
    Navigator.pushReplacementNamed(context, LocationScreen.id);
  } else {
    return users
        .doc(uid) // Use the passed-in uid
        .set({
      'uid': uid, // Use the passed-in uid
      'mobile': phoneNumber, // Use the passed-in phoneNumber
      'email': email,
      'name':null,
      'address':"address",
    }).then((value) {
      // Navigate to the next screen
      Navigator.pushReplacementNamed(context, LocationScreen.id);
    }).catchError((error) {
      print("Failed to add user: $error");
      return Future.error(error); // Propagate the error if necessary
    });
  }
 
}

  Future<void> verifyPhoneNumber(BuildContext context, number) async {
    final FirebaseAuth auth =
        FirebaseAuth.instance;

    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      throw e; 
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print('Auto retrieval timeout: $verificationId');
      // Add your timeout handling logic here if needed
    };

    final PhoneCodeSent codeSent = (String verID, int? resendToken) async {
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
      await auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      // Handle Firebase-specific errors here
      // e.g., update errorDI and show a SnackBar
    } catch (e) {
      print('Error during phone verification: $e');
      // Handle other errors here
    }
  }
}
