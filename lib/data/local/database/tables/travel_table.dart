import 'transport_types_table.dart';

/// SQLite table schema and constants for the `travels` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. Each record represents a travel, including title, dates,
/// transport type, and status.
abstract final class TravelTable {
  /// Name of the travels table in the database.
  static const String tableName = 'travels';

  /// Column name for the Travel ID.
  ///
  /// `TEXT PRIMARY KEY`
  /// Used to uniquely identify each travel.
  static const String travelId = 'travelId';

  /// Column name for the travel title.
  ///
  /// `TEXT NOT NULL`
  static const String travelTitle = 'travelTitle';

  /// Column name for the travel start date (in milliseconds since epoch).
  ///
  /// `INTEGER NOT NULL`
  static const String startDate = 'startDate';

  /// Column name for the travel end date (in milliseconds since epoch).
  ///
  /// `INTEGER NOT NULL`
  static const String endDate = 'endDate';

  /// Column name for the travel transport type (foreign key).
  ///
  /// References [TransportTypesTable.transportTypeIndex]
  static const String transportType = TransportTypesTable.transportTypeIndex;

  /// SQL command to create the travels table.
  static const String createTable =
  '''
      CREATE TABLE $tableName (
        $travelId TEXT PRIMARY KEY,
        $travelTitle TEXT NOT NULL,
        $startDate INTEGER NOT NULL,
        $endDate INTEGER NOT NULL,
        $transportType INTEGER NOT NULL,
        FOREIGN KEY ($transportType) REFERENCES ${TransportTypesTable.tableName} (${TransportTypesTable.transportTypeIndex})
      );
      ''';
}
