import 'travel_table.dart';

/// This is a model class to be used when manipulating the TravelStop Table
/// in the database
abstract final class TravelStopTable {
  /// The name of the table
  static const String tableName = 'travelStops';

  static const String travelStopId = 'travelStopId';
  static const String travelId = 'travelId';
  static const String cityName = 'cityName';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';

  /// All dates are represented by millisecondsSinceEpoch
  /// and stored in INTEGER data type
  static const String arriveDate = 'arriveDate';
  static const String leaveDate = 'leaveDate';

  /// SQLite command for creating the table
  static const String createTable =
      '''
      CREATE TABLE $tableName(
        $travelStopId INTEGER PRIMARY KEY AUTOINCREMENT,
        $cityName TEXT NOT NULL,
        $latitude REAL NOT NULL,   
        $longitude REAL NOT NULL,
        $arriveDate INTEGER NOT NULL,
        $leaveDate INTEGER NOT NULL,
        $travelId INTEGER NOT NULL,
        
        FOREIGN KEY ($travelId) REFERENCES ${TravelTable.tableName} (${TravelTable.travelId})
      );
      ''';
}
