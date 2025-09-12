/// SQLite table schema and constants for the `transportTypes` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It is used to store the list of possible transport types
/// that can be associated with travels or travel stops.
abstract final class TransportTypesTable {
  /// Name of the transportTypes table in the database.
  static const String tableName = 'transportTypes';

  /// Column name for the Transport Type Index.
  ///
  /// `INTEGER PRIMARY KEY`
  /// Used to uniquely identify each transport type.
  static const String transportTypeIndex = 'transportTypeIndex';

  /// SQL command to create the transportTypes table.
  static const String createTable =
      '''
      CREATE TABLE $tableName (
        $transportTypeIndex INTEGER PRIMARY KEY
      );
      ''';
}
