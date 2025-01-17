import 'package:adoptanddonate/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});
  static const String id = 'location-screen';

  //getLocation();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Image.asset('lib/assets/images/location_img.jpg'),
        const SizedBox(
          height: 29,
        ),
        const Text(
          "Where do you want to adopt/donate an animal",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        const SizedBox(
          height: 29,
        ),
        const Text(
            "To know where you are looking for the pets we need to know your location"),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.location_fill, size: 40,),
                  label: const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Text("Around me",
                    textAlign: TextAlign.center,
                     style: TextStyle(fontSize: 25, color: Colors.white),),
                  ),
                ),
              ),
            ],
          ),
        ),
        TextButton(
            onPressed: () {
              //getLocation();
            },
            child: const Text(
              "set location manually",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            )),
      ],
    ));
  }
}
