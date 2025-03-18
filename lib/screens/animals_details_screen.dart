import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class AnimalsDetailsScreen extends StatefulWidget {
  static const String id = 'animals-details-screen';
  const AnimalsDetailsScreen({super.key});

  @override
  State<AnimalsDetailsScreen> createState() => _AnimalsDetailsScreenState();
}

class _AnimalsDetailsScreenState extends State<AnimalsDetailsScreen> {
  bool _loading = true;
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      _loading = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share_outlined,
                color: Colors.black,
              )),
          LikeButton(
            circleColor: const CircleColor(
                start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Color(0xff33b5e5),
              dotSecondaryColor: Color(0xff0099cc),
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.grey,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              color: Colors.grey.shade300,
              child: _loading
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          SizedBox(height: 10,),
                          Text("loading you ad")
                        ],
                      ),
                    )





                  : Text(" ")),


                  
          Container(),
        ],
      )),
    );
  }
}
