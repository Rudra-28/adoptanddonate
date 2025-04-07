import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class NearbyAdoptionsPage extends StatefulWidget {
  static const String id = 'near-by-location';
  @override
  _NearbyAdoptionsPageState createState() => _NearbyAdoptionsPageState();
}

class _NearbyAdoptionsPageState extends State<NearbyAdoptionsPage> {
  Position? _currentPosition;
  GoogleMapController? _mapController;
  final List<Map<String, dynamic>> _allPets = [
    {
      'name': 'Bruno',
      'type': 'Dog',
      'lat': 19.0760,
      'lng': 72.8777,
    },
    {
      'name': 'Milo',
      'type': 'Cat',
      'lat': 19.0815,
      'lng': 72.8675,
    },
  ];
  List<Map<String, dynamic>> _nearbyPets = [];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _filterNearbyPets();
    });
  }

  void _filterNearbyPets() {
    List<Map<String, dynamic>> nearby = _allPets.where((pet) {
      double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        pet['lat'],
        pet['lng'],
      );
      pet['distance'] = (distance / 1000).toStringAsFixed(2);
      return distance < 10000; // 10 km radius
    }).toList();

    setState(() {
      _nearbyPets = nearby;
    });
  }

  Set<Marker> _buildMarkers() {
    return _nearbyPets.map((pet) {
      return Marker(
        markerId: MarkerId(pet['name']),
        position: LatLng(pet['lat'], pet['lng']),
        infoWindow: InfoWindow(title: pet['name'], snippet: pet['type']),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Adoptions'),
        backgroundColor: Colors.teal,
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 13,
                    ),
                    markers: _buildMarkers(),
                    onMapCreated: (controller) => _mapController = controller,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: _nearbyPets.length,
                    itemBuilder: (context, index) {
                      final pet = _nearbyPets[index];
                      return ListTile(
                        leading: Icon(Icons.pets),
                        title: Text(pet['name']),
                        subtitle: Text('${pet['type']} - ${pet['distance']} km away'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}