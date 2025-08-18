class Place {
  final String id;
  final String? city;
  final String? state;
  final String? country;
  final String? countryCode;
  final double latitude;
  final double longitude;

  const Place({
    required this.id,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  Place copyWith({
    String? id,
    String? city,
    String? state,
    String? country,
    String? countryCode,
    double? latitude,
    double? longitude,
  }) {
    return Place(
      id: id ?? this.id,
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
