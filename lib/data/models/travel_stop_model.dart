import '../../domain/entities/enums.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/travel_stop.dart';
import '../local/database/tables/travel_stop_table.dart';
import 'place_model.dart';
import 'review_model.dart';

/// Model class to represent a [TravelStop].
///
/// This model class contains methods to manipulate travel stop data, such as
/// fromMap, toMap, fromEntity, toEntity, and other serialization/deserialization
/// operations. It stores information about arrival and leave dates, stop type,
/// location (place), associated experiences, and reviews.
class TravelStopModel {
  /// Unique identifier for the travel stop.
  final String id;

  /// Arrival date at this travel stop.
  DateTime? arriveDate;

  /// Leave date from this travel stop.
  DateTime? leaveDate;

  /// Type of the travel stop (start, middle, end).
  TravelStopType type;

  /// Location associated with the travel stop.
  final PlaceModel place;

  /// List of experiences at this travel stop.
  final List<Experience>? experiences;

  /// List of reviews related to this travel stop.
  final List<ReviewModel>? reviews;

  /// Named constructor for creating a new [TravelStopModel] instance.
  ///
  /// [id] is the unique identifier of the travel stop.
  /// [place] is the associated location.
  /// [type] is the travel stop type (default is `TravelStopType.start`).
  /// [arriveDate] is the arrival date/time.
  /// [leaveDate] is the leave date/time.
  /// [experiences] is a list of experiences at this stop.
  /// [reviews] is a list of reviews related to this stop.
  TravelStopModel({
    required this.id,
    required this.place,
    this.type = TravelStopType.start,
    this.arriveDate,
    this.leaveDate,
    this.experiences,
    this.reviews,
  });

  /// Creates a [TravelStopModel] from a database [Map].
  ///
  /// [map] contains the database row for the travel stop.
  /// [experiences] is the list of experiences at this stop.
  /// [reviews] is the list of reviews at this stop.
  /// [place] is the associated [PlaceModel].
  factory TravelStopModel.fromMap(
      Map<String, dynamic> map,
      List<Experience> experiences,
      List<Review>? reviews,
      PlaceModel place,
      ) {
    final arriveDate = map[TravelStopTable.arriveDate] != null
        ? DateTime.fromMillisecondsSinceEpoch(map[TravelStopTable.arriveDate])
        : null;

    final leaveDate = map[TravelStopTable.leaveDate] != null
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

  /// Converts this [TravelStopModel] into a [Map] for database storage.
  Map<String, dynamic> toMap() {
    return {
      TravelStopTable.travelStopId: id,
      TravelStopTable.type: type.name,
      TravelStopTable.arriveDate: arriveDate?.millisecondsSinceEpoch,
      TravelStopTable.leaveDate: leaveDate?.millisecondsSinceEpoch,
    };
  }

  /// Creates a [TravelStopModel] from a domain [TravelStop] entity.
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

  /// Converts this [TravelStopModel] to a domain [TravelStop] entity.
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

  /// Creates a copy of this [TravelStopModel] with optional updated fields.
  TravelStopModel copyWith({
    String? id,
    DateTime? arriveDate,
    DateTime? leaveDate,
    TravelStopType? type,
    PlaceModel? place,
    List<Experience>? experiences,
    List<ReviewModel>? reviews,
  }) {
    return TravelStopModel(
      id: id ?? this.id,
      arriveDate: arriveDate ?? this.arriveDate,
      leaveDate: leaveDate ?? this.leaveDate,
      type: type ?? this.type,
      place: place ?? this.place,
      experiences: experiences ?? this.experiences,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  String toString() {
    return 'TravelStopModel{id: $id, arriveDate: $arriveDate, leaveDate: $leaveDate, '
        'type: $type, experiences: $experiences, place: $place, reviews: $reviews}';
  }
}
