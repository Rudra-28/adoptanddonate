import 'package:adoptanddonate/widgets/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

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
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white)),
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
            text: "Sign up with Google",
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "OR",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Login with Email",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          )
        ],
      ),
    );
  }
}
