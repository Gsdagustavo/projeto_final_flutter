import 'package:flutter/material.dart';

import '../../entities/enums.dart';
import '../../l10n/app_localizations.dart';

class EnumFormatUtils {
  static String getFormattedString(String text) {
    var result = '';
    var idx = 0;

    for (final letter in text.split('')) {
      // means it is the first letter
      if (idx == 0) {
        result += letter.toUpperCase();
        idx++;
        continue;
      }

      // means it is another word
      if (letter.toUpperCase() == letter) {
        result += ' ';
        result += letter;
        idx += 2;
        continue;
      }

      if (result.isNotEmpty) {
        // the letter is in the middle of the word
        result += letter;
        idx++;
        continue;
      }
    }

    return result;
  }
}

extension TransportTypeIntlString on TransportType {
  String getIntlTransportType(BuildContext context) {
    final loc = AppLocalizations.of(context);

    switch (this) {
      case TransportType.car:
        return loc!.transport_type_car;
      case TransportType.bike:
        return loc!.transport_type_bike;
      case TransportType.bus:
        return loc!.transport_type_bus;
      case TransportType.plane:
        return loc!.transport_type_plane;
      case TransportType.cruise:
        return loc!.transport_type_cruise;
    }
  }
}

extension ExperiencesIntlString on Experience {
  String getIntlTransportType(BuildContext context) {
    final loc = AppLocalizations.of(context);

    switch (this) {
      case Experience.alternativeCuisines:
        return loc!.experience_alternative_cuisines;
      case Experience.contactWithNature:
        return loc!.experience_contact_with_nature;
      case Experience.cultureImmersion:
        return loc!.experience_cultural_immersion;
      case Experience.visitHistoricalPlaces:
        return loc!.experience_historical_places;
      case Experience.visitLocalEstablishments:
        return loc!.experience_visit_local_establishments;
    }
  }
}
