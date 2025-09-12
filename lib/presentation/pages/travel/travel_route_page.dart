import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/api_keys.dart';
import '../../../core/extensions/place_extensions.dart';
import '../../../domain/entities/travel.dart';
import '../../widgets/my_app_bar.dart';

/// This page shows the route of the given [Travel]
class TravelRoutePage extends StatefulWidget {
  /// Constant constructor
  const TravelRoutePage({super.key, required this.travel});

  /// The [Travel] that will have its route shown
  final Travel travel;

  @override
  State<TravelRoutePage> createState() => _TravelRoutePageState();
}

class _TravelRoutePageState extends State<TravelRoutePage> {
  GoogleMapController? _controller;

  var _polylines = <Polyline>{};
  final _polylinePoints = PolylinePoints(
    apiKey: dotenv.get(ApiKeys.mapsApiKey),
  );

  LatLngBounds _calculateBounds(List<LatLng> points) {
    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLon = points.first.longitude;
    var maxLon = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;

      if (point.longitude < minLon) minLon = point.longitude;
      if (point.longitude > maxLon) maxLon = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLon),
      northeast: LatLng(maxLat, maxLon),
    );
  }

  Set<Marker> _calculateMarkers() {
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

  Future<List<LatLng>> _calculatePolylines() async {
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

    final result = await _polylinePoints.getRouteBetweenCoordinates(
      // ignore: deprecated_member_use
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

  Future<void> _generatePolyline() async {
    final polylineCoords = await _calculatePolylines();

    final polyline = Polyline(
      polylineId: const PolylineId('Route'),
      color: Colors.red,
      width: 5,
      points: polylineCoords,
    );

    setState(() {
      _polylines = {polyline};
    });

    _fitBounds();
  }

  LatLng _getInitialPosition() {
    final stops = widget.travel.stops;
    return LatLng(stops.first.place.latitude, stops.first.place.longitude);
  }

  void _fitBounds() {
    final stops = widget.travel.stops.map((e) => e.place.latLng).toList();

    if (stops.isEmpty) return;

    final bounds = _calculateBounds(stops);

    _controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  void initState() {
    super.initState();
    widget.travel.stops.sort((a, b) => a.id.compareTo(b.id));
    _generatePolyline();
  }

  @override
  Widget build(BuildContext modalContext) {
    return Scaffold(
      appBar: MyAppBar(
        title: widget.travel.travelTitle,
        automaticallyImplyLeading: true,
      ),

      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
            _fitBounds();
          });
        },

        initialCameraPosition: CameraPosition(
          target: _getInitialPosition(),
          zoom: 15,
        ),

        markers: _calculateMarkers(),
        polylines: _polylines,
      ),
    );
  }
}
