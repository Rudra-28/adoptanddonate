
import 'package:adoptanddonate_new/screens/categories/subcat_screen.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryListScreen extends StatelessWidget {
  static const String id = "category-list";
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          shape: const Border(
            bottom: BorderSide(color: Colors.grey),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Categories",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          child: FutureBuilder<QuerySnapshot>(
            future: _service.categories.get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Container(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            if (doc['subcat'] == null) {
                              return print('no sub categories');
                            }
                            //for Sub Categories
                            Navigator.pushNamed(context, SubCatList.id,
                                arguments: {
                                  'catName': doc[
                                      'catName'], // Assuming doc has a 'catName' field
                                });
                          },
                          leading: Image.network(doc['image']),
                          title: Text(
                            doc['catname'],
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        ),
                      );
                    }),
              );
            },
          ),
        ));
  }
}
