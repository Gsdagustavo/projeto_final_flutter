/// SQLite table schema and constants for the `transportTypes` table.
///
/// This class defines the column names and the SQL statement to create
/// the table
abstract final class TransportTypesTable {
  /// Name of the transportTypes table in the database
  static const String tableName = 'transportTypes';

  /// Column name for the transport type ID
  ///
  /// `INTEGER PRIMARY KEY AUTOINCREMENT`
  static const String id = 'id';

  /// Column name for the transport type name
  ///
  /// `TEXT NOT NULL UNIQUE`
  static const String name = 'name';

  /// SQL command to create the transportTypes table
  static const String createTable = '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT NOT NULL UNIQUE
    );
  ''';
}
