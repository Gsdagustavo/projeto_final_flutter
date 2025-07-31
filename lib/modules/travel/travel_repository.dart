import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/local/database/database.dart';
import '../../data/local/database/tables/addresses_table.dart';
import '../../data/local/database/tables/experiences_table.dart';
import '../../data/local/database/tables/participants_table.dart';
import '../../data/local/database/tables/places_table.dart';
import '../../data/local/database/tables/travel_participants_table.dart';
import '../../data/local/database/tables/travel_stop_experiences_table.dart';
import '../../data/local/database/tables/travel_stop_table.dart';
import '../../data/local/database/tables/travel_table.dart';
import '../../data/models/address_model.dart';
import '../../data/models/participant_model.dart';
import '../../data/models/place_model.dart';
import '../../data/models/travel_model.dart';
import '../../data/models/travel_stop_model.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/travel.dart';

/// This interface defines all necessary methods to register a [Travel]
/// and get all [Travels]
abstract class TravelRepository {
  /// Register a new travel
  ///
  /// [travel]: The travel which will be registered
  Future<void> registerTravel({required Travel travel});

  /// Returns a [List] of [Travel] containing all registered travels
  Future<List<Travel>> getAllTravels();
}

/// Concrete implementation of [TravelRepository], using local SQLite database
///
/// This class realizes all necessary implementations to register a [Travel]
/// and get all [Travels], consulting the [TravelTable], [TravelStopTable],
/// [TravelStopExperiencesTable] and [ParticipantsTable] tables
class TravelRepositoryImpl implements TravelRepository {
  late final Future<Database> _db = DBConnection().getDatabase();

  @override
  Future<void> registerTravel({required Travel travel}) async {
    final db = await _db;

    for (final (index, stop) in travel.stops.indexed) {
      debugPrint('$index: $stop');
    }

    final travelModel = TravelModel(
      travelTitle: travel.travelTitle,
      startDate: travel.startDate,
      endDate: travel.endDate,
      transportType: travel.transportType,
      participants: travel.participants
          .map(ParticipantModel.fromEntity)
          .toList(),
      stops: travel.stops.map(TravelStopModel.fromEntity).toList(),
    );

    debugPrint('Inserting Travel ${travelModel.toString()}');

    await db.transaction((txn) async {
      final travelId = await txn.insert(
        TravelTable.tableName,
        travelModel.toMap(),
      );

      travelModel.travelId = travelId;

      final stops = travelModel.stops;

      /// Insert stops into [TravelStop] and [TravelStopExperiences] table
      for (final stop in stops) {
        await _insertStop(txn, stop, travelId);
      }

      /// Insert participants into [ParticipantsTable] and [TravelParticipantsTable]
      for (final participant in travelModel.participants) {
        final participantId = await txn.insert(
          ParticipantsTable.tableName,
          participant.toMap(),
        );

        participant.id = participantId;

        await txn.insert(
          TravelParticipantsTable.tableName,
          _toTravelParticipantsMap(participantId, travelId),
        );
      }
    });
  }

  Future<void> _insertStop(
    DatabaseExecutor txn,
    TravelStopModel stop,
    int travelId,
  ) async {
    /// Insert into [AddressesTable]
    final addressMap = stop.place.address.toMap();
    final addressId = await txn.insert(AddressesTable.tableName, addressMap);

    final placeMap = stop.place.fromMap(addressId);

    /// Insert into [PlacesTable]
    await txn.insert(PlacesTable.tableName, placeMap);

    final stopMap = stop.toMap();
    stopMap[TravelStopTable.travelId] = travelId;
    stopMap[TravelStopTable.placeId] = stop.place.placeId;

    /// Insert stop into [TravelStopsTable]
    final stopId = await txn.insert(TravelStopTable.tableName, stopMap);
    stop.travelStopId = stopId;

    debugPrint('Stop ID: $stopId');

    /// Insert experiences into [TravelStopExperiencesTable]
    if (stop.experiences != null && stop.experiences!.isNotEmpty) {
      for (final experience in stop.experiences!) {
        await txn.insert(TravelStopExperiencesTable.tableName, {
          TravelStopExperiencesTable.travelStopId: stopId,
          TravelStopExperiencesTable.experience: experience.name,
        });
      }
    }

    debugPrint('Travel stop $stop added to database');
  }

  @override
  Future<List<Travel>> getAllTravels() async {
    final db = await _db;

    final travels = <TravelModel>[];

    await db.transaction((txn) async {
      final travelsResult = await txn.query(TravelTable.tableName);

      for (final travelResult in travelsResult) {
        final travelId = travelResult[TravelTable.travelId] as int;

        /// Participants
        final participants = <ParticipantModel>[];

        final travelParticipants = await txn.query(
          TravelParticipantsTable.tableName,
          where: '${TravelParticipantsTable.travelId} = ?',
          whereArgs: [travelId],
        );

        for (final tp in travelParticipants) {
          final participantId = tp[ParticipantsTable.participantId] as int;

          final participantData = await txn.query(
            ParticipantsTable.tableName,
            where: '${ParticipantsTable.participantId} = ?',
            whereArgs: [participantId],
          );

          if (participantData.isNotEmpty) {
            participants.add(ParticipantModel.fromMap(participantData.first));
          }
        }

        /// Stops
        final stops = <TravelStopModel>[];

        final stopData = await txn.query(
          TravelStopTable.tableName,
          where: '${TravelStopTable.travelId} = ?',
          whereArgs: [travelId],
        );

        for (final stop in stopData) {
          final stopId = stop[TravelStopTable.travelStopId];
          final placeId = stop[TravelStopTable.placeId];

          if (stopId == null || placeId == null) return;

          final experiences = <Experience>[];
          final experiencesMap = await txn.query(
            TravelStopExperiencesTable.tableName,
            where: '${TravelStopExperiencesTable.travelStopId} = ?',
            whereArgs: [stopId],
          );

          for (final experienceMap in experiencesMap) {
            final name = experienceMap[ExperiencesTable.experience] as String;
            experiences.add(Experience.values.byName(name));
          }

          final placeMap = await txn.query(
            PlacesTable.tableName,
            where: '${PlacesTable.placeId} = ?',
            whereArgs: [placeId],
          );

          if (placeMap.isEmpty) continue;

          final placeData = placeMap.first;
          final addressId = placeData[PlacesTable.addressId];

          final addressMap = await txn.query(
            AddressesTable.tableName,
            where: '${AddressesTable.addressId} = ?',
            whereArgs: [addressId],
          );

          if (addressMap.isEmpty) continue;

          final addressModel = AddressModel.fromMap(addressMap.first);
          final placeModel = PlaceModel.toMap(placeData, addressModel);

          final travelStopModel = TravelStopModel.fromMap(
            stop,
            experiences,
            placeModel,
          );

          stops.add(travelStopModel);
        }

        travels.add(
          TravelModel.fromMap(
            travelResult,
            participants: participants,
            stops: stops,
          ),
        );
      }
    });

    for (final travel in travels) {
      debugPrint('Travel: $travel');

      for (final travelStop in travel.stops) {
        debugPrint('Stop: ${travelStop.toString()}');
      }
    }
    return travels.map((e) => e.toEntity()).toList();
  }

  /// Auxiliary method that returns a Map from the given [participantId]
  /// and [travelId]
  static Map<String, dynamic> _toTravelParticipantsMap(
    int participantId,
    int travelId,
  ) {
    return {
      TravelParticipantsTable.travelId: travelId,
      TravelParticipantsTable.participantId: participantId,
    };
  }
}
