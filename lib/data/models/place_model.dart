import 'package:uuid/uuid.dart';

import '../../domain/entities/place.dart';
import '../local/database/tables/places_table.dart';

/// Model class to represent a [Place]
///
/// This model class contains methods to manipulate place data, such as
/// fromMap, toMap, fromEntity, toEntity, and other serialization/deserialization
/// operations. It stores information about city, state, country, country code,
/// and geographical coordinates (latitude and longitude).
class PlaceModel {
  /// Unique identifier for the place
  final String id;

  /// City name of the place
  final String? city;

  /// State or region of the place
  final String? state;

  /// Country name
  final String? country;

  /// ISO country code (e.g., "US")
  final String? countryCode;

  /// Latitude coordinate
  final double latitude;

  /// Longitude coordinate
  final double longitude;


  /// Named constructor for [PlaceModel].
  ///
  /// Creates a [PlaceModel] with optional [id], [city], [state], [country],
  /// [countryCode], and required [latitude] and [longitude].
  ///
  /// [id] is the unique identifier for the place. If not provided, a new UUID
  /// will be generated automatically.
  /// [city] is the name of the city for this place (optional).
  /// [state] is the name of the state or province (optional).
  /// [country] is the name of the country (optional).
  /// [countryCode] is the ISO country code (optional).
  /// [latitude] is the latitude coordinate of the place (required).
  /// [longitude] is the longitude coordinate of the place (required).
  PlaceModel({
    String? id,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
  }) : id = id ?? Uuid().v4();


  /// Creates a [PlaceModel] from JSON data returned by Google Places API
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

  /// Creates a [PlaceModel] from autocomplete JSON data
  factory PlaceModel.fromAutocompleteJson(Map<String, dynamic> json) {
    final description = json['description'] as String? ?? '';
    final parts = description.split(',').map((e) => e.trim()).toList();
    String? city, state, country;
    if (parts.isNotEmpty) city = parts[0];
    if (parts.length >= 2) state = parts[1];
    if (parts.length >= 3) country = parts.last;

    return PlaceModel(
      latitude: 0.0,
      longitude: 0.0,
      city: city,
      state: state,
      country: country,
      countryCode: null,
    );
  }

  /// Creates a [PlaceModel] from a Map (database row)
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

  /// Converts this [PlaceModel] into a Map (for database storage)
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

  /// Returns a copy of this [PlaceModel] with updated fields
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

  /// Converts a domain [Place] entity to this model
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

  /// Converts this model to a domain [Place] entity
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
