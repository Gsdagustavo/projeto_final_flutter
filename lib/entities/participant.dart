class Participant {
  final String name;
  final int age;
  final String? profilePictureUrl;

  Participant({
    required this.name,
    required this.age,
    required this.profilePictureUrl,
  });

  @override
  String toString() {
    return 'Participant{name: $name, age: $age, profilePictureUrl: $profilePictureUrl}';
  }
}
