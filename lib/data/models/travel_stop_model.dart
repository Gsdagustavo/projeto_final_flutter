import '../../data/local/database/tables/travel_stop_table.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/travel_stop.dart';
import 'place_model.dart';
import 'review_model.dart';

class TravelStopModel {
  /// Travel Stop ID
  final String id;

  /// Travel Stop arrive date
  DateTime? arriveDate;

  /// Travel Stop leave date
  DateTime? leaveDate;

  TravelStopType type;

  final PlaceModel place;

  /// Travel Stop experiences
  final List<Experience>? experiences;

  final List<ReviewModel>? reviews;

  /// Named constructor for the Travel Stop
  TravelStopModel({
    required this.id,
    required this.place,
    this.type = TravelStopType.start,
    this.arriveDate,
    this.leaveDate,
    this.experiences,
    this.reviews,
  });

  factory TravelStopModel.fromMap(
    Map<String, dynamic> map,
    List<Experience> experiences,
    List<Review>? reviews,
    PlaceModel place,
  ) {
    var arriveDate = map[TravelStopTable.arriveDate] != null
        ? DateTime.fromMillisecondsSinceEpoch(map[TravelStopTable.arriveDate])
        : null;

    var leaveDate = map[TravelStopTable.leaveDate] != null
        ? DateTime.fromMillisecondsSinceEpoch(map[TravelStopTable.leaveDate])
        : null;

    return TravelStopModel(
      id: map[TravelStopTable.travelStopId],
      arriveDate: arriveDate,
      leaveDate: leaveDate,
      type: TravelStopType.values.byName(map[TravelStopTable.type]),
      experiences: experiences,
      reviews: reviews?.map(ReviewModel.fromEntity).toList(),
      place: place,
    );
  }

  /// Returns a Map with Travel Stop data
  Map<String, dynamic> toMap() {
    return {
      TravelStopTable.travelStopId: id,
      TravelStopTable.type: type.name,
      TravelStopTable.arriveDate: arriveDate?.millisecondsSinceEpoch,
      TravelStopTable.leaveDate: leaveDate?.millisecondsSinceEpoch,
    };
  }

  factory TravelStopModel.fromEntity(TravelStop travelStop) {
    return TravelStopModel(
      place: PlaceModel.fromEntity(travelStop.place),
      id: travelStop.id,
      type: travelStop.type,
      arriveDate: travelStop.arriveDate,
      leaveDate: travelStop.leaveDate,
      experiences: travelStop.experiences,
      reviews: travelStop.reviews?.map(ReviewModel.fromEntity).toList(),
    );
  }

  TravelStop toEntity() {
    return TravelStop(
      place: place.toEntity(),
      id: id,
      type: type,
      arriveDate: arriveDate,
      leaveDate: leaveDate,
      experiences: experiences,
      reviews: reviews?.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  String toString() {
    return 'TravelStopModel{id: $id, '
        'arriveDate: $arriveDate, leaveDate: $leaveDate, type: $type, '
        'experiences: $experiences, place: $place}';
  }
}
