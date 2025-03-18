import 'package:adoptanddonate_new/screens/animals_details_screen.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class AnimalsList extends StatelessWidget {
  AnimalsList({super.key});
  final FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: FutureBuilder<QuerySnapshot>(
          future: _service.animals.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 140.0,
                  right: 140,
                ),
                child: Center(
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No animals found'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  child: Text(
                    "Fresh recommendations",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics:
                      ScrollPhysics(), // Keep or remove based on your scroll intent
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot document =
                        snapshot.data!.docs[index];
                    final Map<String, dynamic>? data =
                        document.data() as Map<String, dynamic>?;

                    if (data == null) {
                      return Center(child: Text('Data not available'));
                    }

                    final Map<String, dynamic>? categoryMap =
                        data['category'] as Map<String, dynamic>?;

                    if (categoryMap == null) {
                      return Center(child: Text('Category data not available'));
                    }

                    final String name =
                        categoryMap['Name'] as String? ?? 'Name not found';
                    final String category =
                        categoryMap['category'] as String? ??
                            'Category not found';
                    final String age =
                        categoryMap['age'] as String? ?? 'Age not found';
                    final String gender =
                        categoryMap['gender'] as String? ?? 'Gender not found';
                    final List<dynamic>? images = data['images'] as List?;
                    final List<String>? imageUrls = images
                        ?.map((e) => e.toString())
                        .toList(); // Ensure String list

                    return InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, AnimalsDetailsScreen.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Center(
                                child: imageUrls != null && imageUrls.isNotEmpty
                                    ? Image.network(
                                        imageUrls[0],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          try {
                                            print(
                                                'Firebase Image Load Error: $error');
                                            return Image.asset(
                                                'lib/assets/images/dog_backup.jpg'); // Attempt to load local asset
                                          } catch (assetError) {
                                            print(
                                                'Local Asset Load Error: $assetError'); // Log local asset error
                                            return Center(
                                                child: Text(
                                                    'Image failed to load (Firebase and local asset)')); // Fallback message
                                          }
                                        },
                                      )
                                    : Image.asset(
                                        'lib/assets/images/dog_backup.jpg'),
                              ),
                            ),
                            SizedBox(height: 8),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name: $name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Category: $category',
                                        style: TextStyle(color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Age: $age',
                                        style: TextStyle(color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Gender: $gender',
                                        style: TextStyle(color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 0.0,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: LikeButton(
                                        circleColor: const CircleColor(
                                            start: Color(0xff00ddff),
                                            end: Color(0xff0099cc)),
                                        bubblesColor: const BubblesColor(
                                          dotPrimaryColor: Color(0xff33b5e5),
                                          dotSecondaryColor: Color(0xff0099cc),
                                        ),
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            Icons.favorite,
                                            color:
                                                isLiked ? Colors.red : Colors.grey,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
