import 'package:adoptanddonate_new/screens/animals_details_screen.dart';
import 'package:adoptanddonate_new/screens/animals_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_geocoder/geocoder.dart';
import 'package:search_page/search_page.dart';

class Animals {
  final String name, description, category, subCat, breed, gender;
  
  final DocumentSnapshot document;

  Animals({
    required this.document,
    required this.name,
    required this.breed,
    required this.description,
    required this.category,
    required this.subCat,
    required this.gender,
     //required this.postAt,
  });

  // Factory constructor to safely extract nested data
  factory Animals.fromDocument(DocumentSnapshot doc) {
    var categoryData = doc['category'] ?? {}; // Handle missing category field

    return Animals(
      document: doc,
      name: categoryData['Name'] ?? 'Unknown', // Handle missing Name
      breed: categoryData['breed'] ?? 'Unknown',
      description: categoryData['description'] ?? 'No description',
      category: categoryData['category'] ?? 'Unknown',
      gender: categoryData['gender'] ?? 'Unknown',
      subCat: categoryData.containsKey('subCat') ? categoryData['subCat'] : '',
      //postAt: categoryData['postAt'] ?? 'Unknown', 
    );
  }
}

class SearchService {
  void search(
      {required BuildContext context, required List<Animals> animalList, Address}) {
    showSearch(
      context: context,
      delegate: SearchPage<Animals>(
          items: animalList,
          searchLabel: 'Search animals',
          suggestion: SingleChildScrollView(
              child: AnimalsList(data: {}, proScreen: true)),
          failure: const Center(
            child: Text('No animal found :('),
          ),
          filter: (animal) => [
                animal.name
                    .toLowerCase(), // Convert to lowercase for better search results
                animal.breed.toLowerCase(),
                animal.description.toLowerCase(),
                animal.category.toLowerCase(),
                animal.subCat.toLowerCase(),
               // animal.postAt.toLowerCase(),
              ],
          builder: (animal) {
           return InkWell(
  onTap: () {
    
    // provider.getAnimalDetails(animal.document);
    // provider.getDonorDetails(donorDetails);
    Navigator.pushNamed(context, AnimalsDetailsScreen.id);
  },
  child: Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: 120,
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          // Animal Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              animal.document['category']['images'][0], // ✅ Corrected path
              width: 120,
              height: 120,
              fit: BoxFit.cover, // Ensure the image fits well
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.broken_image,
                size: 60,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(width: 10),

          // Animal Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Breed & Name
                Text(
                  animal.breed,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  animal.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 6),

                // Gender & Location
                Text(
                  'Gender: ${animal.gender}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        Address,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);


          }),
    );
  }
}
