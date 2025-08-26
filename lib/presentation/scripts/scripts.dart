import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/date_extensions.dart';
import '../../core/extensions/experience_map_extension.dart';
import '../../core/extensions/travel_stop_extensions.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/travel_stop.dart';
import '../../l10n/app_localizations.dart';
import '../../services/location_service.dart';
import '../pages/travel/map_page.dart';
import '../providers/map_markers_provider.dart';
import '../providers/register_travel_provider.dart';
import '../providers/user_preferences_provider.dart';
import '../widgets/custom_dialog.dart';

void onMarkerTap(TravelStop stop, LatLng position, BuildContext context) async {
  debugPrint('Stop passed to onMarkerTap: $stop');

  await showTravelStopModal(context, position, stop);
}
