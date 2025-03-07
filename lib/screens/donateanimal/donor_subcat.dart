
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DonorSubCat extends StatelessWidget {
  static const String id = "donor-subcat-screen";
  const DonorSubCat({super.key});

  @override
  Widget build(BuildContext context) {

    FirebaseService _service = FirebaseService();
    DocumentSnapshot args = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          args['catName'],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
      body:Container(child: FutureBuilder<DocumentSnapshot>(
          future: _service.categories.doc(args.id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            }


            var data= snapshot.data?['subcat'];
            return Container(
               child: ListView.builder(
                   itemCount: data.length,
                   itemBuilder: (BuildContext context, int index) {
                    
                     return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: ListTile(
                        onTap: (){
                         
                        },
                       
                        title:Text(data[index], style: const TextStyle(fontSize: 15),),
                       
                       ),
                       );
                   }),
             );
          },
        ),
     ),
    );
  }
}
