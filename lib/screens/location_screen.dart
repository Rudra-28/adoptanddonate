// import 'package:adoptanddonate/screens/home_screen.dart';
// import 'package:adoptanddonate/screens/services/firebase_service.dart';
import 'package:adoptanddonate_new/screens/home_screen.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location_geocoder/geocoder.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location-screen';

  

  const LocationScreen({super.key});

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  Location location = Location();
  late final bool locationChanging;

  FirebaseService _service = FirebaseService();

  bool loading = false;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;
  String? _address;

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String manualAddress = "";

  Future<LocationData> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permissions are denied.');
      }
    }

    print(_locationData);

    _locationData = await location.getLocation();

    // Future<String> getAddressFromCoordinates(
    //     double latitude, double longitude) async {
    //   try {
    //     List<Placemark> placemarks =
    //         await placemarkFromCoordinates(latitude, longitude);
    //     if (placemarks.isNotEmpty) {
    //       Placemark place = placemarks[0];
    //       String address =
    //           '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    //       return address;
    //     } else {
    //       return 'Address not found';
    //     }
    //   } catch (e) {
    //     print('Error getting address: $e');
    //     return 'Error getting address';
    //   }
    // }

    return _locationData!;
  }

  late ProgressDialog progressDialog = ProgressDialog(
    context: context,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    loadingText: "Fetching location",
    progressIndicatorColor: Theme.of(context).primaryColor,
  );

  @override
  Widget build(BuildContext context) {

    // if(widget.locationChanging==null){

    // }else{
    //   print("location not changinf");
    // }



   // showBottomScreen(BuildContext context) {
      // getLocation().then((location) {
      //   if (location != null) {
      //     progressDialog.dismiss();
      //     showModalBottomSheet(
      //         isScrollControlled: true,
      //         enableDrag: true,
      //         context: context,
      //         builder: (context) {
      //           getLocation().then((location) {
      //             progressDialog.dismiss();
      //             showModalBottomSheet(
      //               isScrollControlled: true,
      //               enableDrag: true,
      //               context: context,
      //               builder: (context) {
      //                 return Column(
      //                   children: [
      //                     SizedBox(
      //                       height: 26,
      //                     ),
      //                     AppBar(
      //                       automaticallyImplyLeading: false,
      //                       iconTheme: const IconThemeData(
      //                         color: Colors.black,
      //                       ),
      //                       // automaticallyImplyLeading: false,
      //                       //iconTheme: const IconThemeData(color: Colors.black),
      //                       elevation: 1,
      //                       backgroundColor: Colors.white,
      //                       title: Row(
      //                         children: [
      //                           IconButton(
      //                             onPressed: () {
      //                               Navigator.pop(context);
      //                             },
      //                             icon: const Icon(
      //                               Icons.clear,
      //                             ),
      //                           ),
      //                           const SizedBox(
      //                             width: 10,
      //                           ),
      //                           const Text(
      //                             'location',
      //                             style: TextStyle(color: Colors.black),
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Container(
      //                         decoration: BoxDecoration(
      //                           border: Border.all(),
      //                           borderRadius: BorderRadius.circular(6),
      //                         ),
      //                         child: SizedBox(
      //                           height: 40,
      //                           child: TextFormField(
      //                             decoration: InputDecoration(
      //                               hintText:
      //                                   'Search City, area or neighborhood',
      //                               hintStyle: TextStyle(color: Colors.grey),
      //                               icon: Icon(Icons.search),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     ListTile(
      //                       onTap: () {},
      //                       horizontalTitleGap: 0.0,
      //                       leading: Icon(
      //                         Icons.my_location,
      //                         color: Colors.blue,
      //                       ),
      //                       title: Text(
      //                         "use current location",
      //                         style: TextStyle(
      //                             color: Colors.blue,
      //                             fontWeight: FontWeight.bold),
      //                       ),
      //                       subtitle: Text(
      //                         location == null ? 'Enable location' : _address!,
      //                         style: TextStyle(fontSize: 12),
      //                       ),
      //                     ),
      //                     Container(
      //                       width: MediaQuery.of(context).size.width,
      //                       color: Colors.grey.shade300,
      //                       child: Padding(
      //                         padding: const EdgeInsets.only(
      //                             left: 10, bottom: 4, top: 4),
      //                         child: Text(
      //                           "CHOOSE CITY",
      //                           style: TextStyle(
      //                             color: Colors.blueGrey.shade100,
      //                             fontSize: 12,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      //                       child: CSCPicker(
      //                         //defaultCountry: DefaultCountry.India,
      //                         layout: Layout.vertical,
      //                         dropdownDecoration: BoxDecoration(
      //                           shape: BoxShape.rectangle,
      //                         ),

      //                         onCountryChanged: (value) {
      //                           setState(() {
      //                             countryValue = value;
      //                           });
      //                         },
      //                         onStateChanged: (value) {
      //                           setState(() {
      //                             stateValue = value!;
      //                           });
      //                         },
      //                         onCityChanged: (value) {
      //                           setState(
      //                             () {
      //                               setState(() {
      //                                 cityValue = value!;
      //                                 _address =
      //                                     '$cityValue, $stateValue, ${countryValue}';
      //                               });

      //                               print(Address);
      //                               _service.updateUser({}, () {
      //                                 // Pass a callback
      //                                 if (mounted) {
      //                                   Navigator.pushNamed(
      //                                       context, HomeScreen.id);
      //                                 }
      //                               });
      //                             },
      //                           );
      //                           debugPrint(_address);
      //                         },
      //                       ),
      //                     ),
      //                   ],
      //                 );
      //               },
      //             );
      //           });
      //         });
      //   } else {
      //     progressDialog.dismiss();
      //   }
      // });
    //}

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Image.asset('lib/assets/images/location.jpg'),
          const SizedBox(height: 29),
          const Text(
            "Where do you want to adopt/donate an animal",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          const SizedBox(height: 29),
          const Text(
              "To know where you are looking for the pets, we need to know your location"),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        )
                      : ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          onPressed: () async {
                            print(_locationData?.longitude);
                            setState(() {
                              loading = true;
                            });
                            try {
                              LocationData value = await getLocation();
                              if (value != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen(locationData: value),
                                  ),
                                );
                              }
                            } catch (e) {
                              print(e);
                            } finally {
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          icon: const Icon(CupertinoIcons.location_fill,
                              size: 40),
                          label: const Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Text(
                              "Around me",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              progressDialog.show();
             // showBottomScreen(context);
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(border: Border(bottom: BorderSide(width: 8))),
                child: Text(
                  "Set location manually",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
