import 'package:flutter/material.dart';

import '../../entities/enums.dart';
import '../../l10n/app_localizations.dart';

extension IntlString on TransportTypes {
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
