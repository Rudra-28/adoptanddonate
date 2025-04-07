import 'package:adoptanddonate_new/screens/home_screen.dart';
import 'package:adoptanddonate_new/screens/main_screen.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location-screen';
  
  final dynamic locationChanging;

 
  const LocationScreen({super.key, required this.locationChanging}); // Update constructor
  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  loc.Location location = loc.Location();
   FirebaseService _service = FirebaseService();

  late final bool locationChanging=true;

  bool loading = false;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;
  String? _address;

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String manualAddress = "";


  Future<LocationData?> getLocation() async {
    try {
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

      _locationData = await location.getLocation();

      if (_locationData != null) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            _locationData!.latitude!,
            _locationData!.longitude!,
          );

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks.first;
            setState(() {
              _address =
                  "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
            });
            debugPrint("Current Address: $_address");
          }
        } catch (e) {
          // Handle potential errors in reverse geocoding
          print("Error during reverse geocoding: $e");
          // You might want to set a default address or show an error message.
        }
        return _locationData; // Return the LocationData
      } else {
        // Handle the case where _locationData is null
        print("Location data is null!");
        return null; // Explicitly return null
      }
    } catch (e) {
      // Handle exceptions related to service or permissions
      print("Error getting location: $e");
      return null; // Return null in case of an error
    }
  }

  late ProgressDialog progressDialog = ProgressDialog(
    context: context,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    loadingText: "Fetching location",
    progressIndicatorColor: Theme.of(context).primaryColor,
  );
  void _navigateToManualLocationPage() async {
    progressDialog.show();
    try {
      final locationData = await getLocation();
      progressDialog.dismiss();

      if (locationData != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManualLocationPage(
              locationData: locationData,
              onAddressChanged: (address) {
                setState(() {
                  _address = address;
                });
              },
              getLocation: getLocation, // Pass the function here
            ),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Could not retrieve location. Please try again."),
            ),
          );
        }
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        progressDialog.dismiss();
      }
    }
  }
  @override
void initState() {
  super.initState();
  _checkUserAddress(); // Move the navigation logic to initState()
}

void _checkUserAddress() {
  if (widget.locationChanging == true) {
    _service.users.doc(_service.user!.uid).get().then((DocumentSnapshot document) {
      if (document.exists) {
        if (document["address"] != null) {
          print("Entering main screen");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, MainScreen.id);
          });
        } else {
          print("Address not found, redirecting to LocationScreen");
        }
      } else {
        print("Document does not exist, redirecting to LocationScreen");
      }
    });
  } else {
    print("locationChanging is false or null, redirecting to MainScreen");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, MainScreen.id);
    });
  }
}

