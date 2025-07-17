import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/local/database/database.dart';
import '../../data/local/database/tables/experiences_table.dart';
import '../../data/local/database/tables/participants_table.dart';
import '../../data/local/database/tables/travel_participants_table.dart';
import '../../data/local/database/tables/travel_stop_experiences_table.dart';
import '../../data/local/database/tables/travel_stop_table.dart';
import '../../data/local/database/tables/travel_table.dart';
import '../../data/local/database/util/experiences_util.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/travel.dart';
import '../../domain/entities/travel_stop.dart';

/// This interface defines all necessary methods to register a [Travel]
/// and get all [Travels]
abstract class TravelRepository {
  /// Register a new travel
  ///
  /// [travel]: The travel which will be registered
  Future<Travel?> registerTravel({required Travel travel});

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
  Future<Travel> registerTravel({required Travel travel}) async {
    final db = await _db;
    await db.transaction((txn) async {
      final travelId = await txn.insert(TravelTable.tableName, travel.toMap());
      travel.travelId = travelId;

      /// Insert stops into [TravelStop] and [TravelStopExperiences] table
      for (final stop in travel.stops) {
        final stopMap = <String, dynamic>{};
        stopMap.addAll(stop.toMap());
        stopMap[TravelStopTable.travelId] = travelId;

        final stopId = await txn.insert(TravelStopTable.tableName, stopMap);
        stop.travelStopId = stopId;

        /// Insert experiences into [TravelStopExperiencesTable]
        for (final experience in stop.experiences!) {
          final experienceId = await DatabaseEnumUtils().getIdByExperience(
            experience,
            txn,
          );

          await txn.insert(TravelStopExperiencesTable.tableName, {
            TravelStopExperiencesTable.travelStopId: stopId,
            TravelStopExperiencesTable.experienceId: experienceId,
          });
        }
      }

      /// Insert participants into [ParticipantsTable] and [TravelParticipantsTable]
      for (final participant in travel.participants) {
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

    return travel;
  }

  @override
  Future<List<Travel>> getAllTravels() async {
    final db = await _db;

    final travels = <Travel>[];

    await db.transaction((txn) async {
      final travelsResult = await txn.query(TravelTable.tableName);

      for (final travelResult in travelsResult) {
        final travelId = travelResult[TravelTable.travelId] as int;

        /// Participants
        final participants = <Participant>[];

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
            participants.add(Participant.fromMap(participantData.first));
          }
        }

        /// Stops
        final stops = <TravelStop>[];

        final stopData = await txn.query(
          TravelStopTable.tableName,
          where: '${TravelStopTable.travelId} = ?',
          whereArgs: [travelId],
        );

        for (final stop in stopData) {
          final stopId = stop[TravelStopTable.travelStopId];

          /// Experiences
          final experiences = <Experience>[];

          final stopExperiences = await txn.query(
            TravelStopExperiencesTable.tableName,
            where: '${TravelStopExperiencesTable.travelStopId} = ?',
            whereArgs: [stopId],
          );

          for (final se in stopExperiences) {
            final experienceId = se[TravelStopExperiencesTable.experienceId];

            final experiencesMap = await txn.query(
              ExperiencesTable.tableName,
              where: '${ExperiencesTable.experienceId} = ?',
              whereArgs: [experienceId],
            );

            if (experiencesMap.isNotEmpty) {
              final expIndex =
                  experiencesMap[0][ExperiencesTable.experienceId] as int;

              if (expIndex >= 0 && expIndex < Experience.values.length) {
                experiences.add(Experience.values[expIndex]);
              }
            }
          }

          final travelStop = TravelStop.fromMap(stop, experiences);
          stops.add(travelStop);
        }

        final travel = Travel.fromMap(
          travelResult,
          participants: participants,
          stops: stops,
        );

        travels.add(travel);
      }
    });

    debugPrint('Travels::\n${travels.join('\n\n')}');
    return travels;
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
