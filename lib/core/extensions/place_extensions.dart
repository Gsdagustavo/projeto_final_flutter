import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/place.dart';

/// Extension methods for the [Place] class
extension PlaceExtensions on Place {
  /// Returns the [LatLng] of the [Place] from the [latitude] and [longitude]
  LatLng get latLng {
    return LatLng(latitude, longitude);
  }
}

/// Extension methods for the [LatLng] class
extension LatLngExtension on LatLng {
  /// Returns the [String] version of the [LatLng]
  String toLatLngString() {
    return '$latitude,$longitude';
  }
}
