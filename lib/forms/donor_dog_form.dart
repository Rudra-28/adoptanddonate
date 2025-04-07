import 'dart:developer';
import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:adoptanddonate_new/forms/user_review_screen.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:adoptanddonate_new/widgets/imagePicker_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:location_geocoder/geocoder.dart';
import 'package:provider/provider.dart';

class DonorDogForm extends StatefulWidget {
  DonorDogForm({super.key});
  static const String id = "dog-form";

  @override
  State<DonorDogForm> createState() => _DonorDogFormState();
}

class _DonorDogFormState extends State<DonorDogForm> {
  FirebaseService _service = FirebaseService();
  final _formKey = GlobalKey<FormState>();

  var _breedController = TextEditingController();
  var _ageController = TextEditingController();
  var _genderController = TextEditingController();
  var _weightController = TextEditingController();
  var _natureController = TextEditingController();
  var _foundLocationController = TextEditingController();
  var _descController = TextEditingController();
  var _petNameController = TextEditingController();
  var _addressController = TextEditingController();

  String _address = ' ';

validate(CategoryProvider provider) {
  if (_formKey.currentState!.validate()) {
    if (provider.urlList.isNotEmpty) {
      provider.datatofirestore.addAll({
        'category': {
          'category': provider.selectedCategory,
          'subCat': provider.selectedSubCat,
          'breed': _breedController.text,
          'age': _ageController.text,
          'gender': _genderController.text,
          'weight': _weightController.text,
          'nature': _natureController.text,
          'foundlocation': _foundLocationController.text,
          'Name': _petNameController.text,
          'donorUid': _service.user?.uid,
          'description': _descController.text, //Corrected line
          'images': provider.urlList,
          'postAt': DateTime.now().microsecondsSinceEpoch
        }
      });
      log(provider.datatofirestore.toString());
      try{
      Navigator.pushNamed(context, UserReviewScreen.id);
      }catch(e){
        log("Navigator push error: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("images not found"),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("please complete required fields"),
      ),
    );
  }
}

  List<String> _genderList = ['Male', 'Female', 'Unknown'];
  List<String> _natureList = [
    'Calm',
    'Friendly',
    'Independent',
    'Cautious',
    'Aggressive'
  ];


@override
void initState() {
  _service.getUserData().then((value) {
    if (value != null && value.exists) {
      setState(() {
        _addressController.text = value['address'] ?? ''; // Corrected typo
      });
    }
  }).catchError((error){
    print("Error getting user data $error");
  });
  super.initState();
}

@override
void didChangeDependencies() {
  var _catProvider = Provider.of<CategoryProvider>(context);

  if (_catProvider.datatofirestore.isNotEmpty) {
    setState(() {
      _breedController.text = _catProvider.datatofirestore['breed'] ?? '';
      _ageController.text = _catProvider.datatofirestore['age'] ?? '';
      _weightController.text = _catProvider.datatofirestore['weight'] ?? '';
      _genderController.text = _catProvider.datatofirestore['gender'] ?? '';
      _natureController.text = _catProvider.datatofirestore['nature'] ?? '';
    });
  }

  super.didChangeDependencies();
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
                  itemCount: _catProvider.doc['Breeds'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        onTap: () {
                          setState(() {
                            _breedController.text =
                                _catProvider.doc['Breeds'][index];
                            [index]; //Corrected line
                          });
                          Navigator.pop(context);
                        },
                        title: Text(_catProvider.doc['Breeds'][index]));
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
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      print('building list item $index');
                      return ListTile(
                        title: Text(list[index]),
                        onTap: () {
                          textController.text = list[index];

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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("DOG"),
                  SizedBox(height: 15),
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
                      decoration: InputDecoration(
                          labelText: 'Breed ',
                          hintText: 'Select Breed',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please complete required fields';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller:
                        _petNameController, // Assuming you have a TextEditingController
                    decoration: InputDecoration(
                      labelText: 'Pet Name',
                      hintText: 'Enter your pet\'s name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your pet\'s name.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization
                        .words, // Capitalize the first letter of each word
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Age
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Age',
                        suffixText: 'Years',
                        hintText: 'Enter Age',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please complete required fields';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
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
                      decoration: InputDecoration(
                          labelText: 'Gender',
                          hintText: 'Select Gender',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please complete required fields';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Weight
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                        labelText: 'Weight',
                        hintText: 'Select weight',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please complete required fields';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //nature
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
                      decoration: InputDecoration(
                          labelText: 'Nature',
                          hintText: 'Select Nature',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please complete required fields';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText:
                          'Description', // Shortened label for better UI flow
                      hintText:
                          'e.g., Shy but friendly, needs a calm environment.', // More concise hint
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Slightly rounded corners
                        borderSide: BorderSide(
                            color: Colors.grey.shade400), // Light grey border
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Style when focused
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      labelStyle:
                          TextStyle(color: Colors.grey.shade700), // Label color
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600), // Hint text color
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 12.0), // Increased padding
                    ),
                    maxLines: 1, // Allows for multiline input
                    keyboardType:
                        TextInputType.multiline, // Ensures multiline keyboard
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a description.'; // More user-friendly message
                      }
                      return null;
                    },
                    style:
                        TextStyle(fontSize: 16.0), // Set a consistent font size
                    textInputAction: TextInputAction
                        .newline, // Allows for newlines using the enter key
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller:
                        _foundLocationController, // Add this controller to your state
                    decoration: InputDecoration(
                      labelText: 'Location Found',
                      hintText: 'e.g., Near Main Street Park, Apartment 3B',
                      border: OutlineInputBorder(), // Optional: Adds a border
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location where the animal was found';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_catProvider.urlList.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: GalleryImage(
                        imageUrls: _catProvider.urlList,
                        numOfShowImages: _catProvider.urlList.length,
                      ),
                    ),
                 
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Donor Address',
                      hintText: 'Enter your full address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.streetAddress,
                    textCapitalization:
                        TextCapitalization.words, // Capitalize words
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //imagepicker
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext) {
                          return ImagePickerWidget();
                        },
                      );
                    },
                    child: Container(
                      height: 50, // Increased height for better visibility
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100, // Light blue background
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                        border: Border.all(
                            color: Colors.blue.shade400), // Blue border
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt,
                                color: Colors.blue.shade700), // Camera icon
                            SizedBox(width: 8), // Spacing between icon and text
                            Text(
                              _catProvider.urlList.isNotEmpty
                                  ? "Upload Images"
                                  : "Upload Image",
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500, // Semi-bold text
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                    validate(_catProvider);
                    print(_catProvider.datatofirestore);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
