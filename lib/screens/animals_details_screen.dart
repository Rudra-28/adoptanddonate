import 'dart:async';
import 'package:adoptanddonate_new/forms/provider/animal_provider.dart';
import 'package:adoptanddonate_new/screens/animals_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMaps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimalsDetailsScreen extends StatefulWidget {
  static const String id = 'animals-details-screen';
  

  const AnimalsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AnimalsDetailsScreen> createState() => _AnimalsDetailsScreenState();
}

class _AnimalsDetailsScreenState extends State<AnimalsDetailsScreen> {
  
  late GoogleMapController _controller;

  bool _loading = true;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  _maplauncher(location) async {
    final availableMaps = await MapLauncher.installedMaps;
    print(
        availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

    await availableMaps.first.showMarker(
      coords: Coords(location.latitude, location.longitude),
      title: "Donor Location is here",
    );
  }

  _callDonor(number){
    launchUrl(number);
  }

  @override
  Widget build(BuildContext context) {
    var animalProvider = Provider.of<AnimalProvider>(context);
    GeoPoint? location;
   //GeoPoint location = AnimalProvider.donorDetails['location'];
if (animalProvider.donorDetails != null && animalProvider.donorDetails!.data() != null && (animalProvider.donorDetails!.data() as Map<String, dynamic>).containsKey('location')) {
    location = (animalProvider.donorDetails!.data() as Map<String, dynamic>)['location'];
} else {
    // Handle the case where location is not available
    location = GeoPoint(20.2581138, 73.0282436); // Default location or handle appropriately
}
    final Animal? animal = animalProvider.currentAnimal;

    if (animal == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Animal Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

   
    return Scaffold(
        appBar: AppBar(
          title: Text(
            animal.name.toUpperCase(), // Display animal name in AppBar
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              onPressed: () {
                // Share functionality here
              },
              icon: const Icon(
                Icons.share_outlined,
                color: Colors.black,
              ),
            ),
            LikeButton(
              circleColor: const CircleColor(
                start: Color(0xff00ddff),
                end: Color(0xff0099cc),
              ),
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
        body: SingleChildScrollView(
          // Use SingleChildScrollView for scrollable content
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                              const SizedBox(height: 10),
                              const Text("Loading animal details..."),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            Center(
                              child: animal.imageUrls.isNotEmpty
                                  ? PhotoView(
                                      backgroundDecoration: BoxDecoration(
                                          color: Colors.grey.shade100),
                                      imageProvider: NetworkImage(
                                          animal.imageUrls[_index]),
                                    )
                                  : Center(child: Text('No images available')),
                            ),
                            Positioned(
                              bottom: 0.0,
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: animal.imageUrls.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: animal.imageUrls.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                _index = i;
                                              });
                                            },
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              margin: const EdgeInsets.only(
                                                  right: 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: ClipRRect(
                                                // ClipRRect for rounded corners
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                child: Image.network(
                                                  animal.imageUrls[i],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Center(child: Text('No thumbnails')),
                              ),
                            ),
                          ],
                        ),
                ),
                if (_loading)
                  const SizedBox.shrink()
                else
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${animal.name.toUpperCase()} (${animal.category})',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.cake, color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            Text(
                              "Age: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${animal.age}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            Text(
                              "Gender: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${animal.gender}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.pets, color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            Text(
                              "Nature: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${animal.nature ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Align text to the top
                          children: [
                            Icon(Icons.location_on), // Location icon
                            SizedBox(width: 8),
                            Text(
                              "Location: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Expanded(
                              // Use Expanded to handle overflow
                              child: Text(
                                '${animal.foundlocation ?? 'Unknown'}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Add ellipsis for long text
                                maxLines:
                                    2, // Limit to 2 lines, adjust as needed.
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.fitness_center,
                                color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            Text(
                              "Weight: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${animal.weight ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (animal.category == 'farm animals')
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.local_drink,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Milk: ${animal.Milk ?? 'Unknown'}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            const Icon(Icons.catching_pokemon),
                            SizedBox(width: 8),
                            Text(
                              "Description",
                              textAlign: TextAlign
                                  .left, // Align "Description" header to the left
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      '${animal.description ?? 'Description not found'}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        // Text(animalProvider.),
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
                              child: ListTile(
                                title: const Text(
                                  'Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                subtitle: const Text(
                                  'SEE PROFILE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_forward_ios)),
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Text(
                          'posted at',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 200,
                          color: Colors.grey.shade300,
                          child: Stack(
                            children: [
                              Center(
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(location!.latitude,
                                        location!.longitude),
                                    zoom: 15,
                                  ),
                                 mapType: googleMaps.MapType.normal, 
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    setState(() {
                                      _controller = controller;
                                    });
                                  },
                                ),
                              ),
                            const Center(
                                child: Icon(
                                  Icons.location_on,
                                  size: 35,
                                ),
                              ),
                             const Center(
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.black12,
                                ),
                              ),
                              Positioned(
                                right: 4.0,
                                top: 4.0,
                                child: Material(
                                  elevation: 4,
                                  shape: Border.all(color: Colors.grey),
                                  child: IconButton(
                                    onPressed: () {
                                      _maplauncher(location);
                                    },
                                    icon:const Icon(Icons.alt_route_outlined),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Post ID: ${animal.postAt}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Report",
                                  style: TextStyle(color: Colors.blue),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        bottomSheet: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.lightBlue),
                      iconColor: WidgetStatePropertyAll(
                          Theme.of(context).primaryColor),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.chat_bubble, size: 16),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Chat",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                     _callDonor('tel:${animalProvider.donorDetails!['mobile']}');
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.lightBlue),
                      iconColor: WidgetStatePropertyAll(
                          Theme.of(context).primaryColor),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.phone, size: 16),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Call",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
//^3.5.4