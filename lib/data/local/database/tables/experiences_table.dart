/// SQLite table schema and constants for the `experiences` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It is used to store the list of possible experiences that
/// can be associated with travel stops.
abstract final class ExperiencesTable {
  /// Name of the experiences table in the database.
  static const String tableName = 'experiences';

  /// Column name for the experience ID
  ///
  /// `INTEGER PRIMARY KEY AUTOINCREMENT`
  static const String experienceId = 'experienceId';

  /// Column name for the experience name
  ///
  /// `TEXT NOT NULL UNIQUE`
  static const String name = 'name';

  /// SQL command to create the experiences table
  static const String createTable =
      '''
    CREATE TABLE $tableName (
      $experienceId INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT NOT NULL UNIQUE
    );
  ''';
}
