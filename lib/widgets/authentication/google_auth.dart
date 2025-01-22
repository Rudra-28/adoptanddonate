import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {

  static SnackBar customSnackBar({required String content}){
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(content, style: const TextStyle(
        color: Colors.redAccent, letterSpacing: 0.5
      ),),
    );
  }
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    // Trigger the Google Sign-In flow
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Obtain the Google authentication details
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Create a new credential using Google authentication details
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        // Sign in to Firebase with the Google credential
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content: 'account-exists-with-different-credential',
              ),
            );
          // Handle the case where the user is trying to sign in
          // with a different account credential
          print('The account already exists with a different credential.');
        } else if (e.code == 'invalid-credential') {
           ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content: 'invalid-credential',
              ),
            );
          // Handle the error when the credential is invalid
          print('The credential is invalid.');
        }
      } catch (e) {
        // Handle any other error
       ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content: 'login-failed',
              ),
            );
      }
    }

    return user;
  }

  static Future<void> signOutGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      print("User signed out from Google account");
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
