import 'package:flutter/material.dart';

import '../../domain/entities/enums.dart';
import '../../l10n/app_localizations.dart';

/// This extension is a simple way to return the localized version of
/// the [TransportType] enum
extension TransportTypeIntlString on TransportType {
  /// Returns the localized [TransportType]
  String getIntlTransportType(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    switch (this) {
      case TransportType.car:
        return loc.transport_type_car;
      case TransportType.bike:
        return loc.transport_type_bike;
      case TransportType.bus:
        return loc.transport_type_bus;
      case TransportType.plane:
        return loc.transport_type_plane;
      case TransportType.cruise:
        return loc.transport_type_cruise;
    }
  }
}

/// This extension is a simple way to return the localized version of
/// the [TravelStopType] enum
extension TravelStopTypeIntlString on TravelStopType {
  /// Returns the localized [TravelStopType]
  String getIntlTravelStopType(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    switch (this) {
      case TravelStopType.start:
        return loc.travel_stop_type_start;
      case TravelStopType.stop:
        return loc.travel_stop_type_stop;
      case TravelStopType.end:
        return loc.travel_stop_type_end;
    }
  }
}

/// This extension is a simple way to return the localized version of
/// the [Experience] enum
extension ExperiencesIntlString on Experience {
  /// Returns the localized [Experience]
  String getIntlExperience(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    switch (this) {
      case Experience.alternativeCuisines:
        return loc.experience_alternative_cuisines;
      case Experience.contactWithNature:
        return loc.experience_contact_with_nature;
      case Experience.cultureImmersion:
        return loc.experience_cultural_immersion;
      case Experience.visitHistoricalPlaces:
        return loc.experience_historical_places;
      case Experience.visitLocalEstablishments:
        return loc.experience_visit_local_establishments;
    }
  }
}

/// This extension is a simple way to return the localized version of
/// the [TravelStopType] enum
extension TravelStatusIntlString on TravelStatus {
  /// Returns the localized [TravelStopType]
  String getIntlTravelStatus(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    switch (this) {
      case TravelStatus.upcoming:
        return loc.upcoming;
      case TravelStatus.ongoing:
        return loc.ongoing;
      case TravelStatus.finished:
        return loc.finished;
    }
  }
}
