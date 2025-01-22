import 'package:adoptanddonate/screens/home_screen.dart';
import 'package:adoptanddonate/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});
static const String id = 'location-screen';

  Location location = Location();
  bool loading=false;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? locationData;

 Future<LocationData> getLocation() async {
  // Check if location services are enabled
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
  }

  // Check location permissions
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      throw Exception('Location permissions are denied.');
    }
  }

  // Get location data
  locationData = await location.getLocation();
  return locationData!;
}


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
                child: loading ? Center(child:CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                )):ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    setState(){
                      loading=true;
                    }
                    getLocation().then((value){
                      print(locationData?.latitude);
                      if(value!=null){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context)=> HomeScreen(locationData: locationData!)));
                      }
                    });
                  },
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
