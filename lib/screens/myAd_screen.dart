import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAdScreen extends StatelessWidget {
  const MyAdScreen({super.key});

  @override
   Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text("My Ads", style: TextStyle(color: Colors.black)),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            indicatorWeight: 5,
            tabs: [
            Tab(
              child: Text("ADDS", style: TextStyle(color: Theme.of(context).primaryColor),),
            ),
              Tab(
              child: Text("FAVOURITES",style: TextStyle(color: Theme.of(context).primaryColor)),
            )
          ]),
        ),
      body: TabBarView(children: [
        Center(child: Text('My Favourites'),)
      ]),
      ),
    );
  }
}