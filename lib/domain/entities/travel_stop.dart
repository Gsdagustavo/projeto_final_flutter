import 'enums.dart';
import 'place.dart';
import 'review.dart';

class TravelStop {
  /// Travel Stop ID
  int? travelStopId;

  /// Travel Stop arrive date
  DateTime? arriveDate;

  /// Travel Stop leave date
  DateTime? leaveDate;

  TravelStopType type;

  /// Travel Stop experiences
  final List<Experience>? experiences;

  final Place place;

  final List<Review>? reviews;

  /// Named constructor for the Travel Stop
  TravelStop({
    required this.place,
    this.travelStopId,
    this.type = TravelStopType.start,
    this.arriveDate,
    this.leaveDate,
    this.experiences,
    this.reviews,
  });

  TravelStop copyWith({
    Place? place,
    int? travelStopId,
    DateTime? arriveDate,
    DateTime? leaveDate,
    TravelStopType? type,
    List<Experience>? experiences,
    List<Review>? reviews,
  }) {
    return TravelStop(
      place: place ?? this.place,
      travelStopId: travelStopId ?? this.travelStopId,
      arriveDate: arriveDate ?? this.arriveDate,
      leaveDate: leaveDate ?? this.leaveDate,
      type: type ?? this.type,
      experiences: experiences ?? this.experiences,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  String toString() {
    return 'TravelStop{travelStopId: $travelStopId, arriveDate: $arriveDate, '
        'leaveDate: $leaveDate, type: $type, experiences: $experiences, '
        'place: $place}';
  }
}
