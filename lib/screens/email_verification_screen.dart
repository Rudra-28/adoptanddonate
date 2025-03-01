// import 'package:adoptanddonate/screens/location_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:open_mail_app/open_mail_app.dart';

// class EmailVerificationScreen extends StatelessWidget {
//   static const String id='email-verification-screen';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Verify Your Email')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Icon(Icons.email, size: 100, color: Colors.blue),
//             const SizedBox(height: 20),
//             const Text(
//               'A verification email has been sent to your email address. Please check your inbox and verify your email.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),

//             ElevatedButton(onPressed: () async {
//                  var result = await OpenMailApp.openMailApp();

//         // If no mail apps found, show error
//         if (!result.didOpen && !result.canOpen) {
//           showNoMailAppsDialog(context);

//           // iOS: if multiple mail apps found, show dialog to select.
//           // There is no native intent/default app system in iOS so
//           // you have to do it yourself.
//         } else if (!result.didOpen && result.canOpen) {
//           showDialog(
//             context: context,
//             builder: (_) {
//               return MailAppPickerDialog(
//                 mailApps: result.options,
//               );
//             },
//           );
//         }
//         Navigator.pushReplacementNamed(context,LocationScreen.id);
//             }, child: const Text("Verify Email"),),
//             SizedBox(height: 20),


//             ElevatedButton(
//               onPressed: () {},
//               child: Text('Resend Verification Email'),
//             ),
//             SizedBox(height: 10),

//           ],
//         ),
//       ),
//     );
//   }
//    void showNoMailAppsDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Open Mail App"),
//           content: Text("No mail apps installed"),
//           actions: <Widget>[
//             ElevatedButton(
//               child: Text("OK"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:adoptanddonate/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class EmailVerificationScreen extends StatelessWidget {
  static const String id = 'email-verification-screen';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Your Email')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'A verification email has been sent to your email address. Please check your inbox and verify your email.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, LocationScreen.id);
              },
              child: const Text("Verify Email"),
            ),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {},
              child: const Text('Resend Verification Email'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}