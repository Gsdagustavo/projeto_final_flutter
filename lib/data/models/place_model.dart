import 'package:uuid/uuid.dart';

import '../../domain/entities/place.dart';
import '../local/database/tables/places_table.dart';

class PlaceModel {
  final String id;
  final String? city;
  final String? state;
  final String? country;
  final String? countryCode;
  final double latitude;
  final double longitude;

  PlaceModel({
    String? id,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
  }) : id = id ?? Uuid().v4();

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    String? getComponent(List components, String type) {
      try {
        return components.firstWhere(
          (c) => (c['types'] as List).contains(type),
        )['long_name'];
      } catch (_) {
        return null;
      }
    }

    final components = json['results'][0]['address_components'] as List;
    final location = json['results'][0]['geometry']['location'];

    return PlaceModel(
      id: Uuid().v4(),
      city:
          getComponent(components, 'locality') ??
          getComponent(components, 'administrative_area_level_2'),
      state: getComponent(components, 'administrative_area_level_1'),
      country: getComponent(components, 'country'),
      countryCode: getComponent(components, 'country') != null
          ? components.firstWhere(
              (c) => (c['types'] as List).contains('country'),
            )['short_name']
          : null,
      latitude: (location['lat'] as num?)!.toDouble(),
      longitude: (location['lng'] as num?)!.toDouble(),
    );
  }

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
      id: map[PlacesTable.placeId] as String,
      city: map[PlacesTable.city] as String?,
      state: map[PlacesTable.state] as String?,
      country: map[PlacesTable.country] as String?,
      countryCode: map[PlacesTable.countryCode] as String?,
      latitude: map[PlacesTable.latitude] as double,
      longitude: map[PlacesTable.longitude] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      PlacesTable.placeId: id,
      PlacesTable.city: city,
      PlacesTable.state: state,
      PlacesTable.country: country,
      PlacesTable.countryCode: countryCode,
      PlacesTable.latitude: latitude,
      PlacesTable.longitude: longitude,
    };
  }

  PlaceModel copyWith({
    String? id,
    String? city,
    String? state,
    String? country,
    String? countryCode,
    double? latitude,
    double? longitude,
  }) {
    return PlaceModel(
      id: id ?? this.id,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory PlaceModel.fromEntity(Place place) {
    return PlaceModel(
      id: place.id,
      city: place.city,
      state: place.state,
      country: place.country,
      countryCode: place.countryCode,
      latitude: place.latitude,
      longitude: place.longitude,
    );
  }

  Place toEntity() {
    return Place(
      id: id,
      city: city,
      state: state,
      country: country,
      countryCode: countryCode,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  String toString() {
    return 'PlaceModel{id: $id, city: $city, state: $state, '
        'country: $country, countryCode: $countryCode, latitude: $latitude, '
        'longitude: $longitude}';
  }
}
