import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/place.dart';
import 'string_extensions.dart';

extension PlaceExtension on Place {
  String get display {
    final String display;
    final latLng = LatLng(lat, lon);

    if (name.isEmpty) {
      display = latLng.formatted;
    } else {
      display = name;
    }

    return display;
  }
}
