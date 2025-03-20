import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:adoptanddonate_new/screens/animals_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimalByCategory extends StatelessWidget {
  static const String id = 'animal-by-category'; 
  const AnimalByCategory({super.key});

  @override
  Widget build(BuildContext context) {

    var _catProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(_catProvider.selectedCategory ?? 'Dogs', style:  TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(child: AnimalsList(true))
    );
  }
}