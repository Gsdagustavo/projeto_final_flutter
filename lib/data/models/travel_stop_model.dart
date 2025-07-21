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
  final DateTime? arriveDate;

  /// Travel Stop leave date
  final DateTime? leaveDate;

  final TravelStopType type;

  /// Travel Stop experiences
  final List<Experience>? experiences;

  TravelStopModel({
    this.travelStopId,
    required this.type,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    this.arriveDate,
    this.leaveDate,
    this.experiences,
  });

  factory TravelStopModel.fromMap(
    Map<String, dynamic> map,
    List<Experience> experiences,
  ) {
    DateTime? arriveDate = map[TravelStopTable.arriveDate] != null
        ? DateTime.fromMillisecondsSinceEpoch(map[TravelStopTable.arriveDate])
        : null;

    DateTime? leaveDate = map[TravelStopTable.leaveDate] != null
        ? DateTime.fromMillisecondsSinceEpoch(map[TravelStopTable.leaveDate])
        : null;

    return TravelStopModel(
      travelStopId: map[TravelStopTable.travelStopId],
      cityName: map[TravelStopTable.cityName],
      latitude: map[TravelStopTable.latitude] as double,
      longitude: map[TravelStopTable.longitude] as double,
      arriveDate: arriveDate,
      leaveDate: leaveDate,
      type: TravelStopType.values.byName(map[TravelStopTable.type]),
      experiences: experiences,
    );
  }

  /// Returns a Map with Travel Stop data
  Map<String, dynamic> toMap() {
    return {
      TravelStopTable.travelStopId: travelStopId,
      TravelStopTable.type: type.name,
      TravelStopTable.cityName: cityName,
      TravelStopTable.latitude: latitude,
      TravelStopTable.longitude: longitude,
      TravelStopTable.arriveDate: arriveDate?.millisecondsSinceEpoch,
      TravelStopTable.leaveDate: leaveDate?.millisecondsSinceEpoch,
    };
  }

  factory TravelStopModel.fromEntity(TravelStop travelStop) {
    return TravelStopModel(
      travelStopId: travelStop.travelStopId,
      cityName: travelStop.cityName,
      type: travelStop.type,
      latitude: travelStop.latitude,
      longitude: travelStop.longitude,
      arriveDate: travelStop.arriveDate,
      leaveDate: travelStop.leaveDate,
      experiences: travelStop.experiences,
    );
  }

  TravelStop toEntity() {
    return TravelStop(
      travelStopId: travelStopId,
      cityName: cityName,
      type: type,
      latitude: latitude,
      longitude: longitude,
      arriveDate: arriveDate,
      leaveDate: leaveDate,
      experiences: experiences,
    );
  }
}
