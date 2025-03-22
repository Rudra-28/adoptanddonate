import 'package:adoptanddonate_new/forms/provider/animal_provider.dart';
import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:adoptanddonate_new/screens/animals_details_screen.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class AnimalsList extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool proScreen;

  const AnimalsList({super.key, required this.data, required this.proScreen});

  @override
  State<AnimalsList> createState() => _AnimalsListState();
}

class _AnimalsListState extends State<AnimalsList> {
  final FirebaseService _service = FirebaseService();

  String address = ' ';

  void navigateToAnimalDetails(BuildContext context, String donorId) {
    final animalProvider = Provider.of<AnimalProvider>(context, listen: false);

    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(donorId)
    //     .get()
    //     .then((donorSnapshot) {
    //   if (donorSnapshot.exists) {
    //     animalProvider.getDonorDetails(donorSnapshot);
    //   } else {
    //     print('Donor document not found.');
    //   }
    // }).catchError((error) {
    //   print('Error fetching donor details: $error');
    // });
  }

  @override
  void initState() {
    super.initState();

    _service.getDonorData(widget.data['donorUid']).then((value) {
      if (value.exists) {
        // Ensure the document exists
        setState(() {
          address = (value.data() as Map<String, dynamic>)['address'] ??
              'No Address Found';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);
    var _provider = Provider.of<AnimalProvider>(context, listen: false);

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: FutureBuilder<QuerySnapshot>(
          future: _service.animals.get(),
          // future: _catProvider.selectedCategory == 'Dogs'
          //     ? _service.animals
          //         .orderBy('postAt')
          //         .where('category', isEqualTo: _catProvider.selectedCategory)
          //         .get()
          //     : _service.animals
          //         .orderBy('postAt')
          //         .where('subCat', isEqualTo: _catProvider.selectedSubCat)
          //         .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
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
                if (widget.proScreen == false)
                  Container(
                    height: 56,
                    child: Text(
                      "Fresh recommendations",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
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
                    final String postAt =
                        (categoryMap['postAt'] as int?)?.toString() ??
                            'PostAt not found';

                    final String Milk =
                        categoryMap['Milk'] as String? ?? 'Milk not found';
                    final String description =
                        categoryMap['description'] as String? ??
                            'Description not found';

                    final String foundlocation =
                        categoryMap['foundlocation'] as String? ??
                            'foundlocation not found';
                    final String weight =
                        categoryMap['weight'] as String? ?? 'weight not found';
                    final String nature =
                        categoryMap['nature'] as String? ?? 'nature not found';
                    final String category =
                        categoryMap['category'] as String? ??
                            'Category not found';
                    final String age =
                        categoryMap['age'] as String? ?? 'Age not found';
                    final String gender =
                        categoryMap['gender'] as String? ?? 'Gender not found';
                    final List<dynamic>? images =
                        categoryMap['images'] as List?;

                    final List<String>? imageUrls =
                        images?.map((e) => e.toString()).toList();

                    return InkWell(
                      onTap: () {
                        final Animal animal = Animal(
                          name: name,
                          category: category,
                          age: age,
                          description: description,
                          gender: gender,
                          nature: nature,
                          weight: weight,
                          postAt: index.toString(),
                          Milk: Milk,
                          foundlocation: foundlocation,
                          imageUrls: imageUrls ?? [],
                        );
                        _provider.setAnimalData(animal);

                        // Get the donor ID from the animal document
                        String donorId =
                            document.id; // document is available in itemBuilder

                        navigateToAnimalDetails(
                            context, donorId); // Pass the donorId
// _provider.getAnimalDetails(widget.data);
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
                                child: Builder(
                                  // Use Builder to get context in the correct scope
                                  builder: (context) {
                                    print(
                                        'Image URLs: $imageUrls'); // Correct placement

                                    return imageUrls != null &&
                                            imageUrls.isNotEmpty
                                        ? Image.network(
                                            imageUrls[0],
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              print(
                                                  'Firebase Image Load Error: $error, URL: ${imageUrls[0]}');
                                              try {
                                                print(
                                                    'Firebase Image Load Error: $error');
                                                return Image.asset(
                                                    'lib/assets/images/dog_backup.jpg');
                                              } catch (assetError) {
                                                print(
                                                    'Local Asset Load Error: $assetError');
                                                return Center(
                                                  child: Text(
                                                    'Image failed to load (Firebase and local asset)',
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        : Image.asset(
                                            'lib/assets/images/dog_backup.jpg');
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  CircleAvatar(
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
                                          color: isLiked
                                              ? Colors.red
                                              : Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

class Animal {
  final String name;
  final String category;
  final String age;
  final String gender;
  final String nature;
  final String weight;
  final String Milk;
  final String description;
  final String foundlocation;
  final String postAt;
  final List<String> imageUrls;
  final String? userId;

  Animal({
    required this.name,
    required this.foundlocation,
    required this.description,
    required this.category,
    required this.age,
    required this.postAt,
    required this.Milk,
    required this.gender,
    required this.imageUrls,
    required this.nature,
    required this.weight,
    this.userId,
  });
}

class User {
  final String name;
  User({
    required this.name,
  });
}
