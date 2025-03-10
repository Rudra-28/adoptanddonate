
// import 'package:adoptanddonate_new/screens/account_screen.dart';
// import 'package:adoptanddonate_new/screens/chat_screen.dart';
// import 'package:adoptanddonate_new/screens/donateanimal/donor_cat.dart';
// import 'package:adoptanddonate_new/screens/home_screen.dart';
// import 'package:adoptanddonate_new/screens/myAd_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';

// class MainScreen extends StatefulWidget {
//   static const String id = 'main-screen';
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   Widget _currentScreen = const HomeScreen(
//     locationData: LocationData,
//   );
//   int _index = 0;
//   final PageStorageBucket _bucket = PageStorageBucket();
//   @override
//   Widget build(BuildContext context) {
//     Color color = Theme.of(context).primaryColor;
//     return Scaffold(
//       body: PageStorage(
//        child: _currentScreen,
//        bucket: _bucket,
//       ),
//       floatingActionButton: FloatingActionButton(
//         elevation: 4,
//         backgroundColor: Colors.purple,
//         onPressed: () {
//          Navigator.pushNamed(context, DonorCategoryListScreen.id);
//         },
//         child: const CircleAvatar(
//           backgroundColor: Colors.white,
//           child: Icon(Icons.add),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 10,
//         child: Container(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _index = 0;
//                         _currentScreen = HomeScreen(locationData: ,);
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(_index == 0 ? Icons.home : Icons.home_outlined),
//                         Text(
//                           "Home",
//                           style: TextStyle(
//                             color: _index == 0 ? color : Colors.black,
//                             fontWeight: _index == 0
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _index = 1;
//                        //currentScreen =ChatScreen();
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(_index == 1 ? CupertinoIcons.chat_bubble_fill: CupertinoIcons.chat_bubble),
//                         Text(
//                           "Account",
//                           style: TextStyle(
//                             color: _index == 1 ? color : Colors.black,
//                             fontWeight: _index == 1
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                     MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _index = 2;
//                       // currentScreen =const MyAdScreen();
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(_index == 2 ? CupertinoIcons.suit_heart_fill: CupertinoIcons.chat_bubble),
//                         Text(
//                           "Chat",
//                           style: TextStyle(
//                             color: _index == 2 ? color : Colors.black,
//                             fontWeight: _index == 2
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                     MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _index = 3;
//                        //currentScreen =const AccountScreen();
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(_index == 3 ? CupertinoIcons.person_fill: CupertinoIcons.person),
//                         Text(
//                           "Ads",
//                           style: TextStyle(
//                             color: _index == 3 ? color : Colors.black,
//                             fontWeight: _index == 3
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
