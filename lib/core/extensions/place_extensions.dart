import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/place.dart';

/// Extension methods for the [Place] class
extension PlaceExtensions on Place {
  /// Returns the [LatLng] of the [Place] from the [latitude] and [longitude]
  LatLng get latLng {
    return LatLng(latitude, longitude);
  }
}

extension LatLngExtension on LatLng {
  String toLatLngString() {
    return '$latitude,$longitude';
  }
}
