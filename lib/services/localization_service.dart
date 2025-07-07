import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  static const String _apiUrl =
      'https://nominatim.openstreetmap.org/reverse?format=jsonv2';

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

  Future<void> getAddressByPosition(Position position) async {
    final latitude = position.latitude;
    final longitude = position.longitude;

    final url = '$_apiUrl&lat=$latitude&lon=$longitude';
    final response = await http.get(Uri.parse(url));

    final body = jsonDecode(response.body);
    debugPrint('Body: $body');
  }
}
