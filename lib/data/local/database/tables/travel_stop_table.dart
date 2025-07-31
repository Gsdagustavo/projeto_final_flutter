import 'places_table.dart';
import 'travel_table.dart';

/// SQLite table schema and constants for the `travelStops` table
///
/// This class defines the column names and the SQL statement to create
/// the table. It is used to store information about specific stops
/// made during a travel, including location and timing data
abstract final class TravelStopTable {
  /// Name of the travelStops table in the database.
  static const String tableName = 'travelStops';

  /// Column name for the travel stop ID
  ///
  /// `INTEGER PRIMARY KEY AUTOINCREMENT`
  static const String travelStopId = 'travelStopId';

  /// Column name for the arrival date (in milliseconds since epoch)
  ///
  /// `INTEGER NOT NULL`
  static const String arriveDate = 'arriveDate';

  /// Column name for the leave date (in milliseconds since epoch)
  ///
  /// `INTEGER NOT NULL`
  static const String leaveDate = 'leaveDate';

  static const String type = 'type';

  static const String placeId = 'placeId';

  /// Column name for the travel ID (foreign key)
  ///
  /// `INTEGER NOT NULL`
  static const String travelId = 'travelId';

  /// SQL command to create the travelStops table
  static const String createTable =
      '''
    CREATE TABLE $tableName (
      $travelStopId INTEGER PRIMARY KEY AUTOINCREMENT,
      $type TEXT NOT NULL,
      $arriveDate INTEGER,
      $leaveDate INTEGER,
      $travelId INTEGER NOT NULL,
      $placeId INTEGER NOT NULL,
      
      FOREIGN KEY ($travelId) REFERENCES ${TravelTable.tableName} (${TravelTable.travelId}),
      FOREIGN KEY ($placeId) REFERENCES ${PlacesTable.tableName} (${PlacesTable.placeId})
    );
  ''';
}
