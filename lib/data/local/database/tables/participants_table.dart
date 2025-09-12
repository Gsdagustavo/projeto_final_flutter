import 'travel_table.dart';

/// SQLite table schema and constants for the `participants` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. Each participant belongs to a travel.
abstract final class ParticipantsTable {
  /// Name of the participants table in the database.
  static const String tableName = 'participants';

  /// Column name for the Participant ID.
  ///
  /// `TEXT PRIMARY KEY`
  static const String participantId = 'participantId';

  /// Column name for the participant's name.
  ///
  /// `TEXT NOT NULL`
  static const String name = 'name';

  /// Column name for the participant's age.
  ///
  /// `INTEGER NOT NULL`
  static const String age = 'age';

  /// Column name for the participant's profile picture.
  ///
  /// `BLOB`
  static const String profilePicture = 'profilePicture';

  /// Column name for the Travel ID (foreign key).
  ///
  /// References [TravelTable.travelId]
  static const String travelId = TravelTable.travelId;

  /// SQL command to create the participants table.
  static const String createTable =
      '''
      CREATE TABLE $tableName (
        $participantId TEXT PRIMARY KEY,
        $travelId TEXT NOT NULL,
        $name TEXT NOT NULL,
        $age INTEGER NOT NULL,
        $profilePicture BLOB,
        
        FOREIGN KEY ($travelId) REFERENCES ${TravelTable.tableName} (${TravelTable.travelId})
      );
      ''';
}
