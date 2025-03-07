import 'package:adoptanddonate_new/forms/donor_cat_form.dart';
import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:adoptanddonate_new/screens/categories/category_list.dart';
import 'package:adoptanddonate_new/screens/categories/subcat_screen.dart';
import 'package:adoptanddonate_new/screens/donateanimal/donor_cat.dart';
import 'package:adoptanddonate_new/screens/donateanimal/donor_subcat.dart';
import 'package:adoptanddonate_new/screens/email_verification_screen.dart';
import 'package:adoptanddonate_new/screens/home_screen.dart';
import 'package:adoptanddonate_new/screens/location_screen.dart';
import 'package:adoptanddonate_new/screens/login_screen.dart';
import 'package:adoptanddonate_new/screens/main_screen.dart';
import 'package:adoptanddonate_new/screens/splash_screen.dart';
import 'package:adoptanddonate_new/widgets/authentication/phone_auth_screen.dart';
import 'package:adoptanddonate_new/widgets/authentication/email_auth_screen.dart';
import 'package:adoptanddonate_new/widgets/authentication/otp_screen.dart';
import 'package:adoptanddonate_new/widgets/authentication/reset_password_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => CategoryProvider()),
    ],
    child: const MyApp(),
  ));
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
      initialRoute: LoginScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
        EmailVerificationScreen.id: (context) => EmailVerificationScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        PhoneAuthScreen.id: (context) => const PhoneAuthScreen(),
        LocationScreen.id: (context) => const LocationScreen(),
        EmailAuthScreen.id: (context) => const EmailAuthScreen(),
        CategoryListScreen.id: (context) => const CategoryListScreen(),
        SubCatList.id: (context) => const SubCatList(),
        MainScreen.id: (context) => const MainScreen(),
        // DonorCategory.id: (context) => const DonorCategory(),
        DonorSubCat.id: (context) => const DonorSubCat(),
        DonorCatForm.id: (context) => DonorCatForm(),
        HomeScreen.id: (context) => HomeScreen(
              locationData: LocationData.fromMap({
                'latitude': 0.0,
                'longitude': 0.0,
                // ... other initial values
              }),
            ),
        OtpScreen.id: (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
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
