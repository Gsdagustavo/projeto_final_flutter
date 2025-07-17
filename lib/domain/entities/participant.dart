import '../../data/local/database/tables/participants_table.dart';

/// Represents a  [Participant] of a [Travel]
class Participant {
  /// Participant ID
  int? id;

  /// Participant Name
  final String name;

  /// Participant Age
  final int age;

  /// Participant profile picture (path to the file)
  final String? profilePicturePath;

  /// Named constructor for the participant
  Participant({
    required this.name,
    required this.age,
    this.profilePicturePath,
    this.id,
  });

  /// Returns a Participant from the given Map
  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
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

  @override
  String toString() {
    return 'Participant{name: $name, age: $age, profilePictureUrl: $profilePicturePath}';
  }
}
