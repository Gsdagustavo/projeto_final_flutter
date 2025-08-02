import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/extensions/string_extensions.dart';
import 'address.dart';

class Place {
  final int placeId;
  final String osmType;
  final double lat;
  final double lon;
  final String category;
  final String type;
  final String placeRank;
  final String addresstype;
  final String name;
  final String displayName;
  final Address address;

  Place({
    required this.address,
    required this.placeId,
    required this.osmType,
    required this.lat,
    required this.lon,
    required this.category,
    required this.type,
    required this.placeRank,
    required this.addresstype,
    required this.name,
    required this.displayName,
  });

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

  String get latLng {
    return '$lat,$lon';
  }

  @override
  String toString() {
    return 'Place{place_id: $placeId, osm_type: $osmType, lat: $lat, lon: $lon, category: $category, type: $type, place_rank: $placeRank, addresstype: $addresstype, name: $name, display_name: $displayName, address: $address}';
  }
}
