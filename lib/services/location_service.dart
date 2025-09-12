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

/// Service class to handle localization (position) services.
///
/// This class provides methods to:
/// - Get the current position of the device.
/// - Convert a latitude/longitude into a [Place] (address).
/// - Get suggestions for place names using Google Places API.
class LocationService {
  /// API key for Google Maps obtained from environment variables.
  static final String _mapsApiKey = dotenv.get(ApiKeys.mapsApiKey);

  /// Base URL for the Google Geocoding API.
  static const String _apiUrl =
      'https://maps.googleapis.com/maps/api/geocode/json?';

  /// Uses [Geolocator] to get the current device position.
  ///
  /// Returns `null` if:
  /// - Location services are disabled.
  /// - The user denies permission (either temporarily or permanently).
  /// Otherwise, returns a [Position] object with the current latitude and
  /// longitude.
  Future<Position?> getCurrentPosition() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    debugPrint('Location service enabled: $serviceEnabled');

    if (!serviceEnabled) {
      return null;
    }

    var locationPermission = await Geolocator.checkPermission();

    /// Ask for permission if it was denied
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }

    /// Return null if permission is still denied or denied forever
    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      return null;
    }

    /// Return the current position with low accuracy
    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.low),
    );
  }

  /// Converts a [LatLng] position into a [Place] using Google Geocoding API.
  ///
  /// Throws an [Exception] if the API call fails or returns a non-200 status
  /// code.
  Future<Place> getPlaceByPosition(LatLng position) async {
    final latitude = position.latitude;
    final longitude = position.longitude;

    /// Build URL for the request
    final url = '$_apiUrl&latlng=$latitude,$longitude&key=$_mapsApiKey';
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

  /// Gets place suggestions from Google Places Autocomplete API.
  ///
  /// Returns a list of [Place] matching the [input].
  /// [sessionToken] is required for billing/session tracking by the API.
  /// Returns an empty list if [input] is empty or API fails.
  Future<List<Place>> getSuggestion({
    required String input,
    required String sessionToken,
  }) async {
    if (input.isEmpty) return [];

    final places = <Place>[];

    try {
      final baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      final request =
          '$baseURL?input=$input&key=$_mapsApiKey&sessiontoken=$sessionToken';
      var response = await http.get(Uri.parse(request));
      debugPrint('Body: ${response.body}');

      if (response.statusCode == 200) {
        for (final map in json.decode(response.body)['predictions']) {
          places.add(PlaceModel.fromAutocompleteJson(map).toEntity());
        }
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return places;
  }

  /// Converts a place query string into a [Place] using Google Geocoding API.
  ///
  /// Returns `null` if the query could not be resolved or if the API call fails
  /// Example: "New York, NY" → [Place] with coordinates and address details.
  Future<Place?> getPositionByPlaceQuery(String query) async {
    debugPrint('Place query: $query');

    try {
      final baseURL = 'https://maps.googleapis.com/maps/api/geocoode/json';
      var request = '$baseURL?address=$query&key=$_mapsApiKey';
      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        debugPrint('Body: $body');

        if (body['results'] != null && body['results'].isNotEmpty) {
          return PlaceModel.fromMap(body['results'][0]).toEntity();
        } else {
          throw Exception('Failed to load geocode');
        }
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}
