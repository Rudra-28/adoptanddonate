import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier{

  FirebaseService _service = FirebaseService();
late DocumentSnapshot doc;
late DocumentSnapshot userDetails;
late String selectedCategory;
String? selectedSubCat;
List<String> urlList=[];
Map<String,dynamic> datatofirestore ={};

 getCategory( selectedCat){
  selectedCategory= selectedCat;
  notifyListeners();
 }
 
 getSubCategory( selectedSubCat){
  this.selectedSubCat= selectedSubCat;
  notifyListeners();
 }
 getCatSnapshot(snapshot){
  doc=snapshot;
  notifyListeners();
 }

 getImages(url){
  urlList.add(url);
  notifyListeners();
 }

 getDate(data){
  datatofirestore= data;
   notifyListeners();
 }

 getUserDetails(){
  _service.getUserData().then((value)=>{
    userDetails= value,
    notifyListeners()
  });
 }

 clearData(){
  urlList=[];
  datatofirestore={};
  notifyListeners();
 }

 clearSelectedCat(){
  selectedCategory= '';
  selectedSubCat='';
  notifyListeners();
 }
}

 
