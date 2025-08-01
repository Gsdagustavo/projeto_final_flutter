import '../../data/local/database/tables/travel_stop_table.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/travel_stop.dart';
import 'place_model.dart';

class TravelStopModel {
  /// Travel Stop ID
  int? travelStopId;

  /// Travel Stop arrive date
  final DateTime? arriveDate;

  /// Travel Stop leave date
  final DateTime? leaveDate;

  final TravelStopType type;

  /// Travel Stop experiences
  final List<Experience>? experiences;

  final PlaceModel place;

  TravelStopModel({
    required this.place,
    this.travelStopId,
    required this.type,
    this.arriveDate,
    this.leaveDate,
    this.experiences,
  });

  factory TravelStopModel.fromMap(
    Map<String, dynamic> map,
    List<Experience> experiences,
    PlaceModel place,
  ) {
    DateTime? arriveDate = map[TravelStopTable.arriveDate] != null
        ? DateTime.fromMillisecondsSinceEpoch(map[TravelStopTable.arriveDate])
        : null;

    DateTime? leaveDate = map[TravelStopTable.leaveDate] != null
        ? DateTime.fromMillisecondsSinceEpoch(map[TravelStopTable.leaveDate])
        : null;

    return TravelStopModel(
      travelStopId: map[TravelStopTable.travelStopId],
      arriveDate: arriveDate,
      leaveDate: leaveDate,
      type: TravelStopType.values.byName(map[TravelStopTable.type]),
      experiences: experiences,
      place: place,
    );
  }

  /// Returns a Map with Travel Stop data
  Map<String, dynamic> toMap() {
    return {
      TravelStopTable.travelStopId: travelStopId,
      TravelStopTable.type: type.name,
      TravelStopTable.arriveDate: arriveDate?.millisecondsSinceEpoch,
      TravelStopTable.leaveDate: leaveDate?.millisecondsSinceEpoch,
    };
  }

  factory TravelStopModel.fromEntity(TravelStop travelStop) {
    return TravelStopModel(
      place: PlaceModel.fromEntity(travelStop.place),
      travelStopId: travelStop.travelStopId,
      type: travelStop.type,
      arriveDate: travelStop.arriveDate,
      leaveDate: travelStop.leaveDate,
      experiences: travelStop.experiences,
    );
  }

  TravelStop toEntity() {
    return TravelStop(
      place: place.toEntity(),
      travelStopId: travelStopId,
      type: type,
      arriveDate: arriveDate,
      leaveDate: leaveDate,
      experiences: experiences,
    );
  }

  @override
  String toString() {
    return 'TravelStopModel{travelStopId: $travelStopId, arriveDate: $arriveDate, leaveDate: $leaveDate, type: $type, experiences: $experiences, place: $place}';
  }
}
