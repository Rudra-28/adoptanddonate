// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:search_page/search_page.dart';

// class Animals{
//   final String title,description, category,subCat;
//   final DocumentSnapshot document;


//   Animals(this.document, {
//     required this.title,
//     required this.description,
//     required this.category,
//     required this.subCat,
//   });
// }

// class SearchService {
//   search({context}){
//     showSearch(
//     context: context,
//     delegate: SearchPage<AnimalList>(
//       items: AnimalList,
//       searchLabel: 'Search people',
//       suggestion: Center(
//         child: Text('Filter people by name, surname or age'),
//       ),
//       failure: Center(
//         child: Text('No person found :('),
//       ),
//       filter: (Animals) => [
//         Animals!.title,
//         Animals.description,
//         Animals.category,
//         Animals.subCat,
//       ],
//       builder: (Animals) => ListTile(
//         title: Text(Animals.title),

//       ),
//     ),
//   );
//   }
// }

