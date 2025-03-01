import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier{
late DocumentSnapshot doc;
late String selectedCategory;
 getCategory( selectedCat){
  this.selectedCategory= selectedCat;
  notifyListeners();
 }
 getCatSnapshot(snapshot){
  this.doc=snapshot;
  notifyListeners();
 }
}

 
