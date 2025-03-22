import 'package:adoptanddonate_new/screens/location_screen.dart';
import 'package:adoptanddonate_new/screens/logout_screen.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:adoptanddonate_new/screens/services/search_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // Import the geocoding package

class AdopterAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AdopterAppBar({super.key});

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 56); // Add the height of the bottom part

  @override
  _AdopterAppBarState createState() => _AdopterAppBarState();
}

class _AdopterAppBarState extends State<AdopterAppBar> {

  static List<Animals> anim=[];
  

  
  final FirebaseService _service = FirebaseService();
  SearchService _search = SearchService();
  String _address = 'Update Location';
  final TextEditingController _searchController =
      TextEditingController(); // Add search controller

  String address='';
  late DocumentSnapshot donorDetails;

@override
void initState() {
  _service.animals.get().then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {
      var categoryData = doc['category']; // Access the nested category field
      
      setState(() {
        anim.add(
          Animals(
            document: doc,
            name: categoryData['Name'],  // Fetching data from the nested field
            breed: categoryData['breed'],
            description: categoryData['description'],
            category: categoryData['category'], 
             gender: categoryData['gender'], 
            subCat: categoryData.containsKey('subCat') ? categoryData['subCat'] : '', // Handle missing subCat field
           // postAt: categoryData['postAt']
          ),
        );
        getDonorAddress(doc['donorUId']);
      });
    });
  });

  super.initState();
  _fetchAddress();
}

 getDonorAddress(donorUid){
  _service.getDonorData(donorUid).then((value){
    setState(() {
      address=value['address'];
      donorDetails= value;
    });
  });
 }


  Future<void> _fetchAddress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _address = 'User not logged in';
      });
      print('User is not logged in.'); // Log this
      return; // IMPORTANT: Exit if user is not logged in
    }

    try {
      print('Fetching user document...'); // Log before fetching
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        setState(() {
          _address = 'Address not selected';
        });
        print('User document does not exist.'); // Log this
        return; // IMPORTANT: Exit if document does not exist
      }

      print('User document found. Processing data...'); // Log after fetching

      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

      if (data == null) {
        setState(() {
          _address = 'Error: Could not retrieve user data.';
        });
        print('Error: Could not retrieve user data.'); // Log this
        return;
      }

      if (data['address'] != null) {
        setState(() {
          _address = data['address'];
        });
        print('Address found in document: $_address');
      } else if (data['location'] != null) {
        //convert GeoPoint to address
        GeoPoint latLong = data['location'];
        print(
            'Location found.  Latitude: ${latLong.latitude}, Longitude: ${latLong.longitude}');
        String address = await _getAddressFromCoordinates(
            latLong.latitude, latLong.longitude);
        setState(() {
          _address = address;
        });
        print('Address from coordinates: $_address');
      } else {
        setState(() {
          _address = 'Address not selected';
        });
        print('Address and location are null in document.');
      }
    } catch (e) {
      setState(() {
        _address = 'Error fetching location';
      });
      print('Error fetching address: $e');
    }
  }

  // Function to convert GeoPoint to address using geocoding
  Future<String> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      print(
          'Fetching address from coordinates: Latitude: $latitude, Longitude: $longitude');
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String fullAddress =
            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        print('Full address: $fullAddress');
        return fullAddress;
      } else {
        print('No address found for given coordinates.');
        return "No address found";
      }
    } catch (e) {
      print("Error fetching address from coordinates: $e");
      return "Error fetching address";
    }
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: InkWell(
        onTap: () {
          Navigator.pushNamed(context, LocationScreen.id);
        },
        child: SizedBox(
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
                  _address,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
                size: 18,
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          onTap: (){
_search.search(context: context, animalList: anim, Address: address,);
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                            ),
                            labelText: 'Find Dogs, cats, and many more ',
                            labelStyle: const TextStyle(
                              fontSize: 12,
                            ),
                            contentPadding:
                                const EdgeInsets.only(left: 10, right: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context,
                            LogoutPage.id); // Navigate to LogoutPage
                      },
                      child: const Icon(Icons.logout), // Use the logout icon
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

