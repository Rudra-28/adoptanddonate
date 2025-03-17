import 'package:adoptanddonate_new/screens/location_screen.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdopterAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AdopterAppBar({Key? key}) : super(key: key);

  @override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _AdopterAppBarState createState() => _AdopterAppBarState();

  @override
  Widget build(BuildContext context) {
    return _AdopterAppBarState().build(context);
  }

  @override
  bool shouldRebuild(covariant AdopterAppBar oldDelegate) {
    return false;
  }
}

class _AdopterAppBarState extends State<AdopterAppBar> {
  String _address = 'Update Location';
  FirebaseService _service = FirebaseService();

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  _fetchAddress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

          if (data != null && data['address'] == null) {
            GeoPoint? latLong = data['location'];
            if (latLong != null) {
              String address = await _service.getAddressFromCoordinates(
                  latLong.latitude, latLong.longitude);
              setState(() {
                _address = address;
              });
            } else {
              setState(() {
                _address = 'Location data not available';
              });
            }
          } else if (data != null && data['address'] != null) {
            setState(() {
              _address = data['address'];
            });
          }
        } else {
          setState(() {
            _address = 'Address not selected';
          });
        }
      } catch (e) {
        setState(() {
          _address = 'Error fetching location';
        });
        print('Error fetching address: $e');
      }
    } else {
      setState(() {
        _address = 'User not logged in';
      });
    }
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
        preferredSize: Size.fromHeight(56),
        child: Container(
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
                                    labelText: 'Find Dogs, cats, and many more ',
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
                  ],
                ),
              ),
            ),
      ),
    );
  }
}