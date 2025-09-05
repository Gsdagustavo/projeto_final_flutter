import 'package:uuid/uuid.dart';

/// Represents a [Place] with geographical and administrative details.
///
/// This class stores information about a location, including city, state,
/// country, country code, and precise coordinates (latitude and longitude).
/// It provides methods for creating copies with updated fields and a
/// string representation of the place.
class Place {
  /// Unique identifier for the place.
  ///
  /// Automatically generated using a UUID if not provided.
  final String id;

  /// Name of the city (optional).
  final String? city;

  /// Name of the state or administrative region (optional).
  final String? state;

  /// Name of the country (optional).
  final String? country;

  /// Country code (ISO 3166-1 alpha-2) (optional).
  final String? countryCode;

  /// Latitude of the place.
  final double latitude;

  /// Longitude of the place.
  final double longitude;

  /// Named constructor for [Place].
  ///
  /// Creates a new [Place] instance with optional [city], [state], [country],
  /// [countryCode] and required [latitude] and [longitude].
  /// The [id] is optional; if not provided, a new UUID will be generated automatically.
  ///
  /// [id] – Unique identifier for the place (optional).
  /// [city] – City name (optional).
  /// [state] – State or administrative region name (optional).
  /// [country] – Country name (optional).
  /// [countryCode] – ISO country code (optional).
  /// [latitude] – Geographical latitude (required).
  /// [longitude] – Geographical longitude (required).
  Place({
    String? id,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
  }) : id = id ?? Uuid().v4();

  /// Returns a copy of this [Place] with optional updated fields.
  ///
  /// [city] – New city name (optional).
  /// [state] – New state name (optional).
  /// [country] – New country name (optional).
  /// [countryCode] – New country code (optional).
  /// [latitude] – New latitude (optional).
  /// [longitude] – New longitude (optional).
  Place copyWith({
    String? city,
    String? state,
    String? country,
    String? countryCode,
    double? latitude,
    double? longitude,
  }) {
    return Place(
      id: id,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() {
    final parts = [
      city,
      state,
      country,
    ].where((e) => e != null && e.isNotEmpty).join(', ');

    if (countryCode != null && countryCode!.isNotEmpty) {
      return parts.isEmpty ? countryCode! : '$parts - $countryCode';
    }

    return parts;
  }
}
