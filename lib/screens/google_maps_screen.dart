import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/course.dart';

class GoogleMapsScreen extends StatefulWidget {
  static const String id = "googleMaps";
  final Course? course;

  const GoogleMapsScreen({super.key, this.course});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenPageState();
}

class _GoogleMapsScreenPageState extends State<GoogleMapsScreen> {
  final List<Marker> markers = <Marker>[];
  late final Course courseState;
  late final CameraPosition _kGoogle;

  @override
  void initState() {
    super.initState();
    _createMarkers(widget.course!);
    courseState = widget.course!;
    _kGoogle = CameraPosition(
      target:
          LatLng(courseState.location.latitude, courseState.location.longitude),
      zoom: 15,
    );
  }

  final Completer<GoogleMapController> _controller = Completer();

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  void _createMarkers(Course course) {
    markers.add(Marker(
      markerId: MarkerId(course.id.toString()),
      position: LatLng(course.location.latitude, course.location.longitude),
      infoWindow: InfoWindow(
        title: course.name,
        snippet: course.tutorName,
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: const Text("Мапа"),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: _kGoogle,
            markers: Set<Marker>.of(markers),
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserCurrentLocation().then((value) async {
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14,
            );

            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
        child: const Icon(Icons.pin_drop_outlined),
      ),
    );
  }
}
