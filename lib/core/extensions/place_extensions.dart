import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/place.dart';

extension PlaceExtensions on Place {
  LatLng get latLng {
    return LatLng(latitude, longitude);
  }
}
