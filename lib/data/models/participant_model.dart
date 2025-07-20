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
  final String? profilePicturePath;

  /// Named constructor for the participant
  ParticipantModel({
    required this.name,
    required this.age,
    this.profilePicturePath,
    this.id,
  });

  /// Returns a Participant from the given Map
  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    return ParticipantModel(
      id: map[ParticipantsTable.participantId],
      name: map[ParticipantsTable.name],
      age: map[ParticipantsTable.age],
      profilePicturePath: map[ParticipantsTable.profilePicturePath],
    );
  }

  /// Returns a Map with Participant data
  Map<String, dynamic> toMap() {
    return {
      ParticipantsTable.participantId: id,
      ParticipantsTable.name: name,
      ParticipantsTable.age: age,
      ParticipantsTable.profilePicturePath: profilePicturePath,
    };
  }

  factory ParticipantModel.fromEntity(Participant participant) {
    return ParticipantModel(
      id: participant.id,
      name: participant.name,
      age: participant.age,
      profilePicturePath: participant.profilePicturePath,
    );
  }

  Participant toEntity() {
    return Participant(
      id: id,
      name: name,
      age: age,
      profilePicturePath: profilePicturePath,
    );
  }

  @override
  String toString() {
    return 'ParticipantModel{id: $id, name: $name, age: $age, profilePicturePath: $profilePicturePath}';
  }
}
