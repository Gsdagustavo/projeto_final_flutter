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
  final File profilePicture;

  /// Named constructor for the participant
  Participant({
    required this.name,
    required this.age,
    required this.profilePicture,
    this.id,
    tra,
  });

  Participant copyWith({
    int? id,
    String? name,
    int? age,
    File? profilePicture,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  String toString() {
    return 'Participant{name: $name, age: $age, profilePictureUrl: $profilePicture}';
  }
}
