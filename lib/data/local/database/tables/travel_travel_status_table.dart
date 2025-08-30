import 'travel_status_table.dart';
import 'travel_table.dart';

/// SQLite table schema and constants for the `travelTravelStatus table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It represents the many-to-many relationship between
/// travel and travel status
abstract final class TravelTravelStatusTable {
  /// Name of the travelTravelStatus table in the database.
  static const String tableName = 'travelTravelStatus';

  /// Column name for the travel ID (foreign key)
  ///
  /// `INTEGER NOT NULL`
  static const String travelId = 'travelId';

  /// Column name for the travel status (foreign key)
  ///
  /// `INTEGER NOT NULL`
  static const String travelStatusIndex = 'travelStatusIndex';

  /// SQL command to create the travelStopExperiences table
  static const String createTable =
      '''
    CREATE TABLE $tableName (
      $travelStatusIndex INTEGER NOT NULL,
      $travelId TEXT NOT NULL,
      FOREIGN KEY ($travelId) REFERENCES ${TravelTable.tableName} (${TravelTable.travelId}),
      FOREIGN KEY ($travelStatusIndex) REFERENCES ${TravelStatusTable.tableName} (${TravelStatusTable.travelStatusIndex}),
      PRIMARY KEY ($travelId, $travelStatusIndex)
    );
  ''';
}
