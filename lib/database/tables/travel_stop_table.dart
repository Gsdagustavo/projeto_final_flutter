import 'travel_table.dart';

/// This is a model class to be used when manipulating the TravelStop Table
/// in the database
class TravelStopTable {
  /// The name of the table
  static const String tableName = 'travelStops';

  static const String id = 'id';
  static const String travelId = 'travelId';
  static const String cityName = 'cityName';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';

  /// All dates are represented by millisecondsSinceEpoch
  /// and stored in INTEGER data type
  static const String arriveDate = 'arriveDate';
  static const String leaveDate = 'leaveDate';

  /// Represented in seconds
  static const String stayingTime = 'stayingTime';

  /// SQLite command for creating the table
  static const String createTable =
      '''
      CREATE TABLE $tableName(
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $cityName TEXT NOT NULL,
        $latitude REAL NOT NULL,   
        $longitude REAL NOT NULL,
        $arriveDate INTEGER NOT NULL,
        $leaveDate INTEGER NOT NULL,
        $stayingTime INTEGER NOT NULL,
        $travelId INTEGER NOT NULL,
        
        FOREIGN KEY ($travelId) REFERENCES ${TravelTable.tableName} (${TravelTable.travelId})
      );
      ''';
}
