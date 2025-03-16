import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier{

  FirebaseService _service = FirebaseService();
late DocumentSnapshot doc;
late DocumentSnapshot userDetails;
late String selectedCategory;
late String selectedSubCat;
List<String> urlList=[];
Map<String,dynamic> datatofirestore ={};

 getCategory( selectedCat){
  this.selectedCategory= selectedCat;
  notifyListeners();
 }
 
 getSubCategory( selectedSubCat){
  this.selectedSubCat= selectedSubCat;
  notifyListeners();
 }
 getCatSnapshot(snapshot){
  this.doc=snapshot;
  notifyListeners();
 }

 getImages(url){
  this.urlList.add(url);
  notifyListeners();
 }

 getDate(data){
  this.datatofirestore= data;
   notifyListeners();
 }

 getUserDetails(){
  _service.getUserData().then((value)=>{
    this.userDetails= value,
    notifyListeners()
  });
 }
}

 
