import 'package:adoptanddonate_new/screens/services/phoneauth_service.dart';
import 'package:adoptanddonate_new/widgets/authentication/email_auth_screen.dart';
import 'package:adoptanddonate_new/widgets/authentication/google_auth.dart';
import 'package:adoptanddonate_new/widgets/authentication/phone_auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthUi extends StatelessWidget {
  const AuthUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 220,
            child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, PhoneAuthScreen.id);
                },
                child: Row(
                  children: [
                    const Icon(Icons.phone_android_outlined),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("Continue with Phone",
                        style: TextStyle(color: Colors.cyan.shade900)),
                  ],
                )),
          ),
          SignInButton(
            Buttons.Google,
            text: "Continue with Google",
            onPressed: () async {
              User? user =
                  await GoogleAuthentication.signInWithGoogle(context: context);

              if (user != null) {
                PhoneAuthService _authentication =
                    PhoneAuthService(); // Renamed variable

                // Get phone number and email from the user object
                String? phoneNumber = user.phoneNumber;
                String? email = user.email;

                // Call addUser with all four arguments
                _authentication.addUser(context, user.uid, phoneNumber, email);
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "OR",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, EmailAuthScreen.id);
            },
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white))),
              child: const Text(
                "Login with Email",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
