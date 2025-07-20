import '../../data/local/database/tables/travel_stop_table.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/travel_stop.dart';

class TravelStopModel {
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

  TravelStopModel({
    this.travelStopId,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.arriveDate,
    required this.leaveDate,
    this.experiences,
  });

  factory TravelStopModel.fromMap(
    Map<String, dynamic> map,
    List<Experience> experiences,
  ) {
    return TravelStopModel(
      travelStopId: map[TravelStopTable.travelStopId],
      cityName: map[TravelStopTable.cityName],
      latitude: map[TravelStopTable.latitude] as double,
      longitude: map[TravelStopTable.longitude] as double,
      arriveDate: DateTime.fromMillisecondsSinceEpoch(
        map[TravelStopTable.arriveDate],
      ),
      leaveDate: DateTime.fromMillisecondsSinceEpoch(
        map[TravelStopTable.leaveDate],
      ),
      experiences: experiences,
    );
  }

  /// Returns a Map with Travel Stop data
  Map<String, dynamic> toMap() {
    return {
      TravelStopTable.travelStopId: travelStopId,
      TravelStopTable.cityName: cityName,
      TravelStopTable.latitude: latitude,
      TravelStopTable.longitude: longitude,
      TravelStopTable.arriveDate: arriveDate.millisecondsSinceEpoch,
      TravelStopTable.leaveDate: leaveDate.millisecondsSinceEpoch,
    };
  }

  factory TravelStopModel.fromEntity(TravelStop travelStop) {
    return TravelStopModel(
      cityName: travelStop.cityName,
      latitude: travelStop.latitude,
      longitude: travelStop.longitude,
      arriveDate: travelStop.arriveDate,
      leaveDate: travelStop.leaveDate,
      experiences: travelStop.experiences,
    );
  }

  TravelStop toEntity() {
    return TravelStop(
      cityName: cityName,
      latitude: latitude,
      longitude: longitude,
      arriveDate: arriveDate,
      leaveDate: leaveDate,
      experiences: experiences,
    );
  }

  @override
  String toString() {
    return 'TravelStopModel{travelStopId: $travelStopId, cityName: $cityName, latitude: $latitude, longitude: $longitude, arriveDate: $arriveDate, leaveDate: $leaveDate, experiences: $experiences}';
  }
}
