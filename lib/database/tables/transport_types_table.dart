/// This is a model class to be used when manipulating the TransportTypes Table
/// in the database
class TransportTypesTable {
  /// The name of the table
  static const String tableName = 'transportTypes';

  static const String id = 'id';
  static const String name = 'name';

  /// SQLite command for creating the table
  static const String createTable =
      '''
    CREATE TABLE $tableName(
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT NOT NULL UNIQUE
    );
      ''';
}
