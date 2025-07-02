class ExperiencesTable {
  static const String tableName = 'experiences';

  static const String experienceId = 'id';
  static const String name = 'name';

  static const String createTable =
      """
    CREATE TABLE $tableName(
      $experienceId INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT NOT NULL UNIQUE
    );
      """;
}
