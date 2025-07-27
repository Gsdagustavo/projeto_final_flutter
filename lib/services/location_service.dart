import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../domain/entities/place.dart';
import 'auth_service.dart';

/// Service class to handle localization (position) services
///
/// This class contains methods to get the current position of the device and
/// convert the position (latitude/longitude) into an address
class LocationService {
  static const String _apiUrl =
      'https://nominatim.openstreetmap.org/reverse?format=jsonv2';

  static const String _userAgent = 'projeto_final_flutter/1.0';

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
    debugPrint('getPlaceByPosition called');

    final currentUser = AuthService().currentUser;

    if (currentUser == null) {
      throw Exception('No user is logged in');
    }

    if (currentUser.email == null) {
      throw Exception('User email is invalid');
    }

    final userEmail = currentUser.email!;

    final latitude = position.latitude;
    final longitude = position.longitude;

    final url = '$_apiUrl&lat=$latitude&lon=$longitude';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent': '$_userAgent $userEmail',
        'Accept-Language': 'en',
      },
    );

    debugPrint(response.toString());
    debugPrint(response.body);

    debugPrint('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final place = Place.fromJson(body);
      debugPrint(place.toString());
      return place;
    } else {
      final msg =
          'An exception has occurred while trying to get the position. '
          'Status code :${response.statusCode}';
      debugPrint(msg);
      throw Exception(msg);
    }
  }
}
