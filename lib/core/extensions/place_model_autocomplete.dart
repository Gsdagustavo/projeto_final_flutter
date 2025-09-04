import '../../data/models/place_model.dart';

extension PlaceModelAutocomplete on PlaceModel {
  static PlaceModel fromAutocompleteJson(Map<String, dynamic> json) {
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
}
