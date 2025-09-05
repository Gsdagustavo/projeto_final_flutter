import 'package:uuid/uuid.dart';
import 'enums.dart';
import 'place.dart';
import 'review.dart';

/// Represents a [TravelStop] in a travel itinerary.
///
/// This class stores information about a stop during a travel, including arrival
/// and leave dates, stop type, location (place), associated experiences, and reviews.
/// It provides utility methods for copying and comparing travel stops.
class TravelStop {
  /// Unique identifier for the travel stop.
  ///
  /// Automatically generated using a UUID if not provided.
  final String id;

  /// Arrival date and time for the travel stop.
  ///
  /// Can be null if the stop has no recorded arrival time yet.
  DateTime? arriveDate;

  /// Departure date and time for the travel stop.
  ///
  /// Can be null if the stop has no recorded leave time yet.
  DateTime? leaveDate;

  /// Type of the travel stop (start, stop, end).
  TravelStopType type;

  /// List of experiences associated with this travel stop.
  ///
  /// Can be null if no experiences are recorded.
  List<Experience>? experiences;

  /// Location information for the travel stop.
  ///
  /// Stored as a [Place] object containing city, state, country, and coordinates.
  final Place place;

  /// List of reviews associated with this travel stop.
  ///
  /// Can be null if no reviews have been made.
  final List<Review>? reviews;

  /// Named constructor for [TravelStop].
  ///
  /// Creates a new travel stop with required [place].
  /// The [id] is optional; if not provided, a new UUID will be generated.
  /// The [type] defaults to [TravelStopType.start].
  /// Arrival and leave dates, experiences, and reviews are optional.
  TravelStop({
    String? id,
    required this.place,
    this.type = TravelStopType.start,
    this.arriveDate,
    this.leaveDate,
    this.experiences,
    this.reviews,
  }) : id = id ?? Uuid().v4();

  /// Returns a copy of this [TravelStop] with optional updated fields.
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
