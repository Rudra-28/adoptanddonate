import 'package:adoptanddonate/screens/location_screen.dart';
import 'package:adoptanddonate/screens/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdopterAppBar extends StatelessWidget {
  const AdopterAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    FirebaseService _service= FirebaseService();
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_service.users.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Address not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          if(data ['address']==null){
            //then will check next data
             //then check the next data 
              GeoPoint LatLong =data['location'];
              _service.getAddressFromCoordinates(latitude, longitude).then((address){
                return appBar(address, context);
            });
          } else{
            return appBar(data['address'],context);
          }
          return appBar('update location', context);

          
        }

        return Text("loading location");
      },
    );
  }
}

Widget appBar(address, context){
  return  AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: InkWell(
          onTap: (){
              Navigator.pushNamed(context, LocationScreen.id);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.location_solid,
                  color: Colors.black,
                  size: 18,
                ),
                Flexible(
                  child: Text(
                    address,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color:Colors.black,size: 18,),
              ],
            ),
          ),
        ),
      );
}