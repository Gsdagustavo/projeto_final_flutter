import 'package:projeto_final_flutter/entities/travel_stop.dart';

class Travel {
  final String travelName;
  final DateTime startTime;
  final DateTime endTime;

  /// TODO: implement a way of internationalize the ways of transportation and experiences
  final String transportation;
  final List<String> experiences;

  /// Stops places
  final List<TravelStop> stops;

  /// TODO: create a map based on the stops

  Travel({
    required this.travelName,
    required this.startTime,
    required this.endTime,
    required this.transportation,
    required this.experiences,
    required this.stops,
  });

  Duration get totalDuration => endTime.difference(startTime);
}
