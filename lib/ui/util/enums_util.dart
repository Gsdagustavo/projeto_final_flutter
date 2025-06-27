import 'package:flutter/material.dart';

import '../../entities/enums.dart';
import '../../l10n/app_localizations.dart';

extension TransportTypeIntlString on TransportTypes {
  String getIntlTransportType(BuildContext context) {
    final loc = AppLocalizations.of(context);

    switch (this) {
      case TransportTypes.car:
        return loc!.transport_type_car;
      case TransportTypes.bike:
        return loc!.transport_type_bike;
      case TransportTypes.bus:
        return loc!.transport_type_bus;
      case TransportTypes.plane:
        return loc!.transport_type_plane;
      case TransportTypes.cruise:
        return loc!.transport_type_cruise;
    }
  }
}

extension ExperiencesIntlString on Experiences {
  String getIntlTransportType(BuildContext context) {
    final loc = AppLocalizations.of(context);

    switch (this) {
      case Experiences.alternativeCuisines:
        return loc!.experience_alternative_cuisines;
      case Experiences.contactWithNature:
        return loc!.experience_contact_with_nature;
      case Experiences.cultureImmersion:
        return loc!.experience_cultural_immersion;
      case Experiences.visitHistoricalPlaces:
        return loc!.experience_historical_places;
      case Experiences.visitLocalEstablishments:
        return loc!.experience_visit_local_establishments;
    }
  }
}
