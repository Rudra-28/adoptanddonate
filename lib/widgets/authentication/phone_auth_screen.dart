import 'package:adoptanddonate_new/screens/services/phoneauth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});
  static const String id = 'phone-auth-screen';

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
   String errorDI = ""; 
  bool validate = false;

  var countryCodeController = TextEditingController(text: '+91');
  var phoneNumberController = TextEditingController();

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text("Please wait"),
        ],
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  final PhoneAuthService _service = PhoneAuthService();

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: "please wait",
      progressIndicatorColor: Theme.of(context).primaryColor,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text("Login", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red.shade200,
              child: const Icon(
                CupertinoIcons.person_alt_circle,
                color: Colors.red,
                size: 60,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              "Enter your Number",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              " We will send confirmation code to your phone number",
              style: TextStyle(color: Colors.grey),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: countryCodeController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 10) {
                        setState(() {
                          validate = true;
                        });
                      }
                      if (value.length < 10) {
                        setState(() {
                          validate = false;
                        });
                      }
                    },
                    autofocus: true,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 18, top: 18),
                        helperMaxLines: 10,
                        labelText: 'Number',
                        hintText: 'Enter your Phone number',
                        hintStyle: TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AbsorbPointer(
            absorbing: validate ? false : true,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: validate
                    ? WidgetStateProperty.all(Theme.of(context).primaryColor)
                    : WidgetStateProperty.all(Colors.grey),
              ),
            
              onPressed: () async {
                progressDialog.show(); 

                String number =
                    '${countryCodeController.text}${phoneNumberController.text}';
                print(number);

                try {
                  await _service.verifyPhoneNumber(context, number);// Verification successful
                  setState(() {
                    validate = true;
                  });
                  // Navigate to the next screen or perform other actions
                } on FirebaseAuthException catch (e) {
                  // Handle Firebase errors
                  print('Failed with error code: ${e.code}');
                  print(e.message);
                  setState(() {
                    errorDI = e.message ??
                        "Verification failed."; // Update error message
                    validate = false; // Update button state
                  });
                  // Show an error message to the user (e.g., using a SnackBar)
                } catch (e) {
                  // Handle other errors
                  print('Error during phone verification: $e');
                  setState(() {
                    errorDI = "Verification failed."; // Update error message
                    validate = false; // Update button state
                  });
                  // Show an error message to the user
                } finally {
                  progressDialog.dismiss(); // Dismiss the dialog in any case
                }
              },
              child: const Padding(
                // Added child property
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Next",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
