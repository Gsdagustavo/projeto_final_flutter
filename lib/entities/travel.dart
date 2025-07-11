import '../data/local/database/tables/travel_table.dart';
import 'enums.dart';
import 'participant.dart';
import 'travel_stop.dart';

/// Represents a Travel
class Travel {
  int? travelId;
  final String travelTitle;
  final DateTime? startDate;
  final DateTime? endDate;
  final TransportType transportType;
  final List<Participant> participants;
  final List<TravelStop> stops;

  /// Named constructor for the Travel
  Travel({
    this.travelId,
    required this.travelTitle,
    required this.participants,
    required this.startDate,
    required this.endDate,
    required this.transportType,
    required this.stops,
  });

  factory Travel.fromMap(
    Map<String, dynamic> map, {
    required List<Participant> participants,
    required List<TravelStop> stops,
  }) {
    return Travel(
      travelId: map[TravelTable.travelId],
      travelTitle: map[TravelTable.travelTitle],
      startDate: DateTime.fromMillisecondsSinceEpoch(
        map[TravelTable.startDate],
      ),
      endDate: DateTime.fromMillisecondsSinceEpoch(map[TravelTable.endDate]),
      transportType: TransportType.values[map[TravelTable.transportType]],
      participants: participants,
      stops: stops,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      TravelTable.travelTitle: travelTitle,
      TravelTable.startDate: startDate?.millisecondsSinceEpoch,
      TravelTable.endDate: endDate?.millisecondsSinceEpoch,
      TravelTable.transportType: transportType.index,
    };

    if (travelId != null) {
      map['travelId'] = travelId!;
    }

    return map;
  }

  /// Returns a [Duration] that represents the total duration of the travel
  Duration get totalDuration => endDate!.difference(startDate!);

  @override
  String toString() {
    return 'Travel{travelId: $travelId, travelTitle: $travelTitle, startDate: $startDate, endDate: $endDate, transportType: $transportType, participants: $participants, stops: $stops}';
  }
}
