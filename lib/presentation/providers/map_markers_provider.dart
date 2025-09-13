import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/extensions/place_extensions.dart';
import '../../core/extensions/travel_stop_extensions.dart';
import '../../domain/entities/travel_stop.dart';

/// A provider that manages the set of [Marker]s displayed on the map.
///
/// Exposes methods to reset, add, and remove markers based on [TravelStop]s.
/// Uses [ChangeNotifier] to update listeners when the marker set changes.
class MapMarkersProvider with ChangeNotifier {
  /// Internal storage of active markers.
  final _markers = <Marker>{};

  /// Clears all markers and, optionally, repopulates them from a list of
  /// [TravelStop]s.
  ///
  /// Each stop is converted into a [Marker] positioned at the stop’s [LatLng].
  /// When a marker is tapped, it opens the stop details modal.
  ///
  /// Parameters:
  /// - [context]: The [BuildContext] used for showing the modal on marker tap.
  /// - [stops]: An optional list of [TravelStop]s to render as markers.
  void resetMarkers({
    required List<TravelStop>? stops,
    required Future<void> Function(TravelStop) onTap,
  }) {
    _markers.clear();

    if (stops != null && stops.isNotEmpty) {
      for (final stop in stops) {
        final pos = stop.place.latLng;

        _markers.add(
          Marker(
            markerId: stop.toMarkerId(),
            infoWindow: InfoWindow(title: stop.place.toString()),
            position: pos,
            onTap: () => onTap(stop),
          ),
        );
      }
    }

    notifyListeners();
  }

  /// Adds a single [marker] to the map.
  void addMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  /// Removes the marker corresponding to the given [stop].
  void removeMarker(TravelStop stop) {
    _markers.removeWhere((marker) => marker.markerId == stop.toMarkerId());
    notifyListeners();
  }

  /// Returns the current set of active markers.
  Set<Marker> get markers => _markers;
}
