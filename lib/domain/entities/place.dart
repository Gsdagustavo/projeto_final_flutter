import 'package:uuid/uuid.dart';

class Place {
  final String id;
  final String? city;
  final String? state;
  final String? country;
  final String? countryCode;
  final double latitude;
  final double longitude;

  Place({
    String? id,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
  }) : id = id ?? Uuid().v4();

  Place copyWith({
    String? city,
    String? state,
    String? country,
    String? countryCode,
    double? latitude,
    double? longitude,
  }) {
    return Place(
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
