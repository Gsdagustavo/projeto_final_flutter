import 'participants_table.dart';
import 'travel_stop_table.dart';

abstract final class ReviewsTable {
  static const String tableName = 'reviewTable';

  static const String reviewId = 'reviewId';
  static const String description = 'description';
  static const String reviewDate = 'reviewDate';
  static const String travelStopId = 'travelStopId';
  static const String participantId = 'participantId';
  static const String stars = 'stars';

  static const String createTable =
      '''
     CREATE TABLE $tableName(
      $reviewId INTEGER PRIMARY KEY AUTOINCREMENT,
      $description TEXT NOT NULL,
      $reviewDate INTEGER NOT NULL,
      $travelStopId INTEGER NOT NULL,
      $stars INTEGER NOT NULL,
      $participantId INTEGER NOT NULL,
      
      FOREIGN KEY ($travelStopId) REFERENCES ${TravelStopTable.tableName} (${TravelStopTable.travelStopId}),
      FOREIGN KEY ($participantId) REFERENCES ${ParticipantsTable.tableName} (${ParticipantsTable.participantId})
     )
      ''';
}
