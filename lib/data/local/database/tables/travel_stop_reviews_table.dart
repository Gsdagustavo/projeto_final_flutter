import 'travel_stop_table.dart';

abstract final class TravelStopReviewsTable {
  static const String tableName = 'reviewTable';

  static const String reviewId = 'reviewId';
  static const String travelStopId = 'travelStopId';

  static const String createTable =
      '''
      CREATE TABLE $tableName(
        $reviewId INTEGER NOT NULL,
        $travelStopId INTEGER NOT NULL,
        
        FOREIGN KEY ($travelStopId) REFERENCES ${TravelStopTable.tableName} (${TravelStopTable.travelStopId})
      )
      ''';
}
