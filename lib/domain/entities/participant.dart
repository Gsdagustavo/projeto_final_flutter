import 'dart:io';

import 'package:uuid/uuid.dart';

/// Represents a  [Participant] of a [Travel]
class Participant {
  /// Participant ID
  final String id;

  /// Participant Name
  final String name;

  /// Participant Age
  final int age;

  /// Participant profile picture (path to the file)
  final File profilePicture;

  /// Named constructor for the participant
  Participant({
    String? id,
    required this.name,
    required this.age,
    required this.profilePicture,
  }) : id = id ?? Uuid().v4();

  Participant copyWith({String? name, int? age, File? profilePicture}) {
    return Participant(
      name: name ?? this.name,
      age: age ?? this.age,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  String toString() {
    return 'Participant{name: $name, age: $age, '
        'profilePicture: $profilePicture}';
  }
}
