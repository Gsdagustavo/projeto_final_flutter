import 'dart:io';

import '../../domain/entities/participant.dart';
import '../local/database/tables/participants_table.dart';

class ParticipantModel {
  /// Participant ID
  int? id;

  /// Participant Name
  final String name;

  /// Participant Age
  final int age;

  /// Participant profile picture (path to the file)
  final File? profilePicture;

  /// Named constructor for the participant
  ParticipantModel({
    required this.name,
    required this.age,
    this.profilePicture,
    this.id,
  });

  /// Returns a Participant from the given Map
  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    return ParticipantModel(
      id: map[ParticipantsTable.participantId],
      name: map[ParticipantsTable.name],
      age: map[ParticipantsTable.age],
      profilePicture: map[ParticipantsTable.profilePicturePath],
    );
  }

  /// Returns a Map with Participant data
  Map<String, dynamic> toMap() {
    return {
      ParticipantsTable.participantId: id,
      ParticipantsTable.name: name,
      ParticipantsTable.age: age,
      ParticipantsTable.profilePicturePath: profilePicture,
    };
  }

  factory ParticipantModel.fromEntity(Participant participant) {
    return ParticipantModel(
      id: participant.id,
      name: participant.name,
      age: participant.age,
      profilePicture: participant.profilePicture,
    );
  }

  Participant toEntity() {
    return Participant(
      id: id,
      name: name,
      age: age,
      profilePicture: profilePicture,
    );
  }

  @override
  String toString() {
    return 'ParticipantModel{id: $id, name: $name, age: $age, profilePicturePath: $profilePicture}';
  }
}
