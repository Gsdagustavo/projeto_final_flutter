import 'travel_stop_table.dart';
import 'travel_stop_type_table.dart';

/// SQLite table schema and constants for the `travelStopTravelStopType` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It represents the many-to-many relationship between
/// travel stops and their types.
abstract final class TravelStopTravelStopTypeTable {
  /// Name of the travelStopTravelStopType table in the database.
  static const String tableName = 'travelStopTravelStopType';

  /// Column name for the Travel Stop ID (foreign key).
  ///
  /// References [TravelStopTable.travelStopId]
  static const String travelStopId = TravelStopTable.travelStopId;

  /// Column name for the Travel Stop Type Index (foreign key).
  ///
  /// References [TravelStopTypeTable.travelStopTypeIndex]
  static const String travelStopTypeIndex =
      TravelStopTypeTable.travelStopTypeIndex;

  /// SQL command to create the travelStopTravelStopType table.
  static const String createTable =
      '''
      CREATE TABLE $tableName (
        $travelStopId TEXT NOT NULL,
        $travelStopTypeIndex INTEGER NOT NULL,
        
        FOREIGN KEY ($travelStopId) REFERENCES ${TravelStopTable.tableName} (${TravelStopTable.travelStopId}),
        FOREIGN KEY ($travelStopTypeIndex) REFERENCES ${TravelStopTypeTable.tableName} (${TravelStopTypeTable.travelStopTypeIndex}),
        PRIMARY KEY ($travelStopId, $travelStopTypeIndex)
      );
      ''';
}
