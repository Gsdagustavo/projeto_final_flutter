import 'package:projeto_final_flutter/entities/enums.dart';
import 'package:projeto_final_flutter/entities/participant.dart';
import 'package:projeto_final_flutter/entities/travel_stop.dart';

class Travel {
  final String travelTitle;
  final List<Participant> participants;
  final DateTime startTime;
  final DateTime endTime;
  final TransportType transportType;
  final List<Experience> experiences;
  final List<TravelStop> stops;

  /// TODO: create a graphical map based on the stops

  Travel({
    required this.travelTitle,
    required this.participants,
    required this.startTime,
    required this.endTime,
    required this.transportType,
    required this.experiences,
    required this.stops,
  });

  Duration get totalDuration => endTime.difference(startTime);
}
