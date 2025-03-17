import 'dart:ffi';

import 'package:adoptanddonate_new/forms/form_class.dart';
import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:adoptanddonate_new/forms/user_review_screen.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:adoptanddonate_new/widgets/imagePicker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:provider/provider.dart';

class FormsScreen extends StatefulWidget {
  static const String id = "forms-screen";
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  FirebaseService _service = FirebaseService();

  String _address = '';

  @override
  void initState() {
    _service.getUserData().then((value) {
      if (value != null && value.exists) {
        setState(() {
          _addressController.text = value['address'] ?? ''; // Corrected typo
        });
      }
    }).catchError((error) {
      print("Error getting user data $error");
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  var _breedtext = TextEditingController();
  var _descController = TextEditingController();
  var _dietaryController = TextEditingController();
  var _natureController = TextEditingController();
  var _weightController = TextEditingController();
  var _petNameController = TextEditingController();
  var _ageController = TextEditingController();
  var _genderController = TextEditingController();
  var _addressController = TextEditingController();
  var _vaccController = TextEditingController();
  var _livestocktext = TextEditingController();
  var _milkController = TextEditingController();

  validate(CategoryProvider provider) {
    if (_formKey.currentState!.validate()) {
      if (provider.urlList.isNotEmpty) {
        provider.datatofirestore.addAll({
          'category': {
            'category': provider.selectedCategory,
            'subCat': provider.selectedSubCat,
            'breed': _breedtext.text,
            'age': _ageController.text,
            'gender': _genderController.text,
            'weight': _weightController.text,
            'nature': _natureController.text,
            'dietary': _dietaryController.text,
            'Name': _petNameController.text, // Corrected
            'donorUid': _service.user?.uid, // Corrected
            'description': _descController,
            'vaccination': _vaccController,
            'Milk': _milkController,
            'images': provider.urlList,
            'postAt': DateTime.now().microsecondsSinceEpoch
          }
        });
        print(provider.datatofirestore);
        Navigator.pushNamed(context, UserReviewScreen.id);
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
  List<String> _dietaryList = [
    'Herbivore',
    'Carnivore',
    'Omnivore',
  ];

  List<String> _natureList = [
    'Calm',
    'Friendly',
    'Independent',
    'Cautious',
    'Aggressive'
  ];

  List<String> _vaccList = [
    'Vaccinated',
    'Not Vaccinated',
  ];

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

    Widget _listview({FieldValue, list, textController}) {
      return Dialog(
        child: Container(
          //Added Container
          height: 200, //adjust the height as needed.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _appBar(_catProvider.selectedSubCat, FieldValue),
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

    var _provider = Provider.of<CategoryProvider>(context);
    FormClass _formclass = FormClass();

    showFormDialog(List, _textController) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              width: 300,
              height: 380,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _formclass.appBar(_provider),
                  Expanded(
                    // Wrap ListView.builder with Expanded
                    child: ListView.builder(
                      shrinkWrap: true, // Recommended: Use shrinkWrap
                      itemCount: List.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              _textController.text = List[i];
                            });
                            Navigator.pop(context);
                          },
                          title: Text(List[i]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          "subcategories",
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                    '${_provider.selectedCategory} > ${_provider.selectedSubCat}'),
                if (_provider.selectedCategory == 'reptiles')
                  InkWell(
                    onTap: () {
                      showFormDialog(_provider.doc['breeds'], _breedtext);
                    },
                    child: TextFormField(
                      controller: _breedtext,
                      decoration: InputDecoration(
                        enabled: false,
                        labelText: 'Species',
                        hintText: 'Boa snake',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Slightly rounded corners
                          borderSide: BorderSide(
                              color: Colors.grey.shade400), // Light grey border
                        ),
                        focusedBorder: OutlineInputBorder(
                          // Style when focused
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        labelStyle: TextStyle(
                            color: Colors.grey.shade700), // Label color
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600), // Hint text color
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 12.0), // Increased padding
                      ),
                    ),
                  ),

                if (_provider.selectedCategory == 'Cats')
                  InkWell(
                    onTap: () {
                      showFormDialog(_provider.doc['breeds'], _breedtext);
                    },
                    child: TextFormField(
                      controller: _breedtext,
                      decoration: InputDecoration(
                        enabled: false,
                        labelText: 'Species',
                        hintText: 'bengal',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Slightly rounded corners
                          borderSide: BorderSide(
                              color: Colors.grey.shade400), // Light grey border
                        ),
                        focusedBorder: OutlineInputBorder(
                          // Style when focused
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        labelStyle: TextStyle(
                            color: Colors.grey.shade700), // Label color
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600), // Hint text color
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 12.0), // Increased padding
                      ),
                    ),
                  ),

                if (_provider.selectedCategory == 'farm animals')
                  InkWell(
                    onTap: () {
                      showFormDialog(
                          _provider.doc['livestock'], _livestocktext);
                    },
                    child: TextFormField(
                      controller: _livestocktext,
                      decoration: InputDecoration(
                        enabled: false,
                        labelText: 'Species',
                        hintText: 'Cow',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Slightly rounded corners
                          borderSide: BorderSide(
                              color: Colors.grey.shade400), // Light grey border
                        ),
                        focusedBorder: OutlineInputBorder(
                          // Style when focused
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        labelStyle: TextStyle(
                            color: Colors.grey.shade700), // Label color
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600), // Hint text color
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 12.0), // Increased padding
                      ),
                    ),
                  ),

                const SizedBox(
                  height: 10,
                ),

                InkWell(
                  //InkWell added here
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _listview(
                              FieldValue: 'Vaccination Status',
                              list: _vaccList,
                              textController: _vaccController);
                        });
                  },
                  child: TextFormField(
                    controller: _vaccController,
                    enabled: false, //disable manual input
                    decoration: InputDecoration(
                        labelText: 'Vaccination Status',
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
                    labelText: 'Description',
                    hintText:
                        'e.g., Shy but friendly, needs a calm environment.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    labelStyle: TextStyle(color: Colors.grey.shade700),
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a description.';
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

                InkWell(
                  //InkWell added here
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _listview(
                              FieldValue: 'Diet Habit',
                              list: _dietaryList,
                              textController: _dietaryController);
                        });
                  },
                  child: TextFormField(
                    controller: _dietaryController,
                    enabled: false, //disable manual input
                    decoration: InputDecoration(
                        labelText: 'Diet habits',
                        hintText: 'Select diet',
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

                if (_provider.selectedCategory == 'farm animals' ||
                    _provider.selectedSubCat == 'Cow' ||
                    _provider.selectedSubCat == 'Buffalo' ||
                    _provider.selectedSubCat == 'Goat')
                  TextFormField(
                    controller:
                        _milkController, // Assuming you have a TextEditingController
                    decoration: InputDecoration(
                      labelText: 'amount of Daily milk',
                      hintText: '10 ltrs',
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
                        return 'Please enter amount of milk deliverd';
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
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
                      hintText: 'Select Gender',
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
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
                SizedBox(
                  height: 10,
                ),
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
                      borderRadius: BorderRadius.circular(8), // Rounded corners
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
                    validate(_provider);
                    print(_catProvider.datatofirestore);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
