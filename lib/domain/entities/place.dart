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

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'] ?? 0,
      osmType: json['osm_type'] ?? '',
      lat: double.tryParse(json['lat'].toString()) ?? 0.0,
      lon: double.tryParse(json['lon'].toString()) ?? 0.0,
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      placeRank: json['place_rank']?.toString() ?? '',
      addresstype: json['addresstype'] ?? '',
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'osm_type': osmType,
      'lat': lat,
      'lon': lon,
      'category': category,
      'type': type,
      'place_rank': placeRank,
      'addresstype': addresstype,
      'name': name,
      'display_name': displayName,
      'address': address.toJson(),
    };
  }

  @override
  String toString() {
    return 'Place{place_id: $placeId, osm_type: $osmType, lat: $lat, lon: $lon, category: $category, type: $type, place_rank: $placeRank, addresstype: $addresstype, name: $name, display_name: $displayName, address: $address}';
  }
}
