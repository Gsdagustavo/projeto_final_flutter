import '../../core/util/binary_utils.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/travel.dart';
import '../local/database/tables/travel_table.dart';
import 'participant_model.dart';
import 'travel_stop_model.dart';

class TravelModel {
  int? travelId;
  final String travelTitle;
  final DateTime? startDate;
  final DateTime? endDate;
  final TransportType transportType;
  final List<ParticipantModel> participants;
  final List<TravelStopModel> stops;
  bool isFinished;

  TravelModel({
    this.travelId,
    this.isFinished = false,
    required this.travelTitle,
    required this.startDate,
    required this.endDate,
    required this.transportType,
    required this.participants,
    required this.stops,
  });

  /// Factory to create a model from a Map (e.g. from database)
  factory TravelModel.fromMap(
    Map<String, dynamic> map, {
    required List<ParticipantModel> participants,
    required List<TravelStopModel> stops,
  }) {
    return TravelModel(
      travelId: map[TravelTable.travelId],
      travelTitle: map[TravelTable.travelTitle] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(
        map[TravelTable.startDate] as int,
      ),
      endDate: DateTime.fromMillisecondsSinceEpoch(
        map[TravelTable.endDate] as int,
      ),
      transportType: TransportType.values[map[TravelTable.transportType]],
      participants: participants,
      stops: stops,
      isFinished: intToBool((map[TravelTable.isFinished] as int)),
    );
  }

  /// Converts this model to a Map (e.g. for database storage)
  Map<String, dynamic> toMap() {
    final map = {
      TravelTable.travelId: travelId,
      TravelTable.travelTitle: travelTitle,
      TravelTable.startDate: startDate?.millisecondsSinceEpoch,
      TravelTable.endDate: endDate?.millisecondsSinceEpoch,
      TravelTable.transportType: transportType.index,
      TravelTable.isFinished: boolToInt(isFinished),
    };

    return map;
  }

  factory TravelModel.fromEntity(Travel travel) {
    return TravelModel(
      travelId: travel.travelId,
      travelTitle: travel.travelTitle,
      startDate: travel.startDate,
      endDate: travel.endDate,
      transportType: travel.transportType,
      participants: travel.participants
          .map(ParticipantModel.fromEntity)
          .toList(),
      stops: travel.stops.map(TravelStopModel.fromEntity).toList(),
      isFinished: travel.isFinished,
    );
  }

  Travel toEntity() {
    return Travel(
      travelId: travelId,
      travelTitle: travelTitle,
      startDate: startDate,
      endDate: endDate,
      transportType: transportType,
      participants: participants.map((p) => p.toEntity()).toList(),
      stops: stops.map((s) => s.toEntity()).toList(),
      isFinished: isFinished,
    );
  }

  TravelModel copyWith({
    int? travelId,
    String? travelTitle,
    DateTime? startDate,
    DateTime? endDate,
    TransportType? transportType,
    List<ParticipantModel>? participants,
    List<TravelStopModel>? stops,
    bool? isFinished,
  }) {
    return TravelModel(
      travelId: travelId ?? this.travelId,
      travelTitle: travelTitle ?? this.travelTitle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      transportType: transportType ?? this.transportType,
      participants: participants ?? this.participants,
      stops: stops ?? this.stops,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  @override
  String toString() {
    return 'TravelModel{travelId: $travelId, travelTitle: $travelTitle, '
        'startDate: $startDate, endDate: $endDate, '
        'transportType: $transportType, participants: $participants, '
        'stops: ${stops.toString()}}';
  }
}
