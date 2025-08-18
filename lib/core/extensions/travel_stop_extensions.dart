import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/travel_stop.dart';

extension TravelStopExtensions on TravelStop {
  MarkerId toMarkerId() {
    return MarkerId('${place.id},${place.id}');
  }
}
