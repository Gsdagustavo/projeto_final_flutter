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
  List<Experience>? experiences;

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

    print('Stop copywith called. old stop: $this');

    final stop = TravelStop(
      place: place ?? this.place,
      travelStopId: travelStopId ?? this.travelStopId,
      arriveDate: arriveDate ?? this.arriveDate,
      leaveDate: leaveDate ?? this.leaveDate,
      type: type ?? this.type,
      experiences: experiences ?? this.experiences,
      reviews: reviews ?? this.reviews,
    );

    print('Stop copywith called. new stop: $stop');

    return stop;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TravelStop &&
              runtimeType == other.runtimeType &&
              travelStopId == other.travelStopId;

  @override
  int get hashCode => travelStopId.hashCode;


  @override
  String toString() {
    return 'TravelStop{travelStopId: $travelStopId, arriveDate: $arriveDate, '
        'leaveDate: $leaveDate, type: $type, experiences: $experiences, '
        'place: $place}';
  }
}
