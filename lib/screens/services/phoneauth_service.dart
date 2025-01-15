import 'package:adoptanddonate/widgets/authentication/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PhoneAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(BuildContext context, number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) async {
      if (e.code == 'invalid-phone-number') {
        print("The provided phone number is not valid");
      }
      print('the error is ${e.code}');
    };

    final PhoneCodeSent codeSent = (String verID, int? resendToken) {
  Navigator.push<void>(
    context,
    MaterialPageRoute(builder: (context) => OtpScreen(number: number)),
  );
};

try{
  auth.verifyPhoneNumber(
    phoneNumber: number,
  verificationCompleted: verificationCompleted,
  verificationFailed: verificationFailed, 
  codeSent: codeSent,
  timeout: const Duration(seconds: 60),
  codeAutoRetrievalTimeout: (String verificationId){
    print(verificationId);
  });
}catch(e){
  print('error ${e.toString()}');
}

  }
}
