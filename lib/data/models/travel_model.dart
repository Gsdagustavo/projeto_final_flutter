import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../domain/entities/enums.dart';
import '../../domain/entities/travel.dart';
import '../local/database/tables/travel_table.dart';
import 'participant_model.dart';
import 'travel_stop_model.dart';

/// Model class to represent a [Travel].
///
/// This model class contains methods to manipulate travel data, such as
/// fromMap, toMap, fromEntity, toEntity, and other serialization/deserialization
/// operations. It stores information about travel title, start and end dates,
/// transport type, status, participants, stops, and associated photos.
class TravelModel {
  /// Unique identifier for the travel.
  final String id;

  /// Title of the travel.
  final String travelTitle;

  /// Start date of the travel.
  final DateTime startDate;

  /// End date of the travel.
  final DateTime endDate;

  /// Transport type used for the travel.
  final TransportType transportType;

  /// List of participants involved in the travel.
  final List<ParticipantModel> participants;

  /// List of stops in this travel.
  final List<TravelStopModel> stops;

  /// Status of the travel.
  final TravelStatus status;

  /// Photos associated with the travel.
  final List<File?> photos;

  /// Named constructor for creating a [TravelModel] instance.
  ///
  /// [id] is the unique identifier (auto-generated if null).
  /// [travelTitle] is the title of the travel.
  /// [startDate] and [endDate] are the travel dates.
  /// [transportType] is the type of transport used.
  /// [participants] is the list of participants.
  /// [stops] is the list of travel stops.
  /// [photos] is the list of photos associated with the travel.
  /// [status] is the current status of the travel.
  TravelModel({
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

  /// Creates a [TravelModel] from a [Map] (e.g., from database row).
  ///
  /// [map] contains the database row data.
  /// [participants] is the list of participants.
  /// [stops] is the list of travel stops.
  /// [photos] is the list of photos associated with the travel.
  factory TravelModel.fromMap(
    Map<String, dynamic> map, {
    required List<ParticipantModel> participants,
    required List<TravelStopModel> stops,
    required List<File> photos,
    required TravelStatus status,
  }) {
    return TravelModel(
      id: map[TravelTable.travelId],
      travelTitle: map[TravelTable.travelTitle] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(
        map[TravelTable.startDate] as int,
      ),
      endDate: DateTime.fromMillisecondsSinceEpoch(
        map[TravelTable.endDate] as int,
      ),
      transportType: TransportType.values[map[TravelTable.transportType]],
      status: status,
      participants: participants,
      stops: stops,
      photos: photos,
    );
  }

  /// Converts this [TravelModel] into a [Map] for database storage.
  Map<String, dynamic> toMap() {
    return {
      TravelTable.travelId: id,
      TravelTable.travelTitle: travelTitle,
      TravelTable.startDate: startDate.millisecondsSinceEpoch,
      TravelTable.endDate: endDate.millisecondsSinceEpoch,
      TravelTable.transportType: transportType.index,
    };
  }

  /// Creates a [TravelModel] from a domain [Travel] entity.
  factory TravelModel.fromEntity(Travel travel) {
    return TravelModel(
      id: travel.id,
      travelTitle: travel.travelTitle,
      startDate: travel.startDate,
      endDate: travel.endDate,
      transportType: travel.transportType,
      participants: travel.participants
          .map(ParticipantModel.fromEntity)
          .toList(),
      stops: travel.stops.map(TravelStopModel.fromEntity).toList(),
      photos: travel.photos,
      status: travel.status,
    );
  }

  /// Converts this [TravelModel] to a domain [Travel] entity.
  Travel toEntity() {
    return Travel(
      id: id,
      travelTitle: travelTitle,
      startDate: startDate,
      endDate: endDate,
      transportType: transportType,
      participants: participants.map((p) => p.toEntity()).toList(),
      stops: stops.map((s) => s.toEntity()).toList(),
      photos: photos,
      status: status,
    );
  }

  /// Creates a copy of this [TravelModel] with optional updated fields.
  TravelModel copyWith({
    String? id,
    String? travelTitle,
    DateTime? startDate,
    DateTime? endDate,
    TransportType? transportType,
    List<ParticipantModel>? participants,
    List<TravelStopModel>? stops,
    TravelStatus? status,
    List<File>? photos,
  }) {
    return TravelModel(
      id: id ?? this.id,
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
    return 'TravelModel{id: $id, travelTitle: $travelTitle, '
        'startDate: $startDate, endDate: $endDate, '
        'transportType: $transportType, participants: $participants, '
        'stops: $stops, status: $status, photos: $photos}';
  }
}
