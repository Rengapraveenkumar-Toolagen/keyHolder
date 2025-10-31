import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_project/presentation/routes/pages_name.dart';
import 'package:flutter_boilerplate_project/presentation/screens/key_holder/key_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AddressScreen extends StatefulWidget {
  final KeyModel selectedKey;
  const AddressScreen({super.key, required this.selectedKey});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _isLoading = true;
  Position? _currentPosition;
  String? _currentAddress;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
          _permissionDenied = true;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
        _permissionDenied = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final address = await _getAddressFromLatLng(position);
      setState(() {
        _currentPosition = position;
        _currentAddress = address;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      return "Could not get address";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deliver Location"),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, PageName.deliverCodeScreen);
                    },
                    child: Text("Deliver Here"))),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Location permission denied."),
            ElevatedButton(
              onPressed: () {
                Geolocator.openAppSettings();
              },
              child: const Text("Open Settings"),
            )
          ],
        ),
      );
    }

    if (_currentPosition == null) {
      return const Center(child: Text("Could not get location."));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 16),
          if (_currentAddress != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 26),
                Text(
                  "Currect Location",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                locationListWidget(
                    icon: Icons.abc,
                    title: _currentAddress ?? '',
                    subTitle: '',
                    isSelected: true),
              ],
            ),
          const SizedBox(height: 26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Saved Address",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              locationListWidget(
                  icon: Icons.home,
                  title: "43/1, North kotai street,",
                  subTitle: "Periyarnilayam, Madurai.",
                  isSelected: false),
              locationListWidget(
                  icon: Icons.home,
                  title: "43/1, North kotai street,",
                  subTitle: "Periyarnilayam, Madurai.",
                  isSelected: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget locationListWidget(
      {required IconData icon,
      required String title,
      required String subTitle,
      bool isSelected = false}) {
    return Container(
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(color: Colors.blue, width: 1),
              borderRadius: BorderRadius.circular(20))
          : null,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(15),
          child: Container(
            color: Colors.blue,
            padding: EdgeInsets.all(10),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(title),
        subtitle: Text(subTitle),
        trailing: Icon(Icons.abc),
      ),
    );
  }
}
