import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  bool _uploading= false;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    Future<String?> uploadFile() async{
      File file =File (_image!.path);
      String? downloadUrl;
      String imageName = 'petImage/${DateTime.now().microsecondsSinceEpoch}';

      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);

        downloadUrl= await FirebaseStorage.instance.ref(imageName).getDownloadURL();

        if(downloadUrl!=null){
          setState(() {
            _image=null;
            print("downloadUrl");
          });
        }
      }on FirebaseException catch (e){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("cancelled"),),
        );
      }
      return downloadUrl;
    };


    return Dialog(
      child: Column(
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
                    if(_image!=null)
                    Positioned(
                      right: 0,
                      child: IconButton(onPressed: (){
                      setState(() {
                        _image=null;
                      });
                    }, icon: Icon(Icons.clear),)),
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
                        color: Colors.black12),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                if(_image!=null)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:(){
                          setState(() {
                            _uploading=true;
                            uploadFile().then((url)=>{
                              setState(() {
                                _uploading=false;
                              })
                            });
                          });
                        },
                        child: const Text("Save"),
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.green)
                        ),
                      ),
                    ),
                   const  SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Cancel"),
                          style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.red)
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: getImage,
                        child: Text(
                          "Upload image",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        style: const ButtonStyle(
                          iconColor: WidgetStatePropertyAll(Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                if(_uploading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
