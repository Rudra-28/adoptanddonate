import 'package:adoptanddonate/widgets/auth_ui.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const String id= 'login-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  // Image.asset('android/assets/images/logo.png'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "PawPal",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan.shade900,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: const AuthUi(),
            ),
          )
        ],
      ),
    );
  }
}
