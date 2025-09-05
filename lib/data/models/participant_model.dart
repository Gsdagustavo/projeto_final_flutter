import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../domain/entities/participant.dart';
import '../local/database/tables/participants_table.dart';

/// Model class to represent a [Participant]
///
/// This model class contains methods to manipulate participant data, such as
/// fromMap, toMap, fromEntity, toEntity, etc.
class ParticipantModel {
  /// Participant ID
  final String id;

  /// Participant Name
  final String name;

  /// Participant Age
  final int age;

  /// Participant profile picture
  final File profilePicture;

  /// Named constructor for [ParticipantModel].
  ///
  /// Creates a [ParticipantModel] with required [id], [name], [age],
  /// and [profilePicture].
  ///
  /// [id] is the unique identifier for the participant.
  /// [name] is the participant's full name.
  /// [age] is the participant's age in years.
  /// [profilePicture] is the participant's profile picture stored as a [File].
  ParticipantModel({
    required this.name,
    required this.age,
    required this.profilePicture,
    required this.id,
  });

  /// Returns a Participant from the given Map
  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    Uint8List bytes = map[ParticipantsTable.profilePicture];

    final filename = '${map[ParticipantsTable.participantId]}.png';
    final file = File('${Directory.systemTemp.path}/$filename');
    file.writeAsBytesSync(bytes);

    return ParticipantModel(
      id: map[ParticipantsTable.participantId],
      name: map[ParticipantsTable.name],
      age: map[ParticipantsTable.age],
      profilePicture: file,
    );
  }

  /// Returns a Map with Participant data
  Future<Map<String, dynamic>> toMap() async {
    return {
      ParticipantsTable.participantId: id,
      ParticipantsTable.name: name,
      ParticipantsTable.age: age,
      ParticipantsTable.profilePicture: await profilePicture.readAsBytes(),
    };
  }

  /// fromEntity factory constructor
  factory ParticipantModel.fromEntity(Participant participant) {
    return ParticipantModel(
      id: participant.id,
      name: participant.name,
      age: participant.age,
      profilePicture: participant.profilePicture,
    );
  }

  /// toEntity method
  Participant toEntity() {
    return Participant(
      id: id,
      name: name,
      age: age,
      profilePicture: profilePicture,
    );
  }

  @override
  String toString() {
    return 'ParticipantModel{id: $id, name: $name, age: $age, '
        'profilePicture: $profilePicture}';
  }
}
