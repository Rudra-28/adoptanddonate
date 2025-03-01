import 'package:adoptanddonate/screens/login_screen.dart';
import 'package:adoptanddonate/widgets/banner_widget.dart';
import 'package:adoptanddonate/widgets/category_widget.dart';
import 'package:adoptanddonate/widgets/custom_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:location_geocoder/location_geocoder.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";
  final LocationData locationData;
  const HomeScreen({super.key, required this.locationData,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = "India";
  Future<String> getAddress() async {
    const _apiKey = 'YOUR_MAP_API_KEY'; // Replace with your actual API key
    final LocatitonGeocoder geocoder = LocatitonGeocoder(_apiKey);

    try {
      // Replace coordinates with actual latitude and longitude values
      final address = await geocoder.findAddressesFromCoordinates(
        Coordinates(
            widget.locationData.latitude, widget.locationData.longitude),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: SafeArea(child: AdopterAppBar())),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.search,
                                  ),
                                  labelText:
                                      'Find Dogs, cats, parrots, cows, goats, tortoise and many more ',
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
                            SizedBox(width: 10,),
                            const Icon(Icons.notifications_none),
                            SizedBox(width: 10,),
                          ],
                        ),
                      )),
                  const Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Column(
                      children: [
                        //banner widget
                        BannerWidget(),
                        //categories
                        CategoryWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
