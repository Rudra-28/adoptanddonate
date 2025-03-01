import 'package:adoptanddonate/forms/donor_cat_form.dart';
import 'package:adoptanddonate/forms/provider/cat_provider.dart';
import 'package:adoptanddonate/screens/categories/subcat_screen.dart';
import 'package:adoptanddonate/screens/donateanimal/donor_subcat.dart';
import 'package:adoptanddonate/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class DonorCategory extends StatelessWidget {
  static const String id = "donor-category-list";
  const DonorCategory({super.key});

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
        body: Container(
          child: FutureBuilder<QuerySnapshot>(
            future: _service.categories.orderBy('sortId', descending: false).get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Container(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            _catProvider.getCategory(doc['catName']);
                            _catProvider.getCatSnapshot(doc);
                            if (doc['subcat'] == null) {
                             return Navigator.pushNamed(context,DonorCatForm.id);
                            }
                            //for Sub Categories
                            Navigator.pushNamed(context, DonorSubCat.id,
                                arguments: {
                                  'catName': doc[
                                      'catName'], // Assuming doc has a 'catName' field
                                });
                          },
                          leading: Image.network(doc['image']),
                          title: Text(
                            doc['catname'],
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing: doc ['subCat']== null ? null :Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        ),
                      );
                    }),
              );
            },
          ),
        ));
  }
}
