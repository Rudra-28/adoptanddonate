import 'package:adoptanddonate_new/forms/donor_dog_form.dart';
import 'package:adoptanddonate_new/forms/forms_screen.dart';
import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorSubCategoryList extends StatelessWidget {
  static const String id = "donor-subcat-list";
  const DonorSubCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

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
          (args.data() as Map<String, dynamic>)['catName'],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.categories.doc(args.id).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            var data = snapshot.data?['subCat'];

            if (data == null || (data is List && data.isEmpty)) {
              
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Fill up the below form to create animal profile"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, DonorDogForm.id); // Or navigate to a default form
                      },
                      child: Text("Go to Form"),
                    ),
                  ],
                ),
              );
            }

            return Container(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {

                 // var doc =data['subCat'][index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        _catProvider.getSubCategory(data[index]);
                        Navigator.pushNamed(context, FormsScreen.id);
                      },
                      title: Text(data[index], style: const TextStyle(fontSize: 15)),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}