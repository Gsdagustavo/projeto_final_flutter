import '../database/tables/participants_table.dart';

/// Represents a  [Participant] of a [Travel]
class Participant {
  int? id;
  final String name;
  final int age;
  final String? profilePicturePath;

  /// Named constructor for the participant
  Participant({
    required this.name,
    required this.age,
    this.profilePicturePath,
    this.id,
  });

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      id: map[ParticipantsTable.participantId],
      name: map[ParticipantsTable.name],
      age: map[ParticipantsTable.age],
      profilePicturePath: map[ParticipantsTable.profilePicturePath],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ParticipantsTable.participantId: id,
      ParticipantsTable.name: name,
      ParticipantsTable.age: age,
      ParticipantsTable.profilePicturePath: profilePicturePath,
    };
  }

  @override
  String toString() {
    return 'Participant{name: $name, age: $age, profilePictureUrl: $profilePicturePath}';
  }
}
