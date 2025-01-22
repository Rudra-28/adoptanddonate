import 'package:adoptanddonate/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:location_geocoder/location_geocoder.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";
  final LocationData locationData;
  const HomeScreen({super.key, required this.locationData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = "India";
Future<String> getAddress() async {
  const _apiKey = 'YOUR_MAP_API_KEY'; // Replace with your actual API key
  final LocatitonGeocoder geocoder =  LocatitonGeocoder(_apiKey);

  try {
    // Replace coordinates with actual latitude and longitude values
    final address = await geocoder.findAddressesFromCoordinates(
      Coordinates(widget.locationData.latitude, widget.locationData.longitude),
    );

    // Extract and return the first address line
    if (address.isNotEmpty) {
      return address.first.addressLine ?? 'No address found';
    } else {
      return 'No address found';
    }
  } catch (e) {
    print('Error while fetching address: $e');
    return 'Error while fetching address';
  }
}


  @override
  void initState() {
    getAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: InkWell(
          onTap: (){},
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.location_solid,
                  color: Colors.black,
                  size: 18,
                ),
                Flexible(
                  child: Text(
                    address,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color:Colors.black,size: 18,),
              ],
            ),
          ),
        ),
      ),
      body: ElevatedButton(onPressed: (){
        FirebaseAuth.instance.signOut().then((value){
          Navigator.pushReplacement(context, LoginScreen.id as Route<Object?>);
        });
      }, child: Text("Sign Out")),
    );
  }
}
