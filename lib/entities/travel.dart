import 'enums.dart';
import 'participant.dart';
import 'travel_stop.dart';

/// Represents a Travel
class Travel {
  final String travelTitle;
  final List<Participant> participants;
  final DateTime startTime;
  final DateTime endTime;
  final TransportType transportType;
  final List<Experience> experiences;
  final List<TravelStop> stops;

  /// Named constructor for the Travel
  Travel({
    required this.travelTitle,
    required this.participants,
    required this.startTime,
    required this.endTime,
    required this.transportType,
    required this.experiences,
    required this.stops,
  });

  /// Returns a [Duration] that represents the total duration of the travel
  Duration get totalDuration => endTime.difference(startTime);
}
