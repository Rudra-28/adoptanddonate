import 'package:adoptanddonate_new/forms/donor_cat_form.dart';
import 'package:adoptanddonate_new/forms/donor_dog_form.dart'; // Import Dog Form
import 'package:adoptanddonate_new/forms/donor_bird_form.dart'; // Import Bird Form
import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:adoptanddonate_new/screens/categories/subcat_screen.dart';
import 'package:adoptanddonate_new/screens/donateanimal/donor_subcat.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class DonorCategoryListScreen extends StatelessWidget {
  static const String id = "donor-category-list";
  const DonorCategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

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
            return Center(child: Text('Error: ${snapshot.error}'));
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

              String? catName = data['catName'] as String?;
              String? imagePath = data['image'] as String?;
              if (catName == null || imagePath == null) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  key: Key(doc.id),
                  onTap: () {
                    _catProvider.getCategory(doc['catName']);
                    _catProvider.getCatSnapshot(doc);
                    print('Category Name: $catName'); 
                    // Navigate to different forms based on category name
                    if (catName.toLowerCase() == 'cats') {
                      Navigator.pushNamed(context, DonorCatForm.id, arguments: {
                        'catName': catName,
                        'id': doc.id,
                      });
                    } else if (catName.toLowerCase() == 'dogs') {
                      Navigator.pushNamed(context, DonorDogForm.id, arguments: {
                        'catName': catName,
                        'id': doc.id,
                      });
                    } else if (catName.toLowerCase() == 'birds') {
                      Navigator.pushNamed(context, DonorBirdForm.id, arguments: {
                        'catName': catName,
                        'id': doc.id,
                      });
                    } else if (data['subCat'] == null ||
                        (data['subCat'] is List &&
                            (data['subCat'] as List).isEmpty)) {
                      
                      Navigator.pushNamed(context, DonorCatForm.id, arguments: {
                        'catName': catName,
                        'id': doc.id,
                      });
                    } else {
                      Navigator.pushNamed(context, DonorSubCategoryList.id,
                          arguments: {
                            'catName': catName,
                            'id': doc.id,
                          });
                    }
                  },
                  leading: FutureBuilder<String>(
                    future: firebase_storage.FirebaseStorage.instance
                        .refFromURL(imagePath)
                        .getDownloadURL(),
                    builder: (BuildContext context,
                        AsyncSnapshot<String> imageSnapshot) {
                      if (imageSnapshot.hasError) {
                        return const Icon(Icons.error);
                      }
                      if (!imageSnapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      return CachedNetworkImage(
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