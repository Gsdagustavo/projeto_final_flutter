import 'participants_table.dart';
import 'travel_stop_table.dart';

/// SQLite table schema and constants for the `reviews` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It represents reviews made by participants for travel stops.
abstract final class ReviewsTable {
  /// Name of the reviews table in the database.
  static const String tableName = 'reviews';

  /// Column name for the Review ID.
  ///
  /// `TEXT PRIMARY KEY`
  static const String reviewId = 'reviewId';

  /// Column name for the review description.
  ///
  /// `TEXT`
  static const String description = 'description';

  /// Column name for the review date (timestamp).
  ///
  /// `INTEGER NOT NULL`
  static const String reviewDate = 'reviewDate';

  /// Column name for the review stars (rating).
  ///
  /// `INTEGER NOT NULL`
  static const String stars = 'stars';

  /// Column name for the Travel Stop ID (foreign key).
  ///
  /// References [TravelStopTable.travelStopId]
  static const String travelStopId = TravelStopTable.travelStopId;

  /// Column name for the Participant ID (foreign key).
  ///
  /// References [ParticipantsTable.participantId]
  static const String participantId = ParticipantsTable.participantId;

  /// SQL command to create the reviews table.
  static const String createTable =
      '''
      CREATE TABLE $tableName (
        $reviewId TEXT PRIMARY KEY,
        $description TEXT,
        $reviewDate INTEGER NOT NULL,
        $travelStopId TEXT NOT NULL,
        $participantId TEXT NOT NULL,
        $stars INTEGER NOT NULL,
        
        FOREIGN KEY ($travelStopId) REFERENCES ${TravelStopTable.tableName} (${TravelStopTable.travelStopId}),
        FOREIGN KEY ($participantId) REFERENCES ${ParticipantsTable.tableName} (${ParticipantsTable.participantId})
      );
      ''';
}
