import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocalizationService {
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
}
