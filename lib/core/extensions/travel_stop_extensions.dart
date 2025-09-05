import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/travel_stop.dart';

/// Extension methods for the [TravelStop] class
extension TravelStopExtensions on TravelStop {
  /// Returns a [MarkerId] from the [TravelStop]'s [Place] ID
  MarkerId toMarkerId() {
    return MarkerId(place.id);
  }
}
