class ParticipantsTable {
  static const String tableName = 'participants';

  static const String participantId = 'participantId';
  static const String name = 'name';
  static const String age = 'age';
  static const String profilePictureUrl = 'profilePictureUrl';

  static const String createTable =
      """
      CREATE TABLE $tableName(
        $participantId INTEGER PRIMARY KEY AUTOINCREMENT,
        $name TEXT NOT NULL,
        $age INTEGER NOT NULL,
        $profilePictureUrl INTEGER
      );
      """;
}
