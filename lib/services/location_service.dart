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

    /// Ensure dotenv is initialized
    if (!dotenv.isInitialized) await dotenv.load();

    /// Get API Key from dotenv
    final apiKey = dotenv.env['MAPS_API_KEY'];

    /// Build URL
    final url = '$_apiUrl&latlng=$latitude,$longitude&key=$apiKey';

    debugPrint('getPlaceByPosition called. URL: $url');

    final response = await http.get(Uri.parse(url));

    print('Status code: ${response.statusCode}');

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
}
