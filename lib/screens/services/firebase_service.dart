import 'dart:async';

import 'package:adoptanddonate/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; 



class FirebaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User user = FirebaseAuth.instance.currentUser!;
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  Future<void> updateUser(Map<String, dynamic> data, BuildContext context) {
    return users.doc(user.uid) // Use user.uid
        .update(data)
        .then((value) => Navigator.pushNamed(context, HomeScreen.id))
        .catchError((error) => print("Failed to update user: $error"));
  }
}




Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String address =
          "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
      return address;
    } else {
      return "Address not found";
    }
  } catch (e) {
    print("Error getting address: $e");
    return "Error getting address";
  }
}