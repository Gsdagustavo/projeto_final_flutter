import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/entities/travel.dart';
import '../../widgets/my_app_bar.dart';

class TravelRoutePage extends StatefulWidget {
  const TravelRoutePage({super.key, required this.travel});

  final Travel travel;

  @override
  State<TravelRoutePage> createState() => _TravelRoutePageState();
}

class _TravelRoutePageState extends State<TravelRoutePage> {
  var _polylines = <Polyline>{};

  final polylinePoints = PolylinePoints(apiKey: dotenv.env['MAPS_API_KEY']!);

  Set<Marker> calculateMarkers() {
    final stops = widget.travel.stops;

    return stops.map((stop) {
      final lat = stop.place.latitude;
      final lon = stop.place.longitude;

      return Marker(
        markerId: MarkerId('$lat,$lon'),
        infoWindow: InfoWindow(title: stop.place.toString()),
        position: LatLng(lat, lon),
      );
    }).toSet();
  }

  Future<List<LatLng>> calculatePolylines() async {
    final stops = widget.travel.stops;

    if (stops.length < 2) return [];

    final origin = PointLatLng(
      stops.first.place.latitude,
      stops.first.place.longitude,
    );

    final destination = PointLatLng(
      stops.last.place.latitude,
      stops.last.place.longitude,
    );

    final waypoints = stops.sublist(1, stops.length - 1).map((stop) {
      return PolylineWayPoint(
        location: '${stop.place.latitude},${stop.place.longitude}',
      );
    }).toList();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: origin,
        destination: destination,
        mode: TravelMode.driving,
        wayPoints: waypoints,
      ),
    );

    if (result.points.isEmpty) {
      return [];
    }

    return result.points.map((e) {
      return LatLng(e.latitude, e.longitude);
    }).toList();
  }

  Future<void> generatePolyline() async {
    final polylineCoords = await calculatePolylines();

    final polyline = Polyline(
      polylineId: PolylineId('Route'),
      color: Colors.red,
      width: 5,
      points: polylineCoords,
    );

    setState(() {
      _polylines = {polyline};
    });
  }

  LatLng getInitialPosition() {
    final stops = widget.travel.stops;
    return LatLng(stops.first.place.latitude, stops.first.place.longitude);
  }

  @override
  void initState() {
    super.initState();
    widget.travel.stops.sort(
      (a, b) => a.travelStopId!.compareTo(b.travelStopId!),
    );
    generatePolyline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: widget.travel.travelTitle,
        automaticallyImplyLeading: true,
      ),

      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {});
        },

        initialCameraPosition: CameraPosition(
          target: getInitialPosition(),
          zoom: 15,
        ),

        markers: calculateMarkers(),
        polylines: _polylines,
      ),
    );
  }
}
