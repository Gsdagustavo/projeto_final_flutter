/// This is a model class to be used when manipulating the Experiences Table
/// in the database
class ExperiencesTable {
  /// The name of the table
  static const String tableName = 'experiences';

  static const String experienceId = 'experienceId';
  static const String name = 'name';

  /// SQLite command for creating the table
  static const String createTable =
      '''
    CREATE TABLE $tableName(
      $experienceId INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT NOT NULL UNIQUE
    );
      ''';
}
