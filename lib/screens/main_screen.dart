import 'package:adoptanddonate_new/screens/account_screen.dart';
import 'package:adoptanddonate_new/screens/chat_screen.dart';
import 'package:adoptanddonate_new/screens/donateanimal/donor_cat.dart';
import 'package:adoptanddonate_new/screens/home_screen.dart';
import 'package:adoptanddonate_new/screens/myAd_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main-screen';

  const MainScreen({Key? key, this.locationData}) : super(key: key);

  final LocationData? locationData; // Make locationData optional

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
   bool _resetNavigation = false; 
  late Widget _currentScreen; // Use late initialization
  int _index = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    _currentScreen = HomeScreen(
      locationData: widget.locationData ?? LocationData.fromMap({
        'latitude': 0.0,
        'longitude': 0.0,
        // Add other necessary fields with default values
      }),
    );
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.locationData != oldWidget.locationData) {
      _currentScreen = HomeScreen(
        locationData: widget.locationData ?? LocationData.fromMap({
          'latitude': 0.0,
          'longitude': 0.0,
          // Add other necessary fields with default values
        }),
      );
      setState(() {}); // Trigger a rebuild to update the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

     if (_resetNavigation) {
        _index = 0; // Reset to your default index
        _currentScreen = HomeScreen(
          locationData: widget.locationData ?? LocationData.fromMap({
            'latitude': 0.0,
            'longitude': 0.0,
          }),
        );
        _resetNavigation = false; // Reset the flag
      }
    return Scaffold(
      body: PageStorage(
        child: _currentScreen,
        bucket: _bucket,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: Colors.purple,
        onPressed: () {
        setState(() {
          _resetNavigation = true; 
        });
        Navigator.pushNamed(context, DonorCategoryListScreen.id);
      },
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 0;
                        _currentScreen = HomeScreen(
                          locationData: widget.locationData!,
                        );
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 0 ? Icons.home : Icons.home_outlined),
                        Text(
                          "Home",
                          style: TextStyle(
                            color: _index == 0 ? color : Colors.black,
                            fontWeight: _index == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 1;
                     
                        _currentScreen = ChatScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 1
                            ? CupertinoIcons.chat_bubble_fill
                            : CupertinoIcons.chat_bubble),
                        Text(
                          "Chat", // Changed "Account" to "Chat" as per your icons
                          style: TextStyle(
                            color: _index == 1 ? color : Colors.black,
                            fontWeight: _index == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 2;
                       
                         _currentScreen = MyAdScreen(); 
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 2
                            ? CupertinoIcons.suit_heart_fill
                            : CupertinoIcons.suit_heart), 
                        Text(
                          "Favorites", 
                          style: TextStyle(
                            color: _index == 2 ? color : Colors.black,
                            fontWeight: _index == 2
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 3;
                       
                         _currentScreen = AccountScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 3
                            ? CupertinoIcons.person_fill
                            : CupertinoIcons.person),
                        Text(
                          "Account",
                          style: TextStyle(
                            color: _index == 3 ? color : Colors.black,
                            fontWeight: _index == 3
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}