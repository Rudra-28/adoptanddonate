import 'package:adoptanddonate_new/screens/categories/category_list.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key); // Added Key

  @override
  Widget build(BuildContext context) {
    // Assuming FirebaseService is a Singleton or injected
    final FirebaseService _service = FirebaseService();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200,
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child:
                      Text('Error: ${snapshot.error}')); // More specific error
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No categories found'));
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
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 60,
                          height: 50,
                          child: Column(
                            children: [
                              Image.network(doc['image']),
                              Flexible(
                                child: Text(
                                  doc['catName'],
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

class CategoryItem extends StatelessWidget {
  final QueryDocumentSnapshot doc;

  const CategoryItem({Key? key, required this.doc})
      : super(key: key); // Added Key

  @override
  Widget build(BuildContext context) {
    var data = doc.data() as Map<String, dynamic>; // Explicit cast
    String? imageUrl = data['image'] as String?;
    String? catName = data['catName'] as String?;

    if (imageUrl == null || catName == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            ),
            Flexible(
              child: Text(
                catName,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
