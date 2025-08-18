import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/extensions/travel_stop_extensions.dart';
import '../../domain/entities/travel_stop.dart';
import '../scripts/scripts.dart';

class MapMarkersProvider with ChangeNotifier {
  final _markers = <Marker>{};

  void resetMarkers(BuildContext context, [List<TravelStop>? stops]) {
    _markers.clear();

    debugPrint('Reset markers called on MapMarkersProvider');
    debugPrint('Len stops passed to reset markers: ${stops?.length}');

    if (stops != null && stops.isNotEmpty) {
      for (final stop in stops) {
        _markers.add(
          Marker(
            markerId: stop.toMarkerId(),
            infoWindow: InfoWindow(title: stop.place.toString()),
            position: LatLng(stop.place.latitude, stop.place.longitude),
            onTap: () => onMarkerTap(
              stop,
              LatLng(stop.place.latitude, stop.place.longitude),
              context,
            ),
          ),
        );
      }
    }

    notifyListeners();
  }

  void addMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  void removeMarker(TravelStop stop) {
    _markers.removeWhere((marker) => marker.markerId == stop.toMarkerId());
    notifyListeners();
  }

  Set<Marker> get markers => _markers;
}
