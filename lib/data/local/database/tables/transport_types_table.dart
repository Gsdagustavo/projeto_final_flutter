/// SQLite table schema and constants for the `transportTypes` table.
///
/// This class defines the column names and the SQL statement to create
/// the table
abstract final class TransportTypesTable {
  /// Name of the transportTypes table in the database
  static const String tableName = 'transportTypes';

  /// Column name for the transport type index
  ///
  /// `INTEGER PRIMARY KEY`
  static const String transportTypeIndex = 'transportTypeIndex';

  /// SQL command to create the transportTypes table
  static const String createTable =
      '''
    CREATE TABLE $tableName (
      $transportTypeIndex INTEGER PRIMARY KEY
    );
  ''';
}
