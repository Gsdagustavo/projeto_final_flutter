import 'dart:io';

/// Represents a  [Participant] of a [Travel]
class Participant {
  /// Participant ID
  int? id;

  /// Participant Name
  final String name;

  /// Participant Age
  final int age;

  /// Participant profile picture (path to the file)
  final File? profilePicture;

  /// Named constructor for the participant
  Participant({
    required this.name,
    required this.age,
    this.profilePicture,
    this.id,
    tra,
  });

  @override
  String toString() {
    return 'Participant{name: $name, age: $age, profilePictureUrl: $profilePicture}';
  }
}
