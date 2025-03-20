import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:adoptanddonate_new/screens/donateanimal/animal_by_category_list.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubCatList extends StatelessWidget {
  static const String id = "subcat-screen";
  const SubCatList({super.key}); 

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
      var _catProvider = Provider.of<CategoryProvider>(context);

    // Retrieve arguments as a Map
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return const Scaffold(
        body: Center(child: Text('Arguments are missing!')),
      );
    }

    final String catName = args['catName'] as String? ?? 'Category'; 
    final String docId = args['id'] as String? ?? ''; 

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          catName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _service.categories.doc(docId).get(), // Use docId
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var data=snapshot.data!['subCat'];
          // final data = snapshot.data?.data() as Map<String, dynamic>?;
          // final subCat = data?['subCat'] as List<dynamic>?;

          if (data == null || data.isEmpty) {
            return const Center(child: Text('No subcategories found'));
          }

          return Container(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    onTap: () {
                        _catProvider.getSubCategory(data[index]);
                        Navigator.pushNamed(context, AnimalByCategory.id);
                    },
                    title: Text(
                      data[index].toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}