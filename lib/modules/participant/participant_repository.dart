import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/local/database/database.dart';
import '../../data/local/database/tables/participants_table.dart';
import '../../data/local/database/tables/travel_participants_table.dart';
import '../../data/models/participant_model.dart';
import '../../domain/entities/participant.dart';

/// This interface defines all necessary methods to register participants,
/// get all participants and get participants by a travel id
abstract class ParticipantRepository {
  /// Register a new participant related to a travel
  ///
  /// [participant]: The participant to be added
  /// [travelId]: The Travel ID which the participant will be added
  Future<void> registerParticipant(Participant participantModel, int travelId);

  /// Returns all participants from the database
  ///
  /// Currently, this does not have a purpose in production, but is used
  /// during development stage
  Future<List<Participant>> getAllParticipants();

  /// Returns all participants related to a Travel
  ///
  /// [travelId]: The ID of the Travel which the participant belongs
  Future<List<Participant>> getParticipantsByTravelId(int travelId);
}

/// Concrete implementation of [ParticipantRepository], using local SQLite
/// database
///
/// This class contains all necessary implementations to interact with
/// participants consulting the [ParticipantsTable] and
/// [TravelParticipantsTable] tables
class ParticipantRepositoryImpl implements ParticipantRepository {
  /// Future instance of the database
  late final Future<Database> _db = DBConnection().getDatabase();

  @override
  Future<void> registerParticipant(
    Participant participant,
    int travelId,
  ) async {
    final db = await _db;

    final participantModel = ParticipantModel(
      name: participant.name,
      age: participant.age,
      profilePicturePath: participant.profilePicturePath,
    );

    await db.insert(ParticipantsTable.tableName, participantModel.toMap());

    await db.insert(TravelParticipantsTable.tableName, {
      TravelParticipantsTable.travelId: travelId,
      TravelParticipantsTable.participantId: participantModel.id,
    });
  }

  @override
  Future<List<Participant>> getAllParticipants() async {
    final db = await _db;

    final participants = await db.query(
      ParticipantsTable.tableName,
      orderBy: ParticipantsTable.name,
    );

    return participants.map((e) {
      final participantModel = ParticipantModel.fromMap(e);
      return Participant(
        name: participantModel.name,
        age: participantModel.age,
      );
    }).toList();
  }

  @override
  Future<List<Participant>> getParticipantsByTravelId(int travelId) async {
    final db = await _db;

    final travelParticipants = await db.rawQuery(
      'SELECT * FROM ${TravelParticipantsTable.tableName} as TP '
      'INNER JOIN ${ParticipantsTable.tableName} as P '
      'ON TP.${TravelParticipantsTable.participantId} = P.${ParticipantsTable.participantId} '
      'WHERE ${TravelParticipantsTable.travelId} = ?',
      [travelId],
    );

    final participantsList = travelParticipants
        .map(ParticipantModel.fromMap)
        .toList();
    debugPrint(participantsList.join('\n'));

    return participantsList
        .map(
          (e) => Participant(
            name: e.name,
            age: e.age,
            profilePicturePath: e.profilePicturePath,
          ),
        )
        .toList();
  }
}
