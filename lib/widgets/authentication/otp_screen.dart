import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  final String? number;
  const OtpScreen({super.key, this.number});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red.shade900,
              child: Icon(
                CupertinoIcons.person_alt_circle,
                size: 50,
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "welcome back ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        text: 'we have a sent a 6 digit code',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                              text: widget.number,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 12,
                              )),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.edit),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
