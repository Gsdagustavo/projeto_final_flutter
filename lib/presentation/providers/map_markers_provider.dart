import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/extensions/travel_stop_extensions.dart';
import '../../domain/entities/travel_stop.dart';

class MapMarkersProvider with ChangeNotifier {
  final _markers = <Marker>{};

  void resetMarkers([List<TravelStop>? stops]) {
    if (stops != null && stops.isNotEmpty) {
      for (final stop in stops) {
        _markers.add(Marker(markerId: stop.toMarkerId()));
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

  get markers => _markers;
}
