import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../domain/entities/enums.dart';

/// Transport types and its icons
const transportTypesIcons = {
  TransportType.bike: Icons.directions_bike,
  TransportType.car: Icons.directions_car,
  TransportType.bus: Icons.directions_bus,
  TransportType.plane: FontAwesomeIcons.plane,
  TransportType.cruise: FontAwesomeIcons.ship,
};
