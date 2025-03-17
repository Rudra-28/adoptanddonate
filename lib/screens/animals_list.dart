import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimalsList extends StatelessWidget {
    AnimalsList({super.key});
    FirebaseService _service = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: FutureBuilder<QuerySnapshot>(
      future: _service.animals.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.only(left:140.0, right: 140,),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        }

        return  GridView.builder(
          shrinkWrap: true,
          physics:  ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 2/2,
          crossAxisSpacing: 8,
          mainAxisSpacing:10,
        ),
          itemCount: snapshot.data!.size,
         itemBuilder: (BuildContext context, int i){
          var data = snapshot.data!.docs[i];
          return Text(data['Name']);
         });
      },
    ),
    );
  }
}