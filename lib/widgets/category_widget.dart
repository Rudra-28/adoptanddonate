import 'package:adoptanddonate_new/screens/categories/category_list.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(  // Added SizedBox to constrain the height
        height: 200,  // Set a fixed height for the container
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.orderBy('sortId', descending: false).get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Text("Categories")),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CategoryListScreen.id);
                      },
                      child: const Row(
                        children: [
                          Text(
                            "see all",
                            style: TextStyle(color: Colors.blue),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(  // Added Expanded to allow ListView to take available space
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(  // Added SizedBox to constrain item width
                          width: 60,
                          child: Column(
                            children: [
                              Image.network(doc['image']),
                              Flexible(
                                child: Text(
                                  doc['catname'],
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 10),
                                )
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}