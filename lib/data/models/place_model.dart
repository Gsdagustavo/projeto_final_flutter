import 'package:uuid/uuid.dart';

import '../../domain/entities/place.dart';
import '../local/database/tables/places_table.dart';

/// Model class to represent a [Place].
///
/// Provides serialization/deserialization methods for:
/// - Google Places API JSON
/// - Autocomplete JSON
/// - Database Maps
/// - Domain entities
class PlaceModel {
  /// Unique identifier for the place (internal UUID/DB PK).
  final String id;

  /// Google Place ID (if available).
  final String? placeId;

  /// City name of the place.
  final String? city;

  /// State or region of the place.
  final String? state;

  /// Country name of the place.
  final String? country;

  /// ISO country code (e.g., "US").
  final String? countryCode;

  /// Latitude coordinate.
  final double latitude;

  /// Longitude coordinate.
  final double longitude;

  /// Named constructor for [PlaceModel].
  ///
  /// [id] is the unique identifier for the place. If not provided, a new UUID
  /// will be generated automatically.
  PlaceModel({
    String? id,
    this.placeId,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
  }) : id = id ?? const Uuid().v4();

  /// Creates a [PlaceModel] from JSON data returned by Google Places API.
  ///
  /// Throws an [Exception] if JSON does not contain results.
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    final results = (json['results'] as List?) ?? [];
    if (results.isEmpty) {
      throw Exception('No results found in Google Places JSON.');
    }

    final firstResult = results[0];
    final components = firstResult['address_components'] as List? ?? [];
    final location = firstResult['geometry']?['location'];

    String? getComponent(List components, String type) {
      try {
        return components.firstWhere(
              (c) => (c['types'] as List).contains(type),
            )['long_name']
            as String?;
      } catch (_) {
        return null;
      }
    }

    String? countryCode;
    try {
      final countryComponent = components.firstWhere(
        (c) => (c['types'] as List).contains('country'),
      );
      countryCode = countryComponent['short_name'] as String?;
    } catch (_) {
      countryCode = null;
    }

    return PlaceModel(
      id: const Uuid().v4(),
      placeId: firstResult['place_id'] as String?,
      city:
          getComponent(components, 'locality') ??
          getComponent(components, 'administrative_area_level_2'),
      state: getComponent(components, 'administrative_area_level_1'),
      country: getComponent(components, 'country'),
      countryCode: countryCode,
      latitude: (location?['lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (location?['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Creates a [PlaceModel] from autocomplete JSON data.
  ///
  /// ⚠️ This does not include latitude/longitude. Defaults them to `0.0`.
  factory PlaceModel.fromAutocompleteJson(Map<String, dynamic> json) {
    final description = json['description'] as String? ?? '';
    final parts = description.split(',').map((e) => e.trim()).toList();

    String? city, state, country;
    if (parts.isNotEmpty) city = parts[0];
    if (parts.length >= 2) state = parts[1];
    if (parts.length >= 3) country = parts.last;

    return PlaceModel(
      placeId: json['place_id'] as String?,
      latitude: 0.0,
      longitude: 0.0,
      city: city,
      state: state,
      country: country,
      countryCode: null,
    );
  }

  /// Creates a [PlaceModel] from a Map (database row).
  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
      id: map[PlacesTable.placeId] as String,
      placeId: map[PlacesTable.apiPlaceId] as String?,
      city: map[PlacesTable.city] as String?,
      state: map[PlacesTable.state] as String?,
      country: map[PlacesTable.country] as String?,
      countryCode: map[PlacesTable.countryCode] as String?,
      latitude: (map[PlacesTable.latitude] as num).toDouble(),
      longitude: (map[PlacesTable.longitude] as num).toDouble(),
    );
  }

  /// Converts this [PlaceModel] into a Map (for database storage).
  Map<String, dynamic> toMap() {
    return {
      PlacesTable.placeId: id,
      PlacesTable.apiPlaceId: placeId,
      PlacesTable.city: city,
      PlacesTable.state: state,
      PlacesTable.country: country,
      PlacesTable.countryCode: countryCode,
      PlacesTable.latitude: latitude,
      PlacesTable.longitude: longitude,
    };
  }

  /// Converts this [PlaceModel] to JSON (API or debug use).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placeId': placeId,
      'city': city,
      'state': state,
      'country': country,
      'countryCode': countryCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Returns a copy of this [PlaceModel] with updated fields.
  PlaceModel copyWith({
    String? id,
    String? placeId,
    String? city,
    String? state,
    String? country,
    String? countryCode,
    double? latitude,
    double? longitude,
  }) {
    return PlaceModel(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  /// Converts a domain [Place] entity to this model.
  factory PlaceModel.fromEntity(Place place) {
    return PlaceModel(
      id: place.id,
      placeId: place.placeId,
      city: place.city,
      state: place.state,
      country: place.country,
      countryCode: place.countryCode,
      latitude: place.latitude,
      longitude: place.longitude,
    );
  }

  /// Converts this model to a domain [Place] entity.
  Place toEntity() {
    return Place(
      id: id,
      placeId: placeId,
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
    return 'PlaceModel{id: $id, placeId: $placeId, city: $city, state: $state, '
        'country: $country, countryCode: $countryCode, latitude: $latitude, '
        'longitude: $longitude}';
  }
}
