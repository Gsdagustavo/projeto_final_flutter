import '../database/tables/travel_stop_table.dart';
import 'enums.dart';

class TravelStop {
  int? travelStopId;
  final String cityName;
  final double latitude;
  final double longitude;
  final DateTime arriveDate;
  final DateTime leaveDate;
  final List<Experience>? experiences;

  TravelStop({
    this.travelStopId,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.arriveDate,
    required this.leaveDate,
    this.experiences,
  });

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
