import 'dart:io';

import 'enums.dart';
import 'participant.dart';
import 'travel_stop.dart';

/// Represents a Travel record in the application's database
class Travel {
  /// Travel Id
  int? travelId;

  /// Travel Title
  final String travelTitle;

  /// Travel start date
  DateTime startDate;

  /// Travel end date
  DateTime endDate;

  /// Travel transport type
  final TransportType transportType;

  /// Travel participants
  final List<Participant> participants;

  /// Travel stops
  final List<TravelStop> stops;

  TravelStatus status;

  final List<File?> photos;

  Travel({
    this.travelId,
    required this.travelTitle,
    required this.startDate,
    required this.endDate,
    required this.transportType,
    required this.participants,
    required this.stops,
    required this.photos,
    this.status = TravelStatus.upcoming,
  });

  /// Returns a [Duration] that represents the total duration of the travel
  Duration get totalDuration => endDate.difference(startDate);

  Travel copyWith({
    int? travelId,
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
      travelId: travelId ?? this.travelId,
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Travel &&
          runtimeType == other.runtimeType &&
          travelId == other.travelId &&
          travelTitle == other.travelTitle &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          transportType == other.transportType &&
          participants == other.participants &&
          stops == other.stops &&
          status == other.status &&
          photos == other.photos;

  @override
  int get hashCode => Object.hash(
    travelId,
    travelTitle,
    startDate,
    endDate,
    transportType,
    participants,
    stops,
    status,
    photos,
  );

  @override
  String toString() {
    return 'Travel{travelId: $travelId, travelTitle: $travelTitle, startDate: $startDate, endDate: $endDate, transportType: $transportType, participants: $participants, stops: $stops, status: $status, photos: $photos}';
  }
}
