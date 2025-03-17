import 'dart:ffi';

import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:adoptanddonate_new/screens/home_screen.dart';
import 'package:adoptanddonate_new/screens/location_screen.dart';
import 'package:adoptanddonate_new/screens/main_screen.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserReviewScreen extends StatefulWidget {
  static const String id = 'user-review-screen';
  const UserReviewScreen({super.key});

  @override
  State<UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  FirebaseService _service = FirebaseService();

  var _nameController = TextEditingController();
  var _countryCodeController = TextEditingController(text: '+91');
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _addressController = TextEditingController();

  Future<void> updateUser(
    provider,
    Map<String, dynamic> data,
    context,
  ) {
    return _service.users.doc(_service.user!.uid).update(data).then((value) {
      saveAnimalsToDb(provider, context);
    }).catchError((error) {
      print("Failed to update user: $error");
      return Future.error(error); // Return Future.error
    });
  }

  Future<void> saveAnimalsToDb(
    provider,
    context,
  ) { 
    return _service.animals
        .doc()
        .set(provider.datatofirestore)
        .then((value) {
      provider.clearData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("We have recieved you animal registration"),
        ),
      );
    }).catchError((error) {
      print("Failed to update user: $error");
      return Future.error(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);
    showConfirmDialog() {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Confirm",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Are you sure you want to save below pet animal"),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: _provider.datatofirestore['image'] != null &&
                            (_provider.datatofirestore['image'] as List)
                                .isNotEmpty
                        ? Image.network(
                            _provider.datatofirestore['image'][0] ?? '',
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          )
                        : const SizedBox.shrink(),
                    title: Text(
                      _provider.datatofirestore['title'] ?? '',
                      maxLines: 1,
                    ),
                    subtitle: Text(_provider.datatofirestore['breed'] ?? ''),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _loading = false;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (_loading)
                            return; // Prevent multiple calls while loading

                          setState(() {
                            _loading = true;
                          });

                          try {
                            await updateUser(
                              _provider,
                              {
                                'contactDetails': {
                                  'contactMobile': _phoneController.text,
                                  'contactEmail': _emailController.text,
                                },
                                'name': _nameController.text,
                              },
                              context,
                            );

                            if (context.mounted) {
                              try {
                                Navigator.pushReplacementNamed(
                                    context, MainScreen.id);
                              } catch (navError) {
                                setState(() {
                                  _loading = false;
                                });
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Navigation Error: $navError')),
                                  );
                                }
                                return;                              }
                            }
                          } catch (e) {
                            setState(() {
                              _loading = false;
                            });
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Update Error: $e')),
                              );
                            }
                          } finally {
                            setState(() {
                              _loading = false;
                            });
                          }
                        },
                        child: const Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          iconColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_loading)
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
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
        automaticallyImplyLeading: false,
        title: Text(
          'Review your details',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
      body: Form(
        key: _formKey,
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.getUserData(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ));
            }
            _nameController.text = snapshot.data!['name'] ?? '';
            _phoneController.text =
                (snapshot.data!['mobile'] as String?)?.substring(3) ?? '';
            _emailController.text = snapshot.data!['email'] ?? '';
            _addressController.text = snapshot.data!['address'] ?? '';
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 40,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            radius: 30,
                            child: Icon(
                              CupertinoIcons.person_2_alt,
                              color: Colors.red.shade100,
                              size: 60,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Your Name'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Contact Details",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _countryCodeController,
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: 'country',
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'mobile number',
                                helperText: 'enter contact mobile number',
                              ),
                              maxLength: 10,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'enter mobile number';
                                }
                              },
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          helperText: 'Enter contact email'),
                      maxLength: 30,
                      validator: (value) {
                        final bool isValid =
                            EmailValidator.validate(_emailController.text);
                        if (value == null || value.isEmpty) {
                          return 'enter email';
                        }
                        if (value.isNotEmpty && isValid == false) {
                          return 'enter valid email address';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            minLines: 2,
                            maxLines: 4,
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Donor Address',
                              helperText: 'Contact Address',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LocationScreen(
                                          locationChanging: null,
                                        )));
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    return showConfirmDialog();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Enter required fields"),
                    ),
                  );
                },
                child: Text(
                  "Confirm",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                  iconColor:
                      WidgetStatePropertyAll(Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
