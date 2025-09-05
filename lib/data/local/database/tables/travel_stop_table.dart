import 'places_table.dart';
import 'transport_types_table.dart';
import 'travel_stop_type_table.dart';
import 'travel_table.dart';

/// SQLite table schema and constants for the `travelStops` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It is used to store information about specific stops
/// made during a travel, including location, timing, and stop type.
abstract final class TravelStopTable {
  /// Name of the travelStops table in the database.
  static const String tableName = 'travelStops';

  /// Column name for the Travel Stop ID.
  ///
  /// `TEXT PRIMARY KEY`
  /// Used to uniquely identify each travel stop.
  static const String travelStopId = 'travelStopId';

  /// Column name for the arrival date (in milliseconds since epoch).
  ///
  /// `INTEGER`
  static const String arriveDate = 'arriveDate';

  /// Column name for the leave date (in milliseconds since epoch).
  ///
  /// `INTEGER`
  static const String leaveDate = 'leaveDate';

  /// Column name for the type of stop (foreign key).
  ///
  /// References [TravelStopTypeTable.travelStopTypeIndex]
  static const String type = TravelStopTypeTable.travelStopTypeIndex;

  /// Column name for the Place ID (foreign key).
  ///
  /// References [PlacesTable.placeId]
  static const String placeId = PlacesTable.placeId;

  /// Column name for the Travel ID (foreign key).
  ///
  /// References [TravelTable.travelId]
  static const String travelId = TravelTable.travelId;

  /// SQL command to create the travelStops table.
  static const String createTable =
      '''
      CREATE TABLE $tableName (
        $travelStopId TEXT PRIMARY KEY,
        $type INTEGER NOT NULL,
        $arriveDate INTEGER,
        $leaveDate INTEGER,
        $travelId INTEGER NOT NULL,
        $placeId INTEGER NOT NULL,
        
        FOREIGN KEY ($travelId) REFERENCES ${TravelTable.tableName} (${TravelTable.travelId}),
        FOREIGN KEY ($placeId) REFERENCES ${PlacesTable.tableName} (${PlacesTable.placeId}),
        FOREIGN KEY ($type) REFERENCES ${TransportTypesTable.tableName} (${TransportTypesTable.transportTypeIndex})
      );
      ''';
}
