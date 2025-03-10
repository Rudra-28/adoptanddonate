
import 'package:adoptanddonate_new/widgets/banner_widget.dart';
import 'package:adoptanddonate_new/widgets/category_widget.dart';
import 'package:adoptanddonate_new/widgets/adopter_appbar.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";
  final LocationData locationData;

  const HomeScreen({
    Key? key, // Added Key? key for consistency
    required this.locationData,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    if (widget.locationData.latitude != null &&
        widget.locationData.longitude != null) {
      String? fetchedAddress = await getAddressFromCoordinates(
        widget.locationData.latitude!,
        widget.locationData.longitude!,
      );
      if (fetchedAddress != null) {
        setState(() {
          address = fetchedAddress;
        });
      } else {
        setState(() {
          address = "Address not found";
        });
      }
    } else {
      setState(() {
        address = "Location unavailable";
      });
    }
  }

  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address =
            "${placemark.street ?? ''}, ${placemark.subLocality ?? ''}, ${placemark.locality ?? ''}, ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}";
        address = address.replaceAll(", ,", ", ");
        address = address.replaceAll(",,", ", ");
        address = address.trim();
        if (address.startsWith(",")) {
          address = address.substring(1).trim();
        }
        if (address.endsWith(",")) {
          address = address.substring(0, address.length - 1).trim();
        }

        return address.isNotEmpty ? address : null;
      }
    } catch (e) {
      print("Error getting address: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:PreferredSize(preferredSize: const Size.fromHeight(56), child: SafeArea(child: AdopterAppBar())),// Use AdopterAppBar directly
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
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.search,
                                  ),
                                  labelText:
                                      'Find Dogs, cats, and many more ',
                                  labelStyle: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, right: 10),
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
                          const Icon(Icons.notifications_none),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                 const Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Column(
                      children: [
                        BannerWidget(),
                        CategoryWidget()
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