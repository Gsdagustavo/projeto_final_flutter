import 'dart:io';

import 'package:uuid/uuid.dart';

import 'enums.dart';
import 'participant.dart';
import 'travel_stop.dart';

/// Represents a Travel record in the application's database
class Travel {
  /// Travel Id
  final String id;

  /// Travel Title
  String travelTitle;

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

  /// Returns a [Duration] that represents the total duration of the travel
  int get totalDuration {
    final diff = endDate.difference(startDate).inDays;

    if (diff == 0) return 1;

    return diff;
  }

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

  int get numCountries {
    return stops.map((e) => e.place.country).toSet().length;
  }

  List<String?> get countries {
    return stops.map((e) => e.place.country).toSet().toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Travel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
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
    id,
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
    return 'Travel{travelId: $id, travelTitle: $travelTitle, startDate: $startDate, endDate: $endDate, transportType: $transportType, participants: $participants, stops: $stops, status: $status, photos: $photos}';
  }
}
