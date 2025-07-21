import 'experiences_table.dart';
import 'travel_stop_table.dart';

/// SQLite table schema and constants for the `travelStopExperiences` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It represents the many-to-many relationship between
/// travel stops and experiences
abstract final class TravelStopExperiencesTable {
  /// Name of the travelStopExperiences table in the database.
  static const String tableName = 'travelStopExperiences';

  /// Column name for the travel stop ID (foreign key)
  ///
  /// `INTEGER NOT NULL`
  static const String travelStopId = 'travelStopId';

  /// Column name for the experience (foreign key)
  ///
  /// `TEXT NOT NULL`
  static const String experience = 'experience';

  /// SQL command to create the travelStopExperiences table
  static const String createTable =
      '''
    CREATE TABLE $tableName (
      $travelStopId INTEGER NOT NULL,
      $experience TEXT NOT NULL,
      FOREIGN KEY ($travelStopId) REFERENCES ${TravelStopTable.tableName} (${TravelStopTable.travelStopId}),
      FOREIGN KEY ($experience) REFERENCES ${ExperiencesTable.tableName} (${ExperiencesTable.experience}),
      PRIMARY KEY ($travelStopId, $experience)
    );
  ''';
}
