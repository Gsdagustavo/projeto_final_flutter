import 'enums.dart';

class TravelStop {
  /// Travel Stop ID
  int? travelStopId;

  /// Travel Stop city name
  final String cityName;

  /// Travel Stop latitude
  final double latitude;

  /// Travel Stop longitude
  final double longitude;

  /// Travel Stop arrive date
  final DateTime arriveDate;

  /// Travel Stop leave date
  final DateTime leaveDate;

  /// Travel Stop experiences
  final List<Experience>? experiences;

  /// Named constructor for the Travel Stop
  TravelStop({
    this.travelStopId,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.arriveDate,
    required this.leaveDate,
    this.experiences,
  });

  @override
  String toString() {
    return 'TravelStop{travelStopId: $travelStopId, cityName: $cityName, latitude: $latitude, longitude: $longitude, arriveDate: $arriveDate, leaveDate: $leaveDate, experiences: $experiences}';
  }
}
