import 'transport_types_table.dart';

/// This is a model class to be used when manipulating the Travel Table in the
/// database
abstract final class TravelTable {
  /// The name of the table
  static const String tableName = 'travels';

  static const String travelId = 'travelId';
  static const String travelTitle = 'travelTitle';
  static const String startDate = 'startDate';
  static const String endDate = 'endDate';
  static const String transportType = 'transportType';

  /// SQLite command for creating the table
  static const String createTable =
      '''
    CREATE TABLE $tableName(
      $travelId INTEGER PRIMARY KEY AUTOINCREMENT,
      $travelTitle TEXT NOT NULL,  
      $startDate INTEGER NOT NULL,
      $endDate INTEGER NOT NULL,
      $transportType INTEGER NOT NULL,
      
      FOREIGN KEY ($transportType) REFERENCES ${TransportTypesTable.tableName} (${TransportTypesTable.id})
    );
      ''';
}
