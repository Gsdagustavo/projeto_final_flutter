class TransportTypesTable {
  static const String tableName = 'transportTypes';

  static const String id = 'id';
  static const String name = 'name';

  static const String createTable =
      """
    CREATE TABLE $tableName(
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT NOT NULL UNIQUE
    );
      """;
}
