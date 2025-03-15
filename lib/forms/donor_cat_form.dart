import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:adoptanddonate_new/widgets/imagePicker_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorCatForm extends StatefulWidget {
  DonorCatForm({super.key});
  static const String id = "cat-form";

  @override
  State<DonorCatForm> createState() => _DonorCatFormState();
}

class _DonorCatFormState extends State<DonorCatForm> {
  FirebaseService _service= FirebaseService();
  final _formKey = GlobalKey<FormState>();

  var _breedController = TextEditingController();
  var _ageController = TextEditingController();
  var _genderController = TextEditingController();
  var _weightController = TextEditingController();
  var _natureController = TextEditingController();
  var _addressController= TextEditingController();

 String _address='';

  validate() {
    if (_formKey.currentState!.validate()) {
      print("validated");
    }
  }

  List<String> _genderList = ['Male', 'Female'];
  List<String> _natureList = [
    'Calm',
    'Friendly',
    'Independent',
    'Cautious',
    'Aggressive'
  ];

 void intiState(){
    _service.getUserData().then((value)=>{
    setState(() {
    _addressController.text= value['address'];
    })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    Widget _appBar(title, FieldValue) {
      return AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        title: Text(
          "$title> $FieldValue",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    }

    Widget _breedlist() {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, 'subCat'),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _catProvider.doc['subCat'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        onTap: () {
                          setState(() {
                            _breedController.text = _catProvider.doc['subCat']
                                [index]; //Corrected line
                          });
                          Navigator.pop(context);
                        },
                        title: Text(_catProvider.doc['subCat'][index]));
                  }),
            )
          ],
        ),
      );
    }

    Widget _listview({FieldValue, list, textController}) {
      return Dialog(
        child: Container(
          //Added Container
          height: 200, //adjust the height as needed.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _appBar(_catProvider.selectedCategory, FieldValue),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _catProvider.doc['subCat'].length,
                    itemBuilder: (BuildContext context, int index) {
                      print('building list item $index');
                      return ListTile(
                        title: Text(_catProvider.doc['subCat'][index]),
                        onTap: () {
                          setState(() {
                           _breedController.text= _catProvider.doc['subCat'][index];
                          });
                          Navigator.pop(context);
                        },
                       
                      );
                    }),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: const Text(
          "Add some details ",
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(
            bottom: BorderSide(
          color: Colors.grey.shade900,
        )),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("CAT"),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _breedlist();
                        });
                  },
                  //Breed
                  child: TextFormField(
                    controller: _breedController,
                    enabled: false,
                    decoration: InputDecoration(labelText: 'Breed '),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please complete required fields';
                      }
                      return null;
                    },
                  ),
                ),
                //Age
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Age'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please complete required fields';
                    }
                    return null;
                  },
                ),
                //Gender
                InkWell(
                  //InkWell added here
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _listview(
                              FieldValue: 'Gender',
                              list: _genderList,
                              textController: _genderController);
                        });
                  },
                  child: TextFormField(
                    controller: _genderController,
                    enabled: false, //disable manual input
                    decoration: InputDecoration(labelText: 'Gender'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please complete required fields';
                      }
                      return null;
                    },
                  ),
                ),
                //Weight
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(labelText: 'Weight'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please complete required fields';
                    }
                    return null;
                  },
                ),
                   InkWell(
                  //InkWell added here
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _listview(
                              FieldValue: 'Nature',
                              list: _natureList,
                              textController: _natureController);
                        });
                  },
                  child: TextFormField(
                    controller: _natureController,
                    enabled: false, //disable manual input
                    decoration: InputDecoration(labelText: 'Nature'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please complete required fields';
                      }
                      return null;
                    },
                  ),
                ),
                //Age
                TextFormField(
                  enabled: false,
                  minLines: 2,
                  maxLines: 4,
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Seller Address', counterText: 'Donor Address'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please complete required fields';
                    }
                    return null;
                  },
                ), 
                InkWell(
                  onTap: (){
                    showDialog(context: context, builder: (BuildContext){
                      return ImagePickerWidget();
                    });
                  },
                  child: Container(
                    height: 40,
                    child: Center(
                      child: Text("upload image"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Next",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () {
                    validate();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
