import 'participants_table.dart';
import 'travel_table.dart';

/// SQLite table schema and constants for the `participantTravel` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It is used to represent the many-to-many relationship
/// between participants and travels
abstract final class TravelParticipantsTable {
  /// Name of the participantTravel table in the database
  static const String tableName = 'participantTravel';

  /// Column name for the participant ID (foreign key)
  ///
  /// `INTEGER NOT NULL`
  static const String participantId = 'participantId';

  /// Column name for the travel ID (foreign key)
  ///
  /// `INTEGER NOT NULL`
  static const String travelId = 'travelId';

  /// SQL command to create the participantTravel table
  static const String createTable = '''
    CREATE TABLE $tableName (
      $participantId INTEGER NOT NULL,
      $travelId INTEGER NOT NULL,
      FOREIGN KEY ($participantId) REFERENCES ${ParticipantsTable.tableName} ($participantId),
      FOREIGN KEY ($travelId) REFERENCES ${TravelTable.tableName} (${TravelTable.travelId}),
      PRIMARY KEY ($participantId, $travelId)
    );
  ''';
}
