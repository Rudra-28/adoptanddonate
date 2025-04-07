import 'dart:async';
import 'package:adoptanddonate_new/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class FirebaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference animals = FirebaseFirestore.instance.collection('animals');

  Future<void> updateUser(
      BuildContext context, Map<String, dynamic> data, Function() onSuccess) {
    // Modified
    return users.doc(user!.uid).update(data).then((value) {
      // Use user!.uid
      Navigator.pushNamed(context, HomeScreen.id); // Execute the callback
    }).catchError((error) {
      print("Failed to update user: $error");
      return Future.error(error); // Return Future.error
    });
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
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

  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot doc = await users.doc(user?.uid).get();
    return doc;
  }
   Future<DocumentSnapshot> getDonorData(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }
}