import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubCatList extends StatelessWidget {
  static const String id = "subcat-screen";
  const SubCatList({Key? key}) : super(key: key); // Add Key

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    // Retrieve arguments as a Map
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return const Scaffold(
        body: Center(child: Text('Arguments are missing!')),
      );
    }

    final String catName = args['catName'] as String? ?? 'Category'; // Safely get catName
    final String docId = args['id'] as String? ?? ''; // Get document ID

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

          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final subCat = data?['subCat'] as List<dynamic>?;

          if (subCat == null || subCat.isEmpty) {
            return const Center(child: Text('No subcategories found'));
          }

          return ListView.builder(
            itemCount: subCat.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    subCat[index].toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}