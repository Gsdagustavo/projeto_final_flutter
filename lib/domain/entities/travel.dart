import 'dart:io';

import 'package:uuid/uuid.dart';

import 'enums.dart';
import 'participant.dart';
import 'travel_stop.dart';

/// Represents a [Travel] record in the application's database.
///
/// This class stores information about a travel, including title,
/// start and end dates, transport type, associated participants, travel stops,
/// status, and photos.
///
/// It provides utility methods for duration, countries visited, and copying/updating the travel.
class Travel {
  /// Unique identifier for the travel.
  ///
  /// Automatically generated using a UUID if not provided.
  final String id;

  /// Title of the travel.
  String travelTitle;

  /// Start date of the travel.
  DateTime startDate;

  /// End date of the travel.
  DateTime endDate;

  /// Mode of transport used for the travel.
  final TransportType transportType;

  /// List of participants in this travel.
  final List<Participant> participants;

  /// List of stops included in this travel.
  final List<TravelStop> stops;

  /// Current status of the travel.
  TravelStatus status;

  /// List of photos associated with the travel.
  final List<File?> photos;

  /// Named constructor for [Travel].
  ///
  /// Creates a new [Travel] instance with required fields [travelTitle],
  /// [startDate], [endDate], [transportType], [participants], [stops],
  /// and [photos].
  ///
  /// The [id] is optional; if not provided, a new UUID will be generated
  /// automatically.
  ///
  /// The [status] defaults to [TravelStatus.upcoming].
  Travel({
    String? id,
    required this.travelTitle,
    required this.startDate,
    required this.endDate,
    required this.transportType,
    required this.participants,
    required this.stops,
    required this.photos,
    this.status = TravelStatus.upcoming,
  }) : id = id ?? Uuid().v4();

  /// Returns the total duration of the travel in days.
  ///
  /// If the start and end date are the same day, returns 1.
  int get totalDuration {
    final diff = endDate
        .difference(startDate)
        .inDays;
    return diff == 0 ? 1 : diff;
  }

  /// Returns the total number of unique countries visited in this travel.
  int get numCountries {
    return stops
        .map((e) => e.place.country)
        .toSet()
        .length;
  }

  /// Returns a list of unique countries visited in this travel.
  List<String?> get countries {
    return stops.map((e) => e.place.country).toSet().toList();
  }

  /// Returns a copy of this [Travel] with optional updated fields.
  ///
  /// This allows updating any property while keeping the other values unchanged
  Travel copyWith({
    String? travelTitle,
    DateTime? startDate,
    DateTime? endDate,
    TransportType? transportType,
    List<Participant>? participants,
    List<TravelStop>? stops,
    TravelStatus? status,
    List<File>? photos,
  }) {
    return Travel(
      id: id,
      travelTitle: travelTitle ?? this.travelTitle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      transportType: transportType ?? this.transportType,
      participants: participants ?? this.participants,
      stops: stops ?? this.stops,
      status: status ?? this.status,
      photos: photos ?? this.photos,
    );
  }

  @override
  String toString() {
  return 'Travel{travelId: $id, travelTitle: $travelTitle, '
  'startDate: $startDate, endDate: $endDate, '
  'transportType: $transportType, participants: $participants, '
  'stops: $stops, status: $status, photos: $photos}';
  }
}
