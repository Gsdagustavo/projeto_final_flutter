import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../data/models/place_model.dart';
import '../domain/entities/place.dart';

/// Service class to handle localization (position) services
///
/// This class contains methods to get the current position of the device and
/// convert the position (latitude/longitude) into an address
class LocationService {
  /// Get API Key from dotenv
  static final String _mapsApiKey = dotenv.get('MAPS_API_KEY');
  static const String _apiUrl =
      'https://maps.googleapis.com/maps/api/geocode/json?';

  /// Uses [Geolocator] services to get the current position of the device
  ///
  /// The user has to accept the position services in order to a valid position
  /// be returned. Otherwise, it will not work
  Future<Position?> getCurrentPosition() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();

    debugPrint('Location service enabled: $serviceEnabled');

    if (!serviceEnabled) {
      return null;
    }

    var locationPermission = await Geolocator.checkPermission();

    /// If permission is denied, ask for permission
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }

    /// The user denied the permission
    /// Returns null
    if (locationPermission == LocationPermission.denied) {
      return null;
    }

    /// The user denied the permission permanently
    /// Returns null
    if (locationPermission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.low),
    );
  }

  /// Calls the Nominatim API (see [_apiUrl]) to convert a given [LatLng] into
  /// an address
  Future<Place> getPlaceByPosition(LatLng position) async {
    final latitude = position.latitude;
    final longitude = position.longitude;

    /// Build URL
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
