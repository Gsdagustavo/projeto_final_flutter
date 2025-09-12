import 'travel_status_table.dart';
import 'travel_table.dart';

/// SQLite table schema and constants for the `travelTravelStatus` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It represents the many-to-many relationship between
/// travels and their status.
abstract final class TravelTravelStatusTable {
  /// Name of the travelTravelStatus table in the database.
  static const String tableName = 'travelTravelStatus';

  /// Column name for the Travel ID (foreign key).
  ///
  /// References [TravelTable.travelId]
  static const String travelId = TravelTable.travelId;

  /// Column name for the Travel Status Index (foreign key).
  ///
  /// References [TravelStatusTable.travelStatusIndex]
  static const String travelStatusIndex = TravelStatusTable.travelStatusIndex;

  /// SQL command to create the travelTravelStatus table.
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
