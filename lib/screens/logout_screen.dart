import 'package:adoptanddonate_new/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});
    static const String id = 'log-out';

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    } catch (e) {
    
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
      print('Error logging out: $e'); // Log the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Are you sure you want to logout?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Logout'),
            ),
            const SizedBox(height: 10),
            TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("Cancel")),
          ],
        ),
      ),
    );
  }
}
