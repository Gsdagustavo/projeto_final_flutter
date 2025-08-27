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
  final DateTime? startDate;

  /// Travel end date
  final DateTime? endDate;

  /// Travel transport type
  final TransportType transportType;

  /// Travel participants
  final List<Participant> participants;

  /// Travel stops
  final List<TravelStop> stops;

  final TravelStatus status;

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
  Duration get totalDuration => endDate!.difference(startDate!);

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
  String toString() {
    return 'Travel{travelId: $travelId, travelTitle: $travelTitle, startDate: $startDate, endDate: $endDate, transportType: $transportType, participants: $participants, stops: $stops, status: $status, photos: $photos}';
  }
}
