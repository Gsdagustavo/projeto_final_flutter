/// SQLite table schema and constants for the `travelStatus` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It is used to store the possible status values
/// that can be associated with a travel.
abstract final class TravelStatusTable {
  /// Name of the travelStatus table in the database.
  static const String tableName = 'travelStatus';

  /// Column name for the travel status index
  ///
  /// `INTEGER PRIMARY KEY`
  static const String travelStatusIndex = 'travelStatusIndex';

  /// SQL command to create the travelStatus table
  static const String createTable =
  '''
      CREATE TABLE $tableName (
        $travelStatusIndex INTEGER PRIMARY KEY
      );
      ''';
}
