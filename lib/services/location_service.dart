import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_keys.dart';
import '../data/models/place_model.dart';
import '../domain/entities/place.dart';

/// A service class that handles location-based functionality using Google Maps
/// APIs and the device's GPS.
///
/// Provides methods to:
/// - Retrieve the device's current position.
/// - Convert latitude/longitude coordinates into a [Place].
/// - Search for places using autocomplete.
/// - Fetch detailed place information by place ID.
/// - Get the viewport (bounds) for a place to automatically set map zoom levels
class LocationService {
  /// API key for Google Maps, loaded from environment variables.
  static final String _mapsApiKey = dotenv.get(ApiKeys.mapsApiKey);

  /// Base URL for the Google Geocoding API.
  static const String _geocodeBase =
      'https://maps.googleapis.com/maps/api/geocode/json';

  /// Base URL for the Google Places Autocomplete API.
  static const String _autocompleteBase =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  /// Returns the current device position using [Geolocator].
  ///
  /// Returns `null` if location services are disabled or permissions are denied
  /// The returned [Position] contains latitude and longitude.
  Future<Position?> getCurrentPosition() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    debugPrint('Location service enabled: $serviceEnabled');

    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
  }

  /// Converts a [LatLng] coordinate into a [Place] using the Geocoding API.
  ///
  /// Throws an [Exception] if the request fails or the API returns a non-200
  /// status code.
  Future<Place> getPlaceByPosition(LatLng position) async {
    final latitude = position.latitude;
    final longitude = position.longitude;

    final url = '$_geocodeBase?latlng=$latitude,$longitude&key=$_mapsApiKey';
    debugPrint('getPlaceByPosition called. URL: $url');

    final response = await http.get(Uri.parse(url));
    debugPrint('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final placeModel = PlaceModel.fromJson(body);
      return placeModel.toEntity();
    } else {
      final msg =
          'An exception has occurred while trying to get the position. '
          'Status code :${response.statusCode}';
      debugPrint(msg);
      throw Exception(msg);
    }
  }

  /// Gets a list of place suggestions matching the given [input] string.
  ///
  /// [sessionToken] is used to track the user's session for billing purposes.
  /// Returns an empty list if [input] is empty or if the API request fails.
  Future<List<Place>> getSuggestions({
    required String input,
    required String sessionToken,
  }) async {
    if (input.isEmpty) return [];

    try {
      final request =
          '$_autocompleteBase?input=${Uri.encodeComponent(input)}'
          '&key=$_mapsApiKey&sessiontoken=$sessionToken';

      final res = await http.get(Uri.parse(request));

      if (res.statusCode != 200) {
        debugPrint('Autocomplete status code: ${res.statusCode}');
        return [];
      }

      final data = jsonDecode(res.body);
      if (data['status'] != 'OK' && data['status'] != 'ZERO_RESULTS') {
        debugPrint('Autocomplete API returned status: ${data['status']}');
        return [];
      }

      final preds = (data['predictions'] as List?) ?? [];
      return preds
          .map((p) => PlaceModel.fromAutocompleteJson(p).toEntity())
          .toList();
    } catch (e, st) {
      debugPrint('getSuggestions error: $e\n$st');
      return [];
    }
  }

  /// Retrieves detailed place information (address and coordinates) for a given
  /// [placeId].
  ///
  /// Returns `null` if the request fails or no results are found.
  Future<Place?> getPlaceDetails(String placeId) async {
    try {
      final request =
          '$_geocodeBase?place_id=${Uri.encodeComponent(placeId)}'
          '&key=$_mapsApiKey';

      final res = await http.get(Uri.parse(request));

      if (res.statusCode != 200) {
        debugPrint('getPlaceDetails status code: ${res.statusCode}');
        return null;
      }

      final body = jsonDecode(res.body);
      if (body['results'] != null && (body['results'] as List).isNotEmpty) {
        final model = PlaceModel.fromJson(body);
        return model.toEntity();
      }

      debugPrint('getPlaceDetails: no results for placeId $placeId');
      return null;
    } catch (e, st) {
      debugPrint('getPlaceDetails error: $e\n$st');
      return null;
    }
  }

  /// Retrieves only the latitude and longitude for a given [placeId].
  ///
  /// Returns `null` if the place is not found.
  Future<LatLng?> getPlaceLatLng(String placeId) async {
    final place = await getPlaceDetails(placeId);
    if (place == null) return null;
    return LatLng(place.latitude, place.longitude);
  }

  /// Retrieves the geometry information (location + viewport) for a given
  /// [placeId].
  ///
  /// The returned map contains `location` (lat/lng) and `viewport` (bounds) keys.
  /// Returns `null` if the request fails.
  Future<Map<String, dynamic>?> getPlaceGeometry(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?'
        'place_id=$placeId&fields=geometry&key=$_mapsApiKey';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] != 'OK') return null;

    final result = data['result']['geometry'];
    return result; // contains {location, viewport}
  }

  /// Converts a textual address [query] into a [Place] using the Geocoding API.
  ///
  /// Returns `null` if no results are found or the API call fails.
  Future<Place?> getPositionByPlaceQuery(String query) async {
    try {
      final request =
          '$_geocodeBase?address=${Uri.encodeComponent(query)}'
          '&key=$_mapsApiKey';

      final res = await http.get(Uri.parse(request));

      if (res.statusCode != 200) {
        debugPrint('getPositionByPlaceQuery status code: ${res.statusCode}');
        return null;
      }

      final body = jsonDecode(res.body);
      if (body['results'] != null && (body['results'] as List).isNotEmpty) {
        final model = PlaceModel.fromJson(body);
        return model.toEntity();
      }

      return null;
    } catch (e, st) {
      debugPrint('getPositionByPlaceQuery error: $e\n$st');
      return null;
    }
  }
}
