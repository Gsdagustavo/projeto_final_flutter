/// SQLite table schema and constants for the `participants` table.
///
/// This class defines the column names and the SQL statement to create
/// the table
abstract final class ParticipantsTable {
  /// Name of the participants table in the database
  static const String tableName = 'participants';

  /// Column name for the participant ID
  ///
  /// `INTEGER PRIMARY KEY AUTOINCREMENT`
  static const String participantId = 'participantId';

  /// Column name for the participant's name
  ///
  /// `TEXT NOT NULL`
  static const String name = 'name';

  /// Column name for the participant's age
  ///
  /// `INTEGER NOT NULL`
  static const String age = 'age';

  /// Column name for the participant's profile picture
  ///
  /// `BLOB`
  static const String profilePicturePath = 'profilePicture';

  /// SQL command to create the participants table
  static const String createTable =
      '''
    CREATE TABLE $tableName (
      $participantId INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT NOT NULL,
      $age INTEGER NOT NULL,
      $profilePicturePath BLOB
    );
  ''';
}
