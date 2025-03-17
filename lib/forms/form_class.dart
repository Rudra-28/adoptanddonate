import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
 
class FormClass {
  Widget appBar(CategoryProvider _provider){
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      title: Text(_provider.selectedSubCat ?? 'Default Title', style: const TextStyle(color: Colors.black)),
    );
    
  }
}