// ... rest of your LocationScreenState class

  @override
  Widget build(BuildContext context) {



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
                              loc.LocationData? value = await getLocation();
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
            onTap: _navigateToManualLocationPage,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(border: Border(bottom: BorderSide(width: 2))),
                child: Text(
                  "Set location manually",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
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

class ManualLocationPage extends StatefulWidget {
  final LocationData locationData;
  final Function(String) onAddressChanged;
  final Future<LocationData?> Function() getLocation; // Passed function

  ManualLocationPage({
    required this.locationData,
    required this.onAddressChanged,
    required this.getLocation,
  });

  @override
  _ManualLocationPageState createState() => _ManualLocationPageState();
}

class _ManualLocationPageState extends State<ManualLocationPage> {
  LocationData? location;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String _address = "";
  FirebaseService _service = FirebaseService(); // You might need this

  @override
  void initState() {
    super.initState();
    location = widget.locationData;
  }

  // Separate function for updating location and navigating
  void _updateUserLocationAndNavigate(
      BuildContext context, Map<String, dynamic> userData) {
    try {
      _service.updateUser(
        context,
        userData,
        () {
          if (mounted) {
            Navigator.pushNamed(context, HomeScreen.id);
          }
        },
      );
    } catch (e) {
      print("Error updating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update location: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Location Manually'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Search City, area or neighborhood',
                      hintStyle: TextStyle(color: Colors.grey),
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                setState(() {
                  location = null;
                  _address = '';
                });

                final locationData = await widget.getLocation();

                if (locationData != null) {
                  try {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      locationData.latitude!,
                      locationData.longitude!,
                    );

                    if (placemarks.isNotEmpty) {
                      Placemark place = placemarks.first;
                      String fullAddress =
                          "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
                      setState(() {
                        location = locationData;
                        _address = fullAddress;
                      });
                      widget.onAddressChanged(fullAddress);

                      // Update Firestore and navigate
                      Map<String, dynamic> userData = {
                        'address': _address,
                        'location': GeoPoint(
                            locationData.latitude!, locationData.longitude!),
                      };
                      _updateUserLocationAndNavigate(
                          context, userData); // Call the function here
                    } else {
                      setState(() {
                        location = locationData;
                        _address =
                            "${locationData.latitude}, ${locationData.longitude}";
                      });
                      widget.onAddressChanged(
                          "${locationData.latitude}, ${locationData.longitude}");
                      // Update Firestore and navigate
                      Map<String, dynamic> userData = {
                        'address': _address,
                        'location': GeoPoint(
                            locationData.latitude!, locationData.longitude!),
                      };
                      _updateUserLocationAndNavigate(
                          context, userData); // Call the function here

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("No address found for these coordinates."),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    setState(() {
                      location = locationData;
                      _address =
                          "${locationData.latitude}, ${locationData.longitude}";
                    });
                    widget.onAddressChanged(
                        "${locationData.latitude}, ${locationData.longitude}");
                    // Update Firestore and navigate
                    Map<String, dynamic> userData = {
                      'address': _address,
                      'location': GeoPoint(
                          locationData.latitude!, locationData.longitude!),
                    };
                    _updateUserLocationAndNavigate(
                        context, userData); // Call the function here

                    print("Error fetching address: $e");
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error fetching address."),
                        ),
                      );
                    }
                  }
                } else {
                  setState(() {
                    location = null;
                    _address = "Could not get location";
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Could not get location. Please try again."),
                      ),
                    );
                  }
                }
              },
              horizontalTitleGap: 0.0,
              leading: const Icon(
                Icons.my_location,
                color: Colors.blue,
              ),
              title: const Text(
                "Use current location",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                location == null ? 'Fetching location' : _address,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.shade300,
              child: const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 4, top: 4),
                child: Text(
                  "CHOOSE CITY",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (countryValue.isNotEmpty)
                    Text(
                      'Country: $countryValue   ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (stateValue.isNotEmpty)
                    Text(
                      'State: $stateValue   ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (cityValue.isNotEmpty)
                    Text(
                      'City: $cityValue',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: CSCPicker(
                layout: Layout.vertical,
                dropdownDecoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                selectedItemStyle: const TextStyle(color: Colors.black),
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                    debugPrint("Selected Country: $countryValue");
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value ?? "";
                    debugPrint("Selected State: $stateValue");
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value ?? "";
                    if (cityValue.isNotEmpty && stateValue.isNotEmpty) {
                      _address = '$cityValue, $stateValue, $countryValue';
                      widget.onAddressChanged(_address);
                      debugPrint("Selected Address: $_address");
                    }
                  });
                  try {
                    // Explicitly type the map
                    Map<String, dynamic> userData = {
                      'address': _address,
                      'state': stateValue,
                      'city': cityValue,
                      'country': countryValue,
                      'location': location != null
                          ? GeoPoint(location!.latitude!, location!.longitude!)
                          : null,
                    };

                    _updateUserLocationAndNavigate(
                        context, userData); // Call only from onCityChanged
                  } catch (e) {
                    print("Error updating user: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to update location: $e")),
                    );
                  }
                },
              ),
            ),
            if (_address.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Selected Address: $_address',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}