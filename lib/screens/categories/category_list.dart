import 'package:adoptanddonate_new/screens/categories/subcat_screen.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage; // Import Firebase Storage
import 'package:cached_network_image/cached_network_image.dart'; // Import CachedNetworkImage

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
      body: FutureBuilder<QuerySnapshot>(
        future: _service.categories.orderBy('catName', descending: false).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // More specific error
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>; 

              // Safely access data
              String? catName = data['catName'] as String?;
              String? imagePath = data['image'] as String?; // GCS Path
              if (catName == null || imagePath == null) {
                return const SizedBox.shrink(); // Handling missing data
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  key: Key(doc.id), // Added Key for performance
                  onTap: () {
                    Navigator.pushNamed(context, SubCatList.id, arguments: {
                      'catName': catName,
                      'id': doc.id, // Pass the document ID
                    });
                  },
                  leading: FutureBuilder<String>( // Fetch Download URL
                    future: firebase_storage.FirebaseStorage.instance
                        .refFromURL(imagePath)
                        .getDownloadURL(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> imageSnapshot) {
                      if (imageSnapshot.hasError) {
                        return const Icon(Icons.error); // Handle image error
                      }
                      if (!imageSnapshot.hasData) {
                        return const CircularProgressIndicator(); // Loading
                      }
                      return CachedNetworkImage( // Use CachedNetworkImage
                        imageUrl: imageSnapshot.data!,
                        width: 40,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    },
                  ),
                  title: Text(
                    catName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
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