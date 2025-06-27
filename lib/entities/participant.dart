import 'package:projeto_final_flutter/entities/travel.dart';

class Participant {
  final String name;
  final List<Travel> travels;
  final int age;
  final String? profilePictureUrl;

  Participant({
    required this.name,
    required this.travels,
    required this.age,
    required this.profilePictureUrl,
  });

  @override
  String toString() {
    return 'Participant{name: $name, travels: $travels, age: $age, profilePictureUrl: $profilePictureUrl}';
  }
}
