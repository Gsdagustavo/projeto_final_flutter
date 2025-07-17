import '../../data/local/database/tables/travel_stop_table.dart';
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

  /// Returns a Travel Stop from the given Map
  factory TravelStop.fromMap(
    Map<String, dynamic> map,
    List<Experience> experiences,
  ) {
    return TravelStop(
      travelStopId: map[TravelStopTable.travelStopId],
      cityName: map[TravelStopTable.cityName],
      latitude: map[TravelStopTable.latitude] as double,
      longitude: map[TravelStopTable.longitude] as double,
      arriveDate: DateTime.fromMillisecondsSinceEpoch(map['arriveDate']),
      leaveDate: DateTime.fromMillisecondsSinceEpoch(map['leaveDate']),
      experiences: experiences,
    );
  }

  /// Returns a Map with Travel Stop data
  Map<String, dynamic> toMap() {
    return {
      'travelStopId': travelStopId,
      'cityName': cityName,
      'latitude': latitude,
      'longitude': longitude,
      'arriveDate': arriveDate.millisecondsSinceEpoch,
      'leaveDate': leaveDate.millisecondsSinceEpoch,
    };
  }
}
