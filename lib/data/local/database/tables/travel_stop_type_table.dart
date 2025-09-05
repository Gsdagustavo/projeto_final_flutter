/// SQLite table schema and constants for the `travelStopType` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It is used to store the list of possible types that
/// a travel stop can have.
abstract final class TravelStopTypeTable {
  /// Name of the travelStopType table in the database.
  static const String tableName = 'travelStopType';

  /// Column name for the Travel Stop Type Index.
  ///
  /// `INTEGER PRIMARY KEY`
  /// Used to uniquely identify each travel stop type.
  static const String travelStopTypeIndex = 'travelStopTypeIndex';

  /// SQL command to create the travelStopType table.
  static const String createTable =
  '''
      CREATE TABLE $tableName (
        $travelStopTypeIndex INTEGER PRIMARY KEY
      );
      ''';
}
