import '../../domain/entities/place.dart';
import '../local/database/tables/places_table.dart';
import 'address_model.dart';

class PlaceModel {
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
  final AddressModel address;

  PlaceModel({
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
    required this.address,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
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
      address: AddressModel.fromJson(json['address'] ?? {}),
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

  factory PlaceModel.fromEntity(Place place) {
    return PlaceModel(
      placeId: place.placeId,
      osmType: place.osmType,
      lat: place.lat,
      lon: place.lon,
      category: place.category,
      type: place.type,
      placeRank: place.placeRank,
      addresstype: place.addresstype,
      name: place.name,
      displayName: place.displayName,
      address: AddressModel.fromEntity(place.address),
    );
  }

  Place toEntity() {
    return Place(
      placeId: placeId,
      osmType: osmType,
      lat: lat,
      lon: lon,
      category: category,
      type: type,
      placeRank: placeRank,
      addresstype: addresstype,
      name: name,
      displayName: displayName,
      address: address.toEntity(),
    );
  }

  Map<String, dynamic> fromMap(int addressId) {
    return {
      PlacesTable.placeId: placeId,
      PlacesTable.osmType: osmType,
      PlacesTable.lat: lat,
      PlacesTable.lon: lon,
      PlacesTable.category: category,
      PlacesTable.type: type,
      PlacesTable.placeRank: placeRank,
      PlacesTable.addresstype: addresstype,
      PlacesTable.name: name,
      PlacesTable.displayName: displayName,
      PlacesTable.addressId: addressId,
    };
  }

  factory PlaceModel.toMap(
    Map<String, dynamic> map,
    AddressModel addressModel,
  ) {
    return PlaceModel(
      placeId: map[PlacesTable.placeId] ?? 0,
      osmType: map[PlacesTable.osmType] ?? '',
      lat: (map[PlacesTable.lat] as num?)?.toDouble() ?? 0.0,
      lon: (map[PlacesTable.lon] as num?)?.toDouble() ?? 0.0,
      category: map[PlacesTable.category] ?? '',
      type: map[PlacesTable.type] ?? '',
      placeRank: map[PlacesTable.placeRank]?.toString() ?? '',
      addresstype: map[PlacesTable.addresstype] ?? '',
      name: map[PlacesTable.name] ?? '',
      displayName: map[PlacesTable.displayName] ?? '',
      address: addressModel,
    );
  }

  @override
  String toString() {
    return 'PlaceModel{placeId: $placeId, osmType: $osmType, lat: $lat, lon: $lon, category: $category, type: $type, placeRank: $placeRank, addresstype: $addresstype, name: $name, displayName: $displayName, address: $address}';
  }
}
