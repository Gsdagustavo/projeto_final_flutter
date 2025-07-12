import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/participant.dart';
import '../../data/local/database/database.dart';
import '../../data/local/database/tables/participants_table.dart';
import '../../data/local/database/tables/travel_participants_table.dart';

abstract class ParticipantRepository {
  Future<void> registerParticipant(Participant participant, int travelId);

  Future<List<Participant>> getAllParticipants();

  Future<List<Participant>> getParticipantsByTravelId(int travelId);
}

class ParticipantRepositoryImpl implements ParticipantRepository {
  late final Future<Database> _db = DBConnection().getDatabase();

  @override
  Future<void> registerParticipant(
    Participant participant,
    int travelId,
  ) async {
    final db = await _db;

    await db.insert(ParticipantsTable.tableName, participant.toMap());

    await db.insert(TravelParticipantsTable.tableName, {
      TravelParticipantsTable.travelId: travelId,
      TravelParticipantsTable.participantId: participant.id,
    });
  }

  @override
  Future<List<Participant>> getAllParticipants() async {
    final db = await _db;

    final participants = await db.query(
      ParticipantsTable.tableName,
      orderBy: ParticipantsTable.name,
    );

    return participants.map(Participant.fromMap).toList();
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
        .map(Participant.fromMap)
        .toList();
    debugPrint(participantsList.join('\n'));

    return participantsList;
  }
}
