import 'dart:io';

import 'package:uuid/uuid.dart';

/// Represents a [Participant] of a [Travel].
///
/// This class stores information about a participant, including
/// their unique ID, name, age, and profile picture. It also provides
/// a method to create a copy with optional updated fields.
class Participant {
  /// Unique identifier for the participant.
  ///
  /// Automatically generated using a UUID if not provided.
  final String id;

  /// Name of the participant.
  final String name;

  /// Age of the participant in years.
  final int age;

  /// Profile picture of the participant stored as a [File].
  final File profilePicture;

  /// Named constructor for [Participant].
  ///
  /// Creates a new [Participant] instance with required [name], [age],
  /// and [profilePicture]. The [id] is optional; if not provided, a new
  /// UUID will be generated automatically.
  ///
  /// [id] – Unique identifier for the participant (optional).
  /// [name] – Full name of the participant (required).
  /// [age] – Age of the participant in years (required).
  /// [profilePicture] – Profile picture of the participant (required).
  Participant({
    String? id,
    required this.name,
    required this.age,
    required this.profilePicture,
  }) : id = id ?? Uuid().v4();

  /// Returns a copy of this [Participant] with optional updated fields.
  ///
  /// [name] – New name (optional).
  /// [age] – New age (optional).
  /// [profilePicture] – New profile picture (optional).
  Participant copyWith({String? name, int? age, File? profilePicture}) {
    return Participant(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  String toString() {
    return 'Participant{id: $id, name: $name, age: $age, '
        'profilePicture: $profilePicture}';
  }
}
