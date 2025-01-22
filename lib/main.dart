import 'package:adoptanddonate/screens/home_screen.dart';
import 'package:adoptanddonate/screens/location_screen.dart';
import 'package:adoptanddonate/screens/login_screen.dart';
import 'package:adoptanddonate/screens/splash_screen.dart';
import 'package:adoptanddonate/widgets/authentication/authentication.dart';
import 'package:adoptanddonate/widgets/authentication/otp_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.cyan.shade900,
      ),
      initialRoute:HomeScreen.id,
    routes:  {
                SplashScreen.id:(context)=> const SplashScreen(),
                LoginScreen.id: (context) => const LoginScreen(),
                PhoneAuthScreen.id: (context) => const PhoneAuthScreen(),
                LocationScreen.id: (context) =>  LocationScreen(),
                HomeScreen.id: (context) {
  final locationData = ModalRoute.of(context)!.settings.arguments as LocationData; // Retrieve locationData
  return HomeScreen(locationData: locationData); // Pass it to the HomeScreen constructor
},
                OtpScreen.id: (context) {
                  final args = ModalRoute.of(context)!.settings.arguments
                      as Map<String, String>;
                  return OtpScreen(
                    number: args['number']!,
                    verID: args['verID']!,
                  );
                },
              },
    
     );
     
    
     }
     //FutureBuilder(
    //     future: Future.delayed(const Duration(seconds: 1)),
    //     builder: (context, AsyncSnapshot snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return MaterialApp(
    //             debugShowCheckedModeBanner: false,
    //             theme: ThemeData(
    //               primaryColor: Colors.cyan.shade900,
    //             ),
    //             home: const SplashScreen());
    //       } else {
    //         return MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           theme: ThemeData(
    //             primaryColor: Colors.cyan.shade900,
    //           ),
    //           home: const LoginScreen(),
    //           routes: {
    //             LoginScreen.id: (context) => const LoginScreen(),
    //             PhoneAuthScreen.id: (context) => const PhoneAuthScreen(),
    //             LocationScreen.id: (context) => const LocationScreen(),
    //             OtpScreen.id: (context) {
    //               final args = ModalRoute.of(context)!.settings.arguments
    //                   as Map<String, String>;
    //               return OtpScreen(
    //                 number: args['number']!,
    //                 verID: args['verID']!,
    //               );
    //             },
    //           },
    //         );
    //       }
    //     });
  }
