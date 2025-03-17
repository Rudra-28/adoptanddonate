import 'dart:io';
import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatefulWidget {
  ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  bool _uploading = false;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print("No image selected");
    }
  }

  Future<String?> uploadFile() async {
    if (_image == null) return null; // Check if image is null
    setState(() {
      _uploading = true;
    });

    try {
      File file = File(_image!.path);
      String imageName = 'petImage/${DateTime.now().microsecondsSinceEpoch}';

      await FirebaseStorage.instance.ref(imageName).putFile(file);

      String downloadUrl =
          await FirebaseStorage.instance.ref(imageName).getDownloadURL();

      if (downloadUrl!=null) {
        setState(() {
          _image = null;
          Provider.of<CategoryProvider>(context, listen: false)
              .getImages(downloadUrl);
          _uploading = false;
        });
      }
      return downloadUrl;
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Firebase error: ${e.message}")),
        );
        setState(() {
          _uploading = false;
        });
      }
      return null;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e")),
        );
        setState(() {
          _uploading = false;
        });
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'upload image',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    if (_image != null)
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          icon: Icon(Icons.clear),
                        ),
                      ),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: _image == null
                            ? const Icon(
                                CupertinoIcons.photo_on_rectangle,
                                color: Colors.grey,
                              )
                            : Image.file(_image!),
                      ),
                      color: Colors.black12,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_provider.urlList.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: GalleryImage(
                      imageUrls: _provider.urlList,
                      numOfShowImages: _provider.urlList.length,
                    ),
                  ),
                const SizedBox(height: 20),
                if (_image != null)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: uploadFile, // Call uploadFile directly
                          child: const Text("Save"),
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: getImage,
                        child: Text(
                            _provider.urlList.isNotEmpty
                                ? "upload more images"
                                : "Upload image",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center),
                        style: const ButtonStyle(
                          iconColor: WidgetStatePropertyAll(Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_uploading)
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
