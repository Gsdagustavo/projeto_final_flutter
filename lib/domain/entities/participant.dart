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
    tra,
  });

  @override
  String toString() {
    return 'Participant{name: $name, age: $age, profilePictureUrl: $profilePicturePath}';
  }
}
