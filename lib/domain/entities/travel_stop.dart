import 'package:uuid/uuid.dart';

import 'enums.dart';
import 'place.dart';
import 'review.dart';

class TravelStop {
  /// Travel Stop ID
  final String id;

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
    String? id,
    required this.place,
    this.type = TravelStopType.start,
    this.arriveDate,
    this.leaveDate,
    this.experiences,
    this.reviews,
  }) : id = id ?? Uuid().v4();

  TravelStop copyWith({
    String? id,
    Place? place,
    DateTime? arriveDate,
    DateTime? leaveDate,
    TravelStopType? type,
    List<Experience>? experiences,
    List<Review>? reviews,
  }) {
    return TravelStop(
      id: id ?? this.id,
      place: place ?? this.place,
      arriveDate: arriveDate ?? this.arriveDate,
      leaveDate: leaveDate ?? this.leaveDate,
      type: type ?? this.type,
      experiences: experiences ?? this.experiences,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelStop && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TravelStop{id: $id, arriveDate: $arriveDate, '
        'leaveDate: $leaveDate, type: $type, experiences: $experiences, '
        'place: $place}';
  }
}
