/// Represents a  [Participant] of a [Travel]
class Participant {
  final String name;
  final int age;
  final String? profilePictureUrl;

  /// Named constructor for the participant
  Participant({
    required this.name,
    required this.age,
    this.profilePictureUrl,
  });

  @override
  String toString() {
    return 'Participant{name: $name, age: $age, profilePictureUrl: $profilePictureUrl}';
  }
}
