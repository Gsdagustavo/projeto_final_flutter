import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/travel_stop.dart';
import 'my_app_bar.dart';

/// This is a map widget that will be used to register a [TravelStop] and to
/// view a [Travel] route
///
/// Currently, it is not used in nowhere, since there are some limitations
/// due to not having a Google Maps API Key
class CustomMap extends StatefulWidget {
  /// Constant constructor
  const CustomMap({super.key});

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  late GoogleMapController _mapController;

  final LatLng _center = const LatLng(-26.976150, -48.906565);

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Map'),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
      ),
    );
  }
}